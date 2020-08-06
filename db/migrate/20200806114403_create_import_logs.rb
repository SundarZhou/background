class CreateImportLogs < ActiveRecord::Migration[5.2]
  def change
    create_table :import_logs do |t|
      t.string :time
      t.string :ids
      t.string :operator

      t.timestamps
    end
  end
end
