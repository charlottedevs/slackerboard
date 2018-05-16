require 'rails_helper'

RSpec.describe User, type: :model do
  %i(
  slack_identifier
  slack_handle
  real_name
  profile_image
  channel_stats
  slack_channels
  ).each do |attr|
    it "responds_to #{attr}" do
      expect(subject).to respond_to(attr)
    end
  end
end
