class FetchSlackUser
  include Interactor

  def call
    UpdateSlackUser.call(user: user, save: true) unless user.persisted?
  end

  private

  def user
    context.user ||= User.find_or_initialize_by(
      slack_identifier: slack_identifier
    )
  end

  def slack_identifier
    context.slack_identifier
  end
end
