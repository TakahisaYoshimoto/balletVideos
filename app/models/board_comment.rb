class BoardComment < ApplicationRecord
  belongs_to :board, counter_cache: true
  belongs_to :user
  validates :text, presence: true, length: { maximum: 800 }
end
