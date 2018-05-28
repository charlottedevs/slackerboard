require 'rails_helper'

RSpec.describe '/slackers' do
  before do
    allow(Slackerboard).to receive(:new)
  end

  it 'calls on Slackerboard' do
    expect(Slackerboard).to receive(:new)
    get '/slackers'
  end

  context 'when given `thisweek` param' do
    it 'does NOT call on Slackerboard.alltime' do
      expect(Slackerboard).to receive(:new).with(this_week: true)
      get '/slackers?thisweek'
    end

    it 'works even if thisweek has a value in params' do
      expect(Slackerboard).to receive(:new).with(this_week: true)
      get '/slackers?thisweek=true'
    end
  end
end
