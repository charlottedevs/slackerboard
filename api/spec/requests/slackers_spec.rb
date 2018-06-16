require 'rails_helper'

RSpec.describe '/slackers' do
  before do
    allow(SlackerRanking).to receive(:new)
  end

  it 'calls on SlackerRanking' do
    expect(SlackerRanking).to receive(:new).with(no_args)
    get '/slackers'
  end

  context 'when given `thisweek` param' do
    it 'injects monday into SlackerRanking args' do
      expect(SlackerRanking).to receive(:new).with(since: Time.zone.today.monday)
      get '/slackers?thisweek'
    end

    it 'works even if thisweek has a value in params' do
      expect(SlackerRanking).to receive(:new).with(since: Time.zone.today.monday)
      get '/slackers?thisweek=true'
    end
  end
end
