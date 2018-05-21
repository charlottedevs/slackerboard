require 'rails_helper'

RSpec.describe "reaction removed" do
  let(:payload) { json_data(filename: event_fixture) }
  let(:user_slack_id) { payload.dig('event', 'user') }
  let(:reaction_emoji) { payload.dig('event', 'reaction') }
  let(:headers) do
    { "CONTENT_TYPE" => "application/json" }
  end

  let(:reaction) do
    create(:slack_reaction, user: user, slack_identifier: slack_identifier)
  end

  let(:user) { create(:user, slack_identifier: user_slack_id) }
  let(:make_request) do
    post "/slack/events", params: payload.to_json, headers: headers
  end

  before do
    # setup
    reaction
  end

  let(:slack_identifier) { payload.dig('event', 'item', 'ts') }
  let(:event_fixture) { 'slack_message_reaction_removed_event' }
  let(:slack_channel_id) { payload.dig('event', 'item', 'channel') }

  it 'removes the SlackReaction' do
    expect { make_request }.to change {
      SlackReaction.where(user_id: user.id).count
    }.from(1).to(0)
  end

  it_behaves_like 'slackerboard_change'

  context 'reaction does NOT exist in db' do
    it 'does NOT blow up' do
      expect { make_request }.to_not raise_error
    end
  end
end
