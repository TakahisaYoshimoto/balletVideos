class YoutubeVideo < ApplicationRecord
  has_many :youtube_video_tags, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :view_histories
  def like_user(user_id)
   likes.find_by(user_id: user_id)
  end
  
  accepts_nested_attributes_for :youtube_video_tags,
                                allow_destroy: true,
                                reject_if: proc { |attributes| attributes['name'].blank? }

  validates :title, presence: true
  validates :url, uniqueness: true, presence: true
  validates :category, presence: true

  #PV数保存の為のGemの関数
  is_impressionable :counter_cache => true, :column_name => :pv_count, unique: :all

  paginates_per 21  # 1ページあたり4項目表示

  extend OrderAsSpecified #gem extend OrderAsSpecified で並び替えする為の記述
end