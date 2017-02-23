class TopTagList < ApplicationRecord
  validates :tag_name, presence: true
  validates :hurigana, presence: true
end
