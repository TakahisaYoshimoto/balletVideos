FactoryGirl.define do
  factory :user do
    sequence(:username) { |n| "user#{n}" }
    email { "#{username}@example.com" }
    password 'password'
    password_confirmation 'password'
    confirmed_at Date.today

    factory :user_level1 do
      user_level 1
    end

    factory :user_level2 do
      user_level 2
    end

  end
end
