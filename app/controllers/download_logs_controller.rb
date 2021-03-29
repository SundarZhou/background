class DownloadLogsController < ApplicationController
  def index
    @logs = DownloadLog.order("created_at desc") #.page(params[:page]).per(20)
  end

  def destroy
    @log = DownloadLog.find_by_id params[:id]
    if @log.present? && @log.destroy
      redirect_to download_logs_path, notice:"成功删除!"
    else
      redirect_to download_logs_path, notice:"删除的数据不存在!"
    end
  end

end