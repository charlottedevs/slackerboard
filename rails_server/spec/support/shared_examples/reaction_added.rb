RSpec.shared_examples 'reaction added' do
  it 'creates a SlackReaction' do
    expect(SlackReaction).to receive(:create).with(
      user_id: user.id,
      emoji: emoji,
      target: type,
      slack_identifier: slack_identifier,
      slack_channel_id: slack_channel_id
    )

    perform
  end
end
