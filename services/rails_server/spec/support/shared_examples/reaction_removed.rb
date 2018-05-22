RSpec.shared_examples 'reaction removed' do
  it 'destroys SlackReaction' do
    expect(SlackReaction).to receive(:where)
      .with(slack_identifier: slack_identifier)
      .and_return reaction

    expect(reaction).to receive(:destroy_all)
    perform
  end
end
