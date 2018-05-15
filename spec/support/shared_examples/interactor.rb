RSpec.shared_examples 'interactor' do
  it 'responds_to :call' do
    expect(subject).to respond_to :call
  end
end
