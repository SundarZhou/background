class SettingController < ApplicationController
  def new
  end

  def toggle_switch
    if params[:privacy_policy]
      Setting.first.privacy_policy_toggle
    elsif params[:list2]
      Setting.first.list_toggle
    else
      Setting.first.toggle
    end
  end

  def toggle_file_switch
    Setting.first.toggle_file_switch
  end
end
