class Information < ApplicationRecord
  scope :list2, -> { where(list_num: 2) }
  scope :default, -> { where(list_num: 1) }
end
