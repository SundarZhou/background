class CreatePlatforms < ActiveRecord::Migration[5.2]
  def change
    create_table :platforms do |t|
      t.text :data
      t.integer :is_use, :default => 0

      t.timestamps
    end
  end
end
