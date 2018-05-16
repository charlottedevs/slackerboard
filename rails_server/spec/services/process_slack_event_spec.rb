require 'rails_helper'

RSpec.describe ProcessSlackEvent do
  subject { described_class }
  let(:perform) { subject.call(payload) }
  let(:payload) { json_data(filename: event_fixture) }
  let(:event_fixture) { 'slack_message_created_event' }
  let(:slack_channel_id) { payload.dig('event', 'channel') }
  let(:user_slack_id) { payload.dig('event', 'user') }
  let(:channel) { double(:channel, id: 7) }
  let(:user) { double(:user, id: 7) }
  let(:stat) do
    create(:channel_stat, messages_given: 1, reactions_given: 1)
  end

  before do
    allow(SlackChannel).to receive(:find_or_create_by).and_return(channel)
    allow(User).to receive(:find_or_create_by).and_return(user)
    allow(ChannelStat).to receive(:find_or_create_by).and_return(stat)
  end

  describe 'find or creating' do
    it 'creates a slack channel if not existant' do
      expect(SlackChannel).to receive(:find_or_create_by).with(
        slack_identifier: slack_channel_id
      )
      perform
    end


    it 'creates a user if not existant' do
      expect(User).to receive(:find_or_create_by).with(
        slack_identifier: user_slack_id
      )
      perform
    end

    it 'creates a channel stat for that channel if not existant' do
      expect(ChannelStat).to receive(:find_or_create_by).with(
        slack_channel_id: channel.id,
        user_id: user.id,
      )
      perform
    end
  end

  describe 'changing stats' do
    context 'message created event' do
      let(:event_fixture) { 'slack_message_created_event' }

      it 'adds to stat#messages_given' do
        original = stat.messages_given
        perform
        expect(stat.messages_given).to eq(original + 1)
      end

      it 'does NOT change reactions_given' do
        expect(stat).to_not receive(:decrement!).with(:reactions_given)
        expect(stat).to_not receive(:increment!).with(:reactions_given)
        perform
      end
    end

    context 'message removed event' do
      let(:event_fixture) { 'slack_message_deleted_event' }

      it 'removes from stat#messages_given' do
        original = stat.messages_given
        perform
        expect(stat.messages_given).to eq(original - 1)
      end

      it 'does NOT change reactions_given' do
        original = stat.reactions_given
        perform
        expect(stat.reactions_given).to eq(original)
      end

      context 'when messages_given is nil or 0' do
        let(:stat) { double(:stat, messages_given: 0) }

        it 'does not decrement into negative numbers' do
          expect(stat).to_not receive(:decrement!).with(:messages_given)
          perform
        end
      end
    end

    context 'reaction given event' do
      let(:event_fixture) { 'slack_reaction_added_event' }

      it 'adds to stat#reactions_given' do
        original = stat.reactions_given
        perform
        expect(stat.reactions_given).to eq(original + 1)
      end

      it 'does MOT change messages given' do
        original = stat.messages_given
        perform
        expect(stat.messages_given).to eq(original)
      end
    end

    context 'reaction removed event' do
      let(:event_fixture) { 'slack_reaction_removed_event' }

      it 'removes from stat#messages_given' do
        original = stat.reactions_given
        perform
        expect(stat.reactions_given).to eq(original - 1)
      end

      it 'does NOT change messages_given' do
        original = stat.messages_given
        perform
        expect(stat.messages_given).to eq(original)
      end

      context 'when reactions_given is NOT positive' do
        let(:stat) { double(:stat, reactions_given: 0) }

        it 'does not decrement into negative numbers' do
          expect(stat).to_not receive(:decrement!).with(:reactions_given)
          perform
        end
      end
    end
  end
end
