class UploadFilesController < ApplicationController
  # require 'fileutils'
  skip_before_action :authenticate_user!, :only => [:download_file, :download_txt_file]

  def index
    @upload_files = params[:type] != 'txt' ? UploadFile.plist : UploadFile.txt

  end

  def destroy
    @upload_file = UploadFile.find_by_id params[:id]
    path_to_file = @upload_file&.file_path
    File.delete(path_to_file) if path_to_file && File.exist?(path_to_file)
    @upload_file.destroy
    redirect_to upload_files_path, notice:"成功删除!"
  end

  def batch_destroy_files
    @upload_files = UploadFile.where(id: params[:upload_file_ids].split(","))
    @upload_files.destroy_all
    respond_to do |format|
      format.json{
        render json: {
          message: "成功"
        }
      }
    end
  end

  def new
    if params[:type] != 'txt'
      @upload_file = UploadFile.plist.new
    else
      @upload_file = UploadFile.txt.new
    end
  end

  def create
    @file_type = params[:upload_file][:file_type] ==  "1" ? "txt" : "plist"
    @upload_file = UploadFile.new
    if params[:tasks_file].present?
      file = params[:tasks_file]
      if file.original_filename.split('.').last == @file_type
        file_name = uploadFile(params[:tasks_file])
        if UploadFile.find_or_create_by(file_name: file_name, file_type: @file_type)
          redirect_to upload_files_path(type: @file_type), notice: "上传成功！"
        else
          redirect_to upload_files_path, notice: @upload_file.errors.full_messages.to_sentence
        end
      else
        redirect_to upload_files_path(type: @file_type), notice: "约定好的文件格式为 XXX.#{@file_type}"
      end
    else
      redirect_to upload_files_path(type: @file_type), notice: "上传有误，请检查数据重新上传！"
    end
  end

  def download_files
    @upload_file = UploadFile.find_by_file_name params[:file_name]
    if @upload_file&.file_path.present?
      send_file(@upload_file.file_path)
    else
      render json: {message: "文件不存在"}
    end
  end

  def download_file
    if Setting.first.file_switch
      @upload_file = UploadFile.find_by_file_name params[:file_name]
      if @upload_file&.file_path.present?
        send_file(@upload_file.file_path)
      else
        render json: {message: "文件不存在"}
      end
    else
      render json: {message: "当前不可获取文件"}
    end
  end

  def download_txt_file
    @upload_file = UploadFile.find_by_file_name params[:file_name]
    if @upload_file&.file_path.present? && @upload_file&.txt?
      send_file(@upload_file.file_path)
    else
      render json: {message: "文件不存在"}
    end
  end

  def uploadFile(file)
    if !file.original_filename.empty?
      @filename = getFileName(file.original_filename)
      FileUtils.mkdir_p File.join("#{Rails.root}/public/upload_files")
      File.open("#{Rails.root}/public/upload_files/#{@filename}", "wb") do |f|
        f.write(file.read)
      end
      return @filename
    end

  end

  def getFileName(filename)
    if !filename.nil?
      return filename
    end
  end

end
