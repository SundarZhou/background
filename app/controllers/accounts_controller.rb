class AccountsController < ApplicationController
  include ActionView::Rendering
  before_action :find_account, only: [ :edit, :update,:destroy]
  skip_before_action :authenticate_user!, :only => :import_data
  def index
    @accounts = Account.all
  end

  def destroy
    @account.destroy
    redirect_to accounts_path, notice:"成功删除!"
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
    respond_to do |format|
       format.xlsx {render xlsx: 'download',filename: "accounts#{Time.now.strftime("%Y-%m-%d %H:%M:%S") }.xlsx"}
    end
  end

  def batch_destroy
    @accounts = Account.where(id: params[:account_ids].split(","))
    @accounts.destroy_all
    redirect_to accounts_path, notice:"批量删除成功!"
  end

  def import_data
    phone = params[:phone]
    password = params[:password]
    token = params[:token]
    time = params[:time]
    link = params[:link]
    @account = Account.new(phone: phone, password: password, token: token, time: time, link: link)
    rep = if @account.save
            { code: 200, message: "导入成功！"}
          else
            { code: 404, message: @account.errors.full_messages.to_sentence}
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
