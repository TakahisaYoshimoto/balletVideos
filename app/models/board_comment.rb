class BoardComment < ApplicationRecord
  belongs_to :board, counter_cache: true
  belongs_to :user
  validates :text, presence: true, length: { maximum: 800 }

  paginates_per 20  # 1ページあたり20項目表示
end
