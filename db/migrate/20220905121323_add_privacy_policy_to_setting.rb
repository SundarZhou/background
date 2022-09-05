class AddPrivacyPolicyToSetting < ActiveRecord::Migration[5.2]
  def change
    add_column :settings, :privacy_policy, :boolean, default: true
  end
end
