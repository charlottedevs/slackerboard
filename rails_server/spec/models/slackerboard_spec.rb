require 'rails_helper'

RSpec.describe Slackerboard do
  let(:user) { create(:user) }
  let(:channel_stat) { create(:channel_stat, user: user) }
  let(:reaction_stat) { create(:reaction_stat, user: user) }
  let(:obj) { subject.sample }

  before do
    channel_stat
    reaction_stat
  end

  describe 'users with stats that have a count of 0' do
    let(:channel_stat) { create(:channel_stat, user: user, messages_given: 0) }
    let(:reaction_stat) { create(:reaction_stat, user: user, reactions_given: 0) }

    it 'does NOT include user in result' do
      expect(subject).to be_empty
    end
  end

  describe 'keys' do
    %w(id slack_identifier real_name slack_handle profile_image messages reactions).each do |k|
      it "has #{k}" do
        expect(obj).to have_key k
      end
    end

    describe 'messages' do
      %w(channel slack_identifier messages_sent).each do |k|
        it "has #{k}" do
          message = obj.fetch('messages').sample
          expect(message).to have_key k
        end
      end

      context 'when a stat happens to be 0' do
        let(:channel_stat) { create(:channel_stat, user: user, messages_given: 0) }

        it 'does NOT include in slackerboard' do
          expect(obj['messages']).to be_empty
        end
      end
    end

    describe 'reactions' do
      %w(emoji reactions_given).each do |k|
        it "has #{k}" do
          reaction = obj.fetch('reactions').sample
          expect(reaction).to have_key k
        end
      end

      context 'when a stat happens to be 0' do
        let(:reaction_stat) { create(:reaction_stat, user: user, reactions_given: 0) }

        it 'does NOT include in slackerboard' do
          expect(obj['reactions']).to be_empty
        end
      end
    end
  end
end
