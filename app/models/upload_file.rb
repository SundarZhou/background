class UploadFile < ApplicationRecord
  before_save :init_path
  enum file_type: {
    plist: 0,
    txt: 1
  }
  def init_path
    self.file_path = "#{Rails.root}/public/upload_files/#{file_name}"
  end

  def link
    "download_file?file_name=#{self.file_name}"
  end

  def links
    "download_files?file_name=#{self.file_name}"
  end
end
