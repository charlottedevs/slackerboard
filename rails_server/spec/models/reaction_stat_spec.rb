require 'rails_helper'

RSpec.describe ReactionStat, type: :model do
  %i(user emoji reactions_given).each do |attr|
    it "responds to #{attr}" do
      expect(subject).to respond_to(attr)
    end
  end
end
