require 'rails_helper'

RSpec.describe SlackChannel, type: :model do
  %i(slack_identifier name).each do |attr|
    it "responds_to #{attr}" do
      expect(subject).to respond_to(attr)
    end
  end
end
