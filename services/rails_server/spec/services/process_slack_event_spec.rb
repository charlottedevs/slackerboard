require 'rails_helper'

RSpec.describe ProcessSlackEvent do
  subject { described_class }
  let(:perform) { subject.call(payload) }
  let(:payload) { json_data(filename: event_fixture) }
  let(:event_fixture) { 'slack_message_created_event' }
  let(:slack_channel_id) { payload.dig('event', 'channel') }
  let(:user_slack_id) { payload.dig('event', 'user') }
  let(:channel) { double(:channel, id: slack_channel_id) }
  let(:reaction) { double(:reaction) }
  let(:user) { double(:user, id: 7) }
  let(:cache) { double(:cache) }
  let(:event) { payload['event'] }

  let(:user_fetch_result) do
    double(:user_fetch_result, user: user)
  end


  let(:channel_fetch_result) do
    double(:channel_fetch_result, channel: channel)
  end

  let(:reaction_stat) do
    create(:reaction_stat, reactions_given: 1)
  end

  before do
    allow(FetchSlackUser).to receive(:call).and_return(user_fetch_result)
    allow(FetchSlackChannel).to receive(:call).and_return(channel_fetch_result)
    allow(SlackReaction).to receive(:create)
    allow(Rails).to receive(:cache).and_return cache
    allow(cache).to receive(:delete)
  end

  describe 'error handling' do
    it 'returns error in result' do
      allow(Rails).to receive(:cache).and_raise 'BOOM'
      result = perform
      expect(result.error).to eq('BOOM')
      expect(result).to be_a_failure
    end
  end

  describe 'rails cache' do
    it 'busts the cache "slackerboard"' do
      expect(cache).to receive(:delete).with('slackerboard')
      perform
    end
  end

  describe 'find or creating' do
    it 'calls on FetchSlackChannel' do
      expect(FetchSlackChannel).to receive(:call).with(
        slack_identifier: slack_channel_id
      )
      perform
    end

    it 'calls on FetchSlackUser' do
      expect(FetchSlackUser).to receive(:call).with(slack_identifier: user_slack_id)
      perform
    end
  end

  describe 'message created event' do
    let(:event_fixture) { 'slack_message_created_event' }
    let(:ts) { event['ts'] }

    it 'creates a SlackMessage' do
      expect(SlackMessage).to receive(:create).with(
        user_id: user.id,
        slack_channel_id: slack_channel_id,
        ts: ts
      )

      perform
    end

  end

  context 'message removed event' do
    let(:event_fixture) { 'slack_message_deleted_event' }
    let(:ts) { event.fetch('deleted_ts') }
    let(:messages) { double(:messages) }

    it 'destroys the SlackMessage' do
      expect(SlackMessage).to receive(:where)
        .with(
          slack_channel_id: channel.id,
          ts: ts
        ).and_return messages

      expect(messages).to receive(:destroy_all)
      perform
    end
  end

  describe 'reaction given event' do
    let(:emoji) { event['reaction'] }
    let(:type) { event.dig('item', 'type') }

    context 'reaction to something in a private channel' do
      let(:event_fixture) { 'slack_message_reaction_added_event' }
      let(:slack_identifier) { event.dig('item', 'ts') }
      let(:empty_result) { double(:empty_result, channel: nil) }

      it 'does not create a new Slack Reaction' do
        allow(FetchSlackChannel).to receive(:call).and_return empty_result
        expect_any_instance_of(subject).to_not receive(:create_reaction)

        perform
      end
    end

    context 'message reaction' do
      let(:event_fixture) { 'slack_message_reaction_added_event' }
      let(:slack_identifier) { event.dig('item', 'ts') }

      it_behaves_like 'reaction added'
    end

    context 'file reaction' do
      let(:event_fixture) { 'slack_file_reaction_added_event' }
      let(:slack_identifier) { event.dig('item', 'file') }

      it_behaves_like 'reaction added'
    end

    context 'file comment reaction' do
      let(:event_fixture) { 'slack_file_comment_reaction_added_event' }
      let(:slack_identifier) { event.dig('item', 'file_comment') }

      it_behaves_like 'reaction added'
    end
  end

  describe 'reaction removed event' do
    context 'message reaction removed' do
      let(:event_fixture) { 'slack_message_reaction_removed_event' }
      let(:slack_identifier) { event.dig('item', 'ts') }

      it_behaves_like 'reaction removed'
    end

    context 'file reaction removed' do
      let(:event_fixture) { 'slack_file_reaction_removed_event' }
      let(:slack_identifier) { event.dig('item', 'file') }

      it_behaves_like 'reaction removed'
    end

    context 'file comment reaction removed' do
      let(:event_fixture) { 'slack_file_comment_reaction_removed_event' }
      let(:slack_identifier) { event.dig('item', 'file_comment') }

      it_behaves_like 'reaction removed'
    end
  end
end
