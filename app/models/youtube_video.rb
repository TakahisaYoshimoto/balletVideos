class YoutubeVideo < ApplicationRecord
  has_many :youtube_video_tags, dependent: :destroy
  accepts_nested_attributes_for :youtube_video_tags,
                                allow_destroy: true,
                                reject_if: proc { |attributes| attributes['name'].blank? }

  validates :url, uniqueness: true

  paginates_per 12  # 1ページあたり4項目表示
end