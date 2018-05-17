FactoryBot.define do
  factory :channel_stat do
    slack_channel
    user
    messages_given 1
  end
end
