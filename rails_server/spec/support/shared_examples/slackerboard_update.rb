RSpec.shared_examples 'slackerboard_update' do
  it 'makes a broadcast to slackerboard_update' do
    slackerboard = double(:slackerboard)
    allow(Slackerboard).to receive(:new).and_return slackerboard
    expect(ActionCable.server).to receive(:broadcast).with(
      'slackerboard_update', slackerboard: slackerboard
    )
    make_request
  end
end
