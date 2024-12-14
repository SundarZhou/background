class Setting < ApplicationRecord
  def toggle
    update(switch: !switch)
  end

  def list_toggle
    update(list_switch: !list_switch)
  end

  def toggle_file_switch
    update(file_switch: !file_switch)
  end

  def privacy_policy_toggle
    update(privacy_policy: !privacy_policy)
  end

  def wait_button_toggle
    update(wait_button: !wait_button)
  end

  def get_account_data_toggle
    update(get_account_data_button: !get_account_data_button)
  end
end
