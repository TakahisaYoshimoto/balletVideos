class Comment < ApplicationRecord
  belongs_to :user

  validates :text, presence: true, length: { maximum: 401 }
end
