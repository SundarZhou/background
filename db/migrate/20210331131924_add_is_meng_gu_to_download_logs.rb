class AddIsMengGuToDownloadLogs < ActiveRecord::Migration[5.2]
  def change
    add_column :download_logs, :is_meng_gu, :boolean, default: false
    add_column :settings, :switch, :boolean, default: true
  end
end
