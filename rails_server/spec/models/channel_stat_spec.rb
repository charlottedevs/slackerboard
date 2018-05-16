require 'rails_helper'

RSpec.describe ChannelStat, type: :model do
  %i(slack_channel user messages_given reactions_given).each do |attr|
    it "responds_to #{attr}" do
      expect(subject).to respond_to(attr)
    end
  end
end
