require 'rails_helper'

RSpec.describe "slack message deleted" do
  let(:payload) { json_data(filename: event_fixture) }
  let(:slack_channel_id) { payload.dig('event', 'channel') }
  let(:user_slack_id) { payload.dig('event', 'user') }
  let(:reaction_emoji) { payload.dig('event', 'reaction') }
  let(:headers) do
    { "CONTENT_TYPE" => "application/json" }
  end

  let(:user) { create(:user, slack_identifier: user_slack_id) }
  let(:channel) { create(:slack_channel, slack_identifier: slack_channel_id) }
  let(:message) do
    create(:slack_message, user: user, slack_channel: channel, ts: payload.dig('event', 'ts'))
  end
  let(:make_request) do
    post "/slack/events", params: payload.to_json, headers: headers
  end

  before do
    # setup
    message
    allow_any_instance_of(Slack::EventsController).to receive(:verify!).and_return(true)
  end

  let(:event_fixture) { 'slack_message_deleted_event' }

  it 'removes the SlackMessage' do
    expect { make_request }.to change {
      SlackMessage.where(user_id: user.id).count
    }.from(1).to(0)
  end

  it_behaves_like 'slackerboard_change'

  context 'slack message does NOT exist in db' do
    it 'does NOT blow up' do
      expect { make_request }.to_not raise_error
    end
  end
end
