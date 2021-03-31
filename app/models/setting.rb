class Setting < ApplicationRecord
  def toggle
    update(switch: !switch)
  end
end
