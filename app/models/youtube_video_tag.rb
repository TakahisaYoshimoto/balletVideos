class YoutubeVideoTag < ApplicationRecord
  belongs_to :youtube_video, required: false
end
