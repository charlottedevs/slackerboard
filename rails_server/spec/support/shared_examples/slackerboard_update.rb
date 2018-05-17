RSpec.shared_examples 'slackerboard_update' do
  it 'makes a broadcast to slackerboard_update' do
    expect(ActionCable.server).to receive(:broadcast).with(
      'slackerboard_update', slackerboard: Slackerboard.new
    )
    make_request
  end
end
