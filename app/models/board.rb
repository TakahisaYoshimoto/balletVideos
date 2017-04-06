class Board < ApplicationRecord
  belongs_to :user
  has_many :board_comments
  validates :title, presence: true, length: { maximum: 200 }
  #validates :category, presence: true
end
