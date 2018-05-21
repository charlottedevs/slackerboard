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
    allow_any_instance_of(Slack::EventsController).to receive(:verify!).and_return(true)
  end

  let(:event_fixture) { 'slack_message_created_event' }

  it 'creates a SlackMessage' do
    expect {
      make_request
    }.to change {
      SlackMessage.where(user_id: user.id).count
    }.from(0).to(1)
  end

  it_behaves_like 'slackerboard_change'
end
