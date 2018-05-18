class FetchUser
  include Interactor
  SLACK_API = "https://slack.com/api/users.info"

  def call
    context.user = User.find_or_create_by(slack_identifier: context.slack_identifier) do |user|
      user_data = JSON.parse(res.body).fetch('user') { Hash.new }
      user.real_name = user_data.dig('real_name')
      user.slack_handle = user_data.dig('profile', 'display_name')
      user.profile_image = user_data.dig('profile', 'image_32')
    end
  end


  private

  def res
    context.res ||= Faraday.get(slack_url)
  end

  def slack_url
    "#{SLACK_API}?token=#{token}&user=#{context.slack_identifier}"
  end

  def token
    ENV.fetch('SLACK_API_TOKEN')
  end
end
