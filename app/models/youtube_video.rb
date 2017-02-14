class YoutubeVideo < ApplicationRecord
  has_many :youtube_video_tags, dependent: :destroy
  accepts_nested_attributes_for :youtube_video_tags,
                                allow_destroy: true,
                                reject_if: proc { |attributes| attributes['name'].blank? }

  validates :title, presence: true
  validates :url, uniqueness: true, presence: true

  paginates_per 12  # 1ページあたり4項目表示

  extend OrderAsSpecified #gem extend OrderAsSpecified で並び替えする為の記述
end