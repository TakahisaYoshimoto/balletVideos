class ViewHistory < ApplicationRecord
  belongs_to :youtube_video
  belongs_to :user
end
