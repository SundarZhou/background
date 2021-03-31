class SettingController < ApplicationController
  def new
  end

  def toggle_switch
    Setting.first.toggle
  end
end
