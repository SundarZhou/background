class AddGetAcctounDataButton < ActiveRecord::Migration[5.2]
  def change
    add_column :settings, :get_account_data_button, :boolean, default: true
  end
end
