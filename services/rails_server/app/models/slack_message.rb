class SlackMessage < ApplicationRecord
  belongs_to :user, counter_cache: true
  belongs_to :slack_channel
end
