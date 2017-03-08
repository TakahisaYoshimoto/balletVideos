FactoryGirl.define do
  factory :user do
    sequence(:username) { |n| "user#{n}" }
    email { "#{username}@example.com" }
    password 'password'
    password_confirmation 'password'
  end
end
