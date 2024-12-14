class AddGetedToAccounts < ActiveRecord::Migration[5.2]
  def change
    add_column :accounts, :is_got, :boolean, default: false
  end
end
