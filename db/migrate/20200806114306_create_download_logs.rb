class CreateDownloadLogs < ActiveRecord::Migration[5.2]
  def change
    create_table :download_logs do |t|
      t.string :time
      t.string :ids

      t.timestamps
    end
  end
end
