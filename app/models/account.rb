class Account < ApplicationRecord
  scope :normal, -> { where(is_normal: true, is_meng_gu: false) }
  scope :unnormal, -> { where(is_normal: false) }
  scope :is_meng_gu, -> { where(is_normal: true, is_meng_gu: true) }
end
