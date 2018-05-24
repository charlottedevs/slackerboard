RSpec.shared_examples 'ignored slack reaction' do
  it 'does NOT create a SlackReaction' do
    expect { make_request }.to_not change {
      SlackReaction.where(user_id: user.id).count
    }
  end
end
