class SettingController < ApplicationController
  def new
  end

  def toggle_switch
    Setting.first.toggle
  end

  def toggle_file_switch
    Setting.first.toggle_file_switch
  end
end
