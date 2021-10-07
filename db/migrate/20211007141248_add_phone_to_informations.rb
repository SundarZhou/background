class AddPhoneToInformations < ActiveRecord::Migration[5.2]
  def change
    add_column :information, :phone, :string
    add_column :information, :password, :string
  end
end