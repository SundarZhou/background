class AddFileSwitchToSetting < ActiveRecord::Migration[5.2]
  def change
    add_column :settings, :file_switch, :boolean, default: true
  end
end
