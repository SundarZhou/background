class ImportLogsController < ApplicationController
  def index
    @logs = ImportLog.where(time: Time.now.strftime("%Y/%m/%d")) #.page(params[:page]).per(20)
  end

  def destroy
    @log = ImportLog.find_by_id params[:id]
    if @log.present? && @log.destroy
      redirect_to import_logs_path, notice:"成功删除!"
    else
      redirect_to import_logs_path, notice:"删除的数据不存在!"
    end
  end

end