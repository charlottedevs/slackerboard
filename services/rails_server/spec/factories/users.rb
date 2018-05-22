FactoryBot.define do
  factory :user do
    slack_identifier 'U2147483697'
    sequence(:slack_handle) { |n| "handle#{n}" }
    real_name 'Cool Guy'
    profile_image 'https://avatars3.githubusercontent.com/u/6183?s=200&v=4'
  end
end
