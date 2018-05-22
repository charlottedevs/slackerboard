class SlackMessage < ApplicationRecord
  belongs_to :user
  belongs_to :slack_channel
end
