require 'rails_helper'

RSpec.describe SlackReaction, type: :model do
  it 'belongs to a slack channel' do
    expect(subject).to respond_to :slack_channel
  end
end
