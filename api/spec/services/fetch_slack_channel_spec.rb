require 'rails_helper'

RSpec.describe FetchSlackChannel do
  subject { described_class }

  let(:perform) { subject.call(slack_identifier: slack_identifier) }
  let(:channel) { SlackChannel.new(slack_identifier: slack_identifier) }
  let(:slack_identifier) { payload.dig('channel', 'id') }
  let(:payload) { json_data(filename: 'fetch_slack_channel') }
  let(:res) { double(:res, body: payload.to_json) }
  let(:token) { 'supersecret' }
  let(:url) do
    "https://slack.com/api/channels.info?token=#{token}&channel=#{channel.slack_identifier}"
  end

  before do
    allow(SlackChannel).to receive(:find_or_create_by).and_yield(channel).and_return(channel)
    allow(Faraday).to receive(:get).and_return res

    allow_any_instance_of(subject).to receive(:token).and_return token
  end

  it 'receives a slack_identifier keyword arg' do
    expect { perform }.to_not raise_error
  end

  context 'when channel exists in the db' do
    it 'loads that user' do
      expect(SlackChannel).to receive(:find_or_create_by)
        .with(slack_identifier: slack_identifier)
        .and_return channel

      expect(perform.channel).to eq channel
    end

    it 'does NOT fetch Slack data' do
      expect(Faraday).to_not receive(:get)
    end
  end

  context 'when user does NOT exist in the db' do
    it 'fetches that user on Slack API' do
      expect(Faraday).to receive(:get).with(url)
      perform
    end

    it 'still does a find or create' do
      expect(SlackChannel).to receive(:find_or_create_by)
      perform
    end

    it 'adds data from Slack API' do
      channel = perform.channel
      expect(channel.name).to eq(payload.dig('channel', 'name'))
      expect(channel.slack_identifier).to eq(payload.dig('channel', 'id'))
    end
  end
end
