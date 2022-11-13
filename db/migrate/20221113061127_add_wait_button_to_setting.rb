class AddWaitButtonToSetting < ActiveRecord::Migration[5.2]
  def change
    add_column :settings, :wait_button, :boolean, default: true
  end
end
