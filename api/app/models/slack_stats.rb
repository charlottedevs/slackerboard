class SlackStats < ApplicationRecord
  belongs_to :slack_user
  belongs_to :user
end
