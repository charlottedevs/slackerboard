# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


user = FactoryBot.create(:user)
channel = FactoryBot.create(:slack_channel, slack_identifier:  'G024BE91L')
FactoryBot.create(:slack_reaction, user: user)
FactoryBot.create(:slack_message, user: user, slack_channel: channel)

# user with messages in the past and also this week
user2 = FactoryBot.create(:user)
FactoryBot.create(:slack_message, user: user2, slack_channel: channel)
FactoryBot.create(:slack_message, created_at: 3.years.ago, user: user2, slack_channel: channel)


# user with a old and new messages + reactions
user3 = FactoryBot.create(:user)
FactoryBot.create_list(:slack_message, 5, user: user3, slack_channel: channel)
FactoryBot.create(:slack_reaction, user: user3, created_at: 3.years.ago)
channel2 = FactoryBot.create(:slack_channel)
FactoryBot.create(:slack_message, created_at: 3.years.ago, user: user3, slack_channel: channel2)


# user that's not active at all this week
user4 = FactoryBot.create(:user)
FactoryBot.create(:slack_message, created_at: 3.years.ago, user: user4, slack_channel: channel2)
