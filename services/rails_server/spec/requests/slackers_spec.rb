require 'rails_helper'

RSpec.describe '/slackers' do
  before do
    allow(Slackerboard).to receive(:new)
  end

  it 'calls on Slackerboard' do
    expect(Slackerboard).to receive(:new).with(no_args)
    get '/slackers'
  end

  context 'when given `thisweek` param' do
    it 'injects monday into Slackerboard args' do
      expect(Slackerboard).to receive(:new).with(since: Time.zone.today.monday)
      get '/slackers?thisweek'
    end

    it 'works even if thisweek has a value in params' do
      expect(Slackerboard).to receive(:new).with(since: Time.zone.today.monday)
      get '/slackers?thisweek=true'
    end
  end
end
