require 'rails_helper'

RSpec.describe "reaction removed" do
  let(:payload) { json_data(filename: event_fixture) }
  let(:user_slack_id) { payload.dig('event', 'user') }
  let(:emoji) { payload.dig('event', 'reaction') }
  let(:headers) do
    { "CONTENT_TYPE" => "application/json" }
  end

  let(:reaction) do
    create(:slack_reaction, emoji: emoji, user: user, slack_identifier: slack_identifier)
  end

  let(:user) { create(:user, slack_identifier: user_slack_id) }
  let(:make_request) do
    post "/slack/events", params: payload.to_json, headers: headers
  end

  before do
    # setup
    reaction
    allow_any_instance_of(Slack::EventsController).to receive(:verify!).and_return(true)
  end

  let(:slack_identifier) { payload.dig('event', 'item', 'ts') }
  let(:event_fixture) { 'slack_message_reaction_removed_event' }
  let(:slack_channel_id) { payload.dig('event', 'item', 'channel') }

  it 'removes the SlackReaction' do
    expect { make_request }.to change {
      SlackReaction.where(user_id: user.id).count
    }.from(1).to(0)
  end

  context 'when there are multiple reactions in same minute' do
    let(:another_reaction) do
      create(:slack_reaction, emoji: 'smile', user: user, slack_identifier: slack_identifier)
    end
    before do
      reaction
      another_reaction
    end

    it 'only deletes the correct one' do
      expect(user.slack_reactions.size).to eq(2)
      expect { make_request }.to change {
        SlackReaction.where(user_id: user.id).count
      }.from(2).to(1)
    end
  end

  context 'reaction does NOT exist in db' do
    it 'does NOT blow up' do
      expect { make_request }.to_not raise_error
    end
  end
end
