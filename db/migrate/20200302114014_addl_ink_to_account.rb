class AddlInkToAccount < ActiveRecord::Migration[5.2]
  def change
    add_column :accounts, :link, :string
  end
end
