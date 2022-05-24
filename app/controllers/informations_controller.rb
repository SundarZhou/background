class InformationsController < ApplicationController
  skip_before_action :authenticate_user!, :only => [:get_data, :update_data,:import_data, :new_get_data, :new_update_data, :check]
  before_action :find_data, only: [ :edit, :update,:destroy]
  def index
    @informations = if params[:new_import].present?
                      Information.where(account: nil)
                    else
                      Information.where(phone: nil)
                    end
    @informations = params[:list2] ? @informations.list2 :  @informations.default
  end

  def new
    @information = Information.new
  end

  def create
    @information = Information.new
    errors = []
    list_num = params[:list2] ? 2 : 1
    if params[:tasks_file].present?
      file = params[:tasks_file]
      if file.original_filename.split('.').last == 'txt'
        datas = []
        File.open(file.path).each do |line|
          account, link = line.split("----")
          datas << {account: account, link: link.chomp, list_num: list_num} if account.present? && link.present?
        end
        if datas.present?
          begin
            ActiveRecord::Base.transaction do
              Information.import datas
            end
          rescue Exception => e
            redirect_to informations_path(list2: params[:list2]), notice: e
          end

          redirect_to informations_path(list2: params[:list2]), notice: "上传成功！"
        else
          redirect_to informations_path(list2: params[:list2]), notice: "没有数据"
        end

      else
        redirect_to informations_path(list2: params[:list2]), notice: "约定好的文件格式为 XXX.txt"
      end
    else
      redirect_to informations_path(list2: params[:list2]), notice: "上传有误，请检查数据重新上传！"
    end
  end

  def destroy
    link = @data.phone.present? ? informations_path(new_import: true) : informations_path(list2: @data.list_num == 2 ? true : nil)
    @data.destroy
    redirect_to link, notice:"成功删除!"
  end

  def information_download
    @informations = Information.where(id: params[:information_ids].split(","))

    output = ''
    if params[:new_import].present?
      @informations.pluck(:phone, :password ).each do |information|
        output << information.join("----")
        output << "\n"
      end
    else
      @informations.pluck(:account, :link ).each do |information|
        output << information.join("----")
        output << "\n"
      end
    end
    path = "#{Rails.root}/log/informations-#{Time.now.strftime('%Y-%m-%d-%H-%M-%S')}.txt"
    file = File.open(path, 'a')
    file.write(output)

    file.close

    respond_to do |format|
      format.json{
        render json: {
          path: path
        }
      }
    end
  end

  def batch_destroy
    @informations = Information.where(id: params[:information_ids])
    @informations.destroy_all
    respond_to do |format|
      format.json{
        render json: {
          message: "成功"
        }
      }
    end
  end

  def batch_update
    if params[:new_import].present?
      @informations = Information.where(id: params[:information_ids]).where.not(is_use: 2)
    else
      @informations = Information.where(id: params[:information_ids]).where(is_use: 1)
    end
    @informations.update_all(is_use: 0)
    respond_to do |format|
      format.json{
        render json: {
          message: "待修改数据批量修改成功!"
        }
      }
    end
    # redirect_to informations_path, notice:"待修改数据批量修改成功!"
  end

  def delete_success
    if params[:new_import].present?
      Information.where(is_use: 2, account: nil).destroy_all
      @link = informations_path(new_import: true)
    else
      Information.where(is_use: 2, phone: nil).destroy_all
      @link = informations_path
    end

    redirect_to @link, notice:"批量操作成功!"
  end

  def get_data
    if (validation = params[:validation].present?)
      @information = Information.where(is_use: 1, phone: nil, list_num:( params[:list2] ? 2 : 1)).first
    else
      @information = Information.where(is_use: 0, phone: nil, list_num:( params[:list2] ? 2 : 1)).first
    end

    begin

      rep = if !(params[:list2] ? Setting.first.list_switch : Setting.first.switch)
            {
              code: 200,
              data: {status: false},
              message: "等待开启数据获取"
            }
          elsif @information.present?
            @information.update(is_use: (validation ? 3 : 1))
            {
              code: 200,
              data: {id: @information.id, account: @information.account, link: @information.link, status: true },
              message: "返回成功！"
            }
          else
            {
              code: 200,
              data: {status: false},
              message: "没有可用数据"
            }
          end
    rescue Exception => e
      {
        code: 404,
        data: {status: false},
        message: e
      }
    end
    render :json => rep
  end

  def update_data
    @data = Information.find_by_id(params[:id])
    rep = if @data.present?

            if @data.update(is_use: 2)
              {
                code: 200,
                message: "更新成功"
              }
            else
              {
                code: 404,
                message: @data.errors.full_messages.to_sentence
              }
            end
          else
            {
              code: 404,
              message: "数据不存在"
            }
          end
    render :json => rep
  end

  def check
    @arr = ["未使用", "二维码获取成功", "完成", "使用中"]
    @data = Information.find_by_id(params[:id])
    rep = if @data.present?
        {
          code: 200,
          message: @arr[@data.is_use]
        }
    else
      {
        code: 404,
        message: "数据不存在"
      }
    end
render :json => rep
  end

  def new_get_data

    @information = Information.where(is_use: 0, account: nil).first

    begin

      rep = if @information.present?
            @information.update(is_use: 3)
            {
              code: 200,
              data: {id: @information.id, phone: @information.phone, password: @information.password, status: true },
              message: "返回成功！"
            }
          else
            {
              code: 200,
              data: {status: false},
              message: "没有可用数据"
            }
          end
    rescue Exception => e
      {
        code: 404,
        data: {status: false},
        message: e
      }
    end
    render :json => rep
  end

  def new_update_data
    @data = Information.find_by_id(params[:id])
    rep = if @data.present?
            is_use = params[:success].present? ? 2 : 1
            if @data.update(is_use: is_use)
              {
                code: 200,
                message: "更新成功:#{params[:success].present? ? '完成' : '二维码获取成功'}"
              }
            else
              {
                code: 404,
                message: @data.errors.full_messages.to_sentence
              }
            end
          else
            {
              code: 404,
              message: "数据不存在"
            }
          end
    render :json => rep
  end


  def update
    @data = Information.find(params[:id])
    link = @data.phone.present? ? informations_path(new_import: true) : informations_path(list2: @data.list_num == 2 ? true : nil)
    if @data.update(is_use: 0)
      redirect_to link, notice: "更新成功!"
    else
      redirect_to link, alert: @data.errors.full_messages.to_sentence
    end
  end

  def import_data
    phone = params[:phone]
    password = params[:password]

    @information = Information.new(phone: phone, password: password)
    rep = if @information.save
            { code: 200, message: "上传成功", data: {id: @information.id}}
          else
            { code: 404, message: @information.errors.full_messages.to_sentence}
          end
    render :json => rep
  end

  private
  def find_data
    @data = Information.find(params[:id])
    rescue => e
     redirect_to informations_path,alert:"没有找到数据!"
  end

end
