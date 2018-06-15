FactoryBot.define do
  factory :user do
    sequence(:slack_identifier) { |n| "identifier#{n}" }
    sequence(:slack_handle) { |n| "handle#{n}" }
    real_name 'Cool Guy'
    profile_image 'https://avatars3.githubusercontent.com/u/6183?s=200&v=4'
  end
end
