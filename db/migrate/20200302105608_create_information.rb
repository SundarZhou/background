class CreateInformation < ActiveRecord::Migration[5.2]
  def change
    create_table :information do |t|
      t.string :account
      t.string :link
      t.integer :is_use, :default => 0

      t.timestamps
    end
  end
end
