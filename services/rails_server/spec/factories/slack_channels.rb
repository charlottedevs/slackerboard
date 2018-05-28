FactoryBot.define do
  factory :slack_channel do
    sequence(:slack_identifier) { |n| "identifier#{n}" }
    sequence(:name) { |n| "channel#{n}" }
  end
end
