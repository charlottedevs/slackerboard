FactoryBot.define do
  factory :slack_reaction do
    user
    emoji "+1"
    target "message"
    slack_identifier "1360782400.498405"
  end
end
