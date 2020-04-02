class CreateAbnormals < ActiveRecord::Migration[5.2]
  def change
    create_table :abnormals do |t|
      t.string :phone, null: false
      t.string :code, null: false

      t.timestamps
    end
  end
end
