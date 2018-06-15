FactoryBot.define do
  factory :slack_message do
    user
    slack_channel
    ts "MyString"
  end
end
