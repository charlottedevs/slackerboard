namespace :emoji do
  desc "update local cache of Slack custom emoji"
  task update: :environment do
    Rails.logger = Logger.new(STDOUT)
    UpdateSlackEmoji.call
  end
end
