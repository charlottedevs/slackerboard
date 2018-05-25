class FetchSlackUser
  include Interactor
  SLACK_API = "https://slack.com/api/users.info"

  def call
    context.user = User.find_or_create_by(slack_identifier: slack_identifier) do |user|
      user_data = JSON.parse(res.body).fetch('user')
      profile_data = user_data.fetch('profile')

      user.real_name = user_data['real_name']
      user.profile_image = profile_data['image_512']

      # prefer display_name over 'name'
      # BUT fallback if it does not exist.
      # https://api.slack.com/changelog/2017-09-the-one-about-usernames
      display_name = profile_data['display_name']
      user.slack_handle = display_name.present? ? display_name : user_data['name']
    end
  end

  private

  def res
    context.res ||= Faraday.get(slack_url)
  end

  def slack_url
    "#{SLACK_API}?token=#{token}&user=#{slack_identifier}"
  end

  def slack_identifier
    context.slack_identifier
  end

  def token
    ENV.fetch('SLACK_API_TOKEN')
  end
end
