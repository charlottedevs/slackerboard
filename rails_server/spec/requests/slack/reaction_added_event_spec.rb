require 'rails_helper'

RSpec.describe "reaction added" do
  let(:payload) { json_data(filename: event_fixture) }
  let(:event_fixture) { 'slack_message_reaction_added_event' }
  let(:user_slack_id) { payload.dig('event', 'user') }
  let(:reaction_emoji) { payload.dig('event', 'reaction') }
  let(:headers) do
    { "CONTENT_TYPE" => "application/json" }
  end

  let(:user) { create(:user, slack_identifier: user_slack_id) }
  let(:make_request) do
    post "/slack/events", params: payload.to_json, headers: headers
  end

  before do
    # setup
    user
    allow_any_instance_of(Slack::EventsController).to receive(:verify!).and_return(true)
  end


  it_behaves_like 'slackerboard_change'

  context 'reaction towards a message' do
    let(:event_fixture) { 'slack_message_reaction_added_event' }

    it_behaves_like 'creates a slack reaction'
  end


  context 'reaction towards a incoming webhook message' do
    let(:event_fixture) { 'slack_webhook_reaction_added' }
    let(:slack_channel_id) { payload.dig('event', 'item', 'channel') }

    it_behaves_like 'creates a slack reaction'
  end

  context 'reaction towards a file' do
    let(:event_fixture) { 'slack_file_reaction_added_event' }

    it_behaves_like 'creates a slack reaction'
  end


  context 'reaction towards a file comment' do
    let(:event_fixture) { 'slack_file_comment_reaction_added_event' }

    it_behaves_like 'creates a slack reaction'
  end
end
