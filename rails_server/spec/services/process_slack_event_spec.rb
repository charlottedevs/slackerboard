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
  let(:cache) { double(:cache) }
  let(:stat) do
    create(:channel_stat, messages_given: 1)
  end

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
    allow(ChannelStat).to receive(:find_or_create_by).and_return(stat)
    allow(ReactionStat).to receive(:find_or_create_by).and_return(reaction_stat)
    allow(Rails).to receive(:cache).and_return cache
    allow(cache).to receive(:delete)
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

    xcontext 'message removed event' do
      let(:event_fixture) { 'slack_message_deleted_event' }

      it 'removes from stat#messages_given' do
        original = stat.messages_given
        perform
        expect(stat.messages_given).to eq(original - 1)
      end

      it 'does NOT change reactions_given' do
        original = reaction_stat.reactions_given
        perform
        expect(reaction_stat.reactions_given).to eq(original)
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
        original = reaction_stat.reactions_given
        perform
        expect(reaction_stat.reactions_given).to eq(original + 1)
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
        original = reaction_stat.reactions_given
        perform
        expect(reaction_stat.reactions_given).to eq(original - 1)
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
