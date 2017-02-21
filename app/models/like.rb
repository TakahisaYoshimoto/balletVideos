class Like < ApplicationRecord
  belongs_to :youtube_video, counter_cache: :likes_count
  belongs_to :user
end
