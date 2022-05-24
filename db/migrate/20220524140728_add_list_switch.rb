class AddListSwitch < ActiveRecord::Migration[5.2]
  def change
    add_column :settings, :list_switch, :boolean, default: true
  end
end
