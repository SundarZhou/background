class DownloadLog < ApplicationRecord
  serialize :ids
  scope :is_meng_gu, -> { where(is_meng_gu: true) }
  scope :default, -> { where(is_meng_gu: false) }
end
