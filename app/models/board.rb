class Board < ApplicationRecord
  belongs_to :user
  has_many :board_comments, dependent: :destroy
  has_many :board_likes, dependent: :destroy
  has_many :board_tags, dependent: :destroy
  validates :title, presence: true, length: { maximum: 200 }

  scope :board_search, ->(name) {
    where(id: BoardTag.where("title like ? OR board_tags.name like ?", name, name).select(:board_id))
  }

  def like_user(user_id)
   board_likes.find_by(user_id: user_id)
  end

  paginates_per 20  # 1ページあたり20項目表示

  accepts_nested_attributes_for :board_tags,
                                allow_destroy: true,
                                reject_if: proc { |attributes| attributes['name'].blank? }
end
