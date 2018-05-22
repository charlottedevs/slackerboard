RSpec.shared_examples 'creates a slack reaction' do
  it 'creates a SlackReaction' do
    expect { make_request }.to change {
      SlackReaction.where(user_id: user.id).count
    }
  end
end
