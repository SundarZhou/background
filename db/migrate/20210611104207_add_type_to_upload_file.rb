class AddTypeToUploadFile < ActiveRecord::Migration[5.2]
  def change
    add_column :upload_files, :file_type, :integer, default: 0
  end
end
