class ChangeStringLimit < ActiveRecord::Migration[5.2]
  def change
    change_column :download_logs, :ids, :text, :limit => 16777215
    change_column :import_logs, :ids, :text, :limit => 16777215
  end
end
