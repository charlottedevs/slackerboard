namespace :emoji do
  desc "update local cache of Slack custom emoji"
  task update: :environment do
    UpdateSlackEmoji.call
  end
end
