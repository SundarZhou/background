class AddListNumToInformations < ActiveRecord::Migration[5.2]
  def change
    add_column :information, :list_num, :integer, default: 1
  end
end
