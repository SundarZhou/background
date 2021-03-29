class AddIsMengGuToAccount < ActiveRecord::Migration[5.2]
  def change
    add_column :accounts, :is_meng_gu, :boolean, default: false
  end
end
