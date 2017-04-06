class Board < ApplicationRecord
  belongs_to :user
  has_many :board_comments, dependent: :destroy
  has_many :board_tags, dependent: :destroy
  validates :title, presence: true, length: { maximum: 200 }

  paginates_per 20  # 1ページあたり20項目表示

  accepts_nested_attributes_for :board_tags,
                                allow_destroy: true,
                                reject_if: proc { |attributes| attributes['name'].blank? }
end
