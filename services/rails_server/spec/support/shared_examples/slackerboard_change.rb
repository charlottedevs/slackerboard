RSpec.shared_examples 'slackerboard_change' do
  it 'makes a broadcast to slackerboard_change' do
    slackerboard = double(:slackerboard)
    allow(Slackerboard).to receive(:new).and_return slackerboard
    expect(ActionCable.server).to receive(:broadcast).with(
      'slackerboard_change', slackerboard: slackerboard
    )
    make_request
  end
end
