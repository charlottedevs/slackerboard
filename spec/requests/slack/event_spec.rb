require 'rails_helper'

RSpec.describe "Slack Events" do
  let(:payload) { json_data(filename: event_fixture) }
  let(:slack_channel_id) { payload.dig('event', 'channel') }
  let(:user_slack_id) { payload.dig('event', 'user') }
  let(:headers) do
    { "CONTENT_TYPE" => "application/json" }
  end

  let(:user) { create(:user, slack_identifier: user_slack_id) }
  let(:channel) { create(:slack_channel, slack_identifier: slack_channel_id) }
  let(:make_request) do
    post "/slack/events", params: payload.to_json, headers: headers
  end

  before do
    # setup
    user
    channel
  end

  describe 'message created event' do
    let(:event_fixture) { 'slack_message_created_event' }

    it 'creates a ChannelStat object' do
      expect {
        make_request
      }.to change {
        ChannelStat.where(user_id: user.id).count
      }.by(1)
    end

    it 'increments stat#messages_given by one' do
      metric = user.channel_stats.create!(slack_channel_id: channel.id, messages_given: 1)
      make_request
      metric.reload
      expect(metric.messages_given).to eq(2)
    end
  end

  describe 'message deleted event' do
    let(:event_fixture) { 'slack_message_deleted_event' }

    it 'decrements stat#messages_given by one' do
      metric = user.channel_stats.create!(slack_channel_id: channel.id, messages_given: 1)
      make_request
      metric.reload
      expect(metric.messages_given).to eq(0)
    end

    context 'when messages_given is 0' do
      it 'does NOT change stat#messages_given' do
        metric = user.channel_stats.create!(slack_channel_id: channel.id, messages_given: 0)
        make_request
        expect(metric.messages_given).to eq(0)
      end
    end
  end

  describe 'reaction added event' do
    let(:event_fixture) { 'slack_reaction_added_event' }

    it 'increments stat#reactions_given by one' do
      metric = user.channel_stats.create!(slack_channel_id: channel.id, reactions_given: 1)
      make_request
      metric.reload
      expect(metric.reactions_given).to eq(2)
    end
  end


  describe 'reaction removed event' do
    let(:event_fixture) { 'slack_reaction_removed_event' }

    it 'decrements stat#messages_given by one' do
      metric = user.channel_stats.create!(slack_channel_id: channel.id, reactions_given: 1)
      make_request
      metric.reload
      expect(metric.reactions_given).to eq(0)
    end

    context 'when messages_given is 0' do
      it 'does NOT change stat#messages_given' do
        metric = user.channel_stats.create!(slack_channel_id: channel.id, reactions_given: 0)
        make_request
        expect(metric.reactions_given).to eq(0)
      end
    end
  end
end
