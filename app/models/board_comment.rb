class BoardComment < ApplicationRecord
  belongs_to :board
  belongs_to :user
  validates :text, presence: true, length: { maximum: 800 }
end
