class AccountsController < ApplicationController
  include ActionView::Rendering
  before_action :find_account, only: [ :edit, :update,:destroy]
  skip_before_action :authenticate_user!, :only => [:import_data, :privacy_policy_setting, :wait_button_setting, :get_account, :get_account_data_setting]
  def index
    @accounts = if params[:is_meng_gu].present?
                  Account.is_meng_gu
                elsif params[:is_normal].present?
                  Account.unnormal
                else
                  Account.normal
                end
  end

  def destroy
    @account.destroy
    redirect_to accounts_path(is_normal: params[:is_normal]), notice:"成功删除!"
  end

  # def update
  #   if @account.update(account_params)
  #     redirect_to account_path, notice: "修改成功！"
  #   else
  #     render 'edit'
  #   end
  # end
  def download
    @accounts = Account.where(id: params[:account_ids].split(","))

    @accounts.update_all(is_export: true)
    output = ''

    @accounts.pluck(:phone, :password, :token, :link, :time).each do |account|
      output << account.join("----")
      output << "\n"
    end
    path = "#{Rails.root}/log/accounts-#{Time.now.strftime('%Y-%m-%d-%H-%M-%S')}.txt"
    file = File.open(path, 'a')
    file.write(output)

    file.close
    log = DownloadLog.find_or_create_by(time: Time.now.strftime("%Y/%m/%d"), is_meng_gu: @accounts.first.is_meng_gu?)
    ids = log.is_meng_gu? ? @accounts.is_meng_gu.pluck(:id) : @accounts.normal.pluck(:id)
    log.ids = (log.ids.to_a + ids).uniq
    log.save

    respond_to do |format|
      format.json{
        render json: {
          path: path
        }
      }
    end

    # send_data(output, :filename => "accounts-#{Time.now.strftime('%Y-%m-%d-%H-%M')}.txt",:type => 'text; charset=utf-8')
    # respond_to do |format|
    #    format.json {render xlsx: 'download',filename: "accounts#{Time.now.strftime("%Y-%m-%d %H:%M:%S") }.xlsx"}
    # end
  end

  def get_file
    path = params["path"]
    send_file(path)
  end

  def batch_destroy
    @accounts = Account.where(id: params[:account_ids].split(","))
    @accounts.destroy_all
    respond_to do |format|
      format.json{
        render json: {
          message: "成功"
        }
      }
    end
  end

  def import_data
    phone = params[:phone]
    password = params[:password]
    token = params[:token]
    time = params[:time]
    operator = params[:operator]
    is_normal = params[:is_normal]
    link = params[:link]
    is_meng_gu = params[:is_meng_gu]
    @account = Account.new(phone: phone, password: password, token: token, time: time, operator: operator, is_normal: is_normal, link: link, is_meng_gu: is_meng_gu)
    rep = if @account.save
            if @account.is_normal
              log = ImportLog.find_or_create_by(operator: operator, time: Time.now.strftime("%Y/%m/%d"))
              log.ids = (log.ids.to_a + [@account.id]).uniq
              log.save
            end
            { code: 200, message: "导入成功！"}
          else
            { code: 404, message: @account.errors.full_messages.to_sentence}
          end
    render :json => rep
  end

  def privacy_policy_setting
    render :json => { code: 200, privacy_policy_setting: Setting.last.privacy_policy}
  end

  def get_account_data_setting
    render :json => { code: 200, get_account_data_setting: Setting.last.get_account_data_button}
  end

  def wait_button_setting
    render :json => { code: 200, wait_button_setting: Setting.last.wait_button}
  end

  def get_account
    @account = Account.first
    begin
      rep = if !Setting.first.get_account_data_button
        {
          code: 200,
          data: {status: false},
          message: "等待开启帐号获取"
        }
      elsif @account.present?
        @account.update(is_got: true)
        {
              code: 200,
              data: {id: @account.id, phone: @account.phone, password: @account.password, token: @account.token, link: @account.link },
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
      rep = {
        code: 404,
        data: {status: false, error_message: e.message},
        message: e
      }
    end
    render :json => rep
  end

  private
  def find_account
    @account = Account.find(params[:id])
    rescue => e
     redirect_to account_path,alert:"没有找到数据!"
  end

  # def account_params
  #   params.require(:account).permit(:title)
  # end
  def render_to_body(options)
    _render_to_body_with_renderer(options) || super
  end

  # def download_csv(accounts)
  #   CSV.generate(:col_sep => ",") do |csv|
  #     csv << ['手机号码', '密码', '数据']
  #     accounts.each do |account|
  #       csv << [account.phone, account.password, account.token]
  #     end
  #   end
  # end
end
