FactoryGirl.define do
  factory :youtube_video do
    title 'title'
    text 'text'
    category 'category'
    sequence(:url) { |n| "url#{n}" }
  end
end
