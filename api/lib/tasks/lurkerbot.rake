namespace :lurkerbot do
  desc "start the lurkerbot"
  task start: :environment do
    Rails.logger = Logger.new(STDOUT)
    LurkerBot.start
  end
end
