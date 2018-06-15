namespace :lurkerbot do
  desc "start the lurkerbot"
  task start: :environment do
    LurkerBot.start
  end
end
