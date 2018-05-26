class UpdateSlackUser
  include Interactor
  SLACK_API = "https://slack.com/api/users.info"

  def call
    unless context.user
      raise ArgumentError, 'missing user keyword argument'
    end

    context.fail!(error: res['error']) unless res['ok']

    user_data = res.fetch('user')

    context.user.tap do |user|
      profile_data = user_data.fetch('profile')

      user.real_name = user_data['real_name']
      user.profile_image = profile_data['image_512']

      # prefer display_name over 'name'
      # BUT fallback if it does not exist.
      # https://api.slack.com/changelog/2017-09-the-one-about-usernames
      display_name = profile_data['display_name']
      user.slack_handle = display_name.present? ? display_name : user_data['name']
    end

    context.user.save! if context.save
  end

  private

  def res
    context.res ||= JSON.parse(Faraday.get(slack_url).body)
  end

  def slack_url
    "#{SLACK_API}?token=#{token}&user=#{slack_identifier}"
  end

  def slack_identifier
    context.user.slack_identifier
  end

  def token
    ENV.fetch('SLACK_API_TOKEN')
  end
end
