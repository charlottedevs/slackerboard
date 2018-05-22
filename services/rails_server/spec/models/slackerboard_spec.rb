require 'rails_helper'

RSpec.describe Slackerboard do
  let(:user) { create(:user) }
  let(:slack_message) { create(:slack_message, user: user) }
  let(:slack_reaction) { create(:slack_reaction, user: user) }
  let(:obj) { subject.sample }

  before do
    slack_message
    slack_reaction
  end

  describe 'users with stats that have a count of 0' do
    let(:lurker) { create(:user) }

    it 'does NOT include user in result' do
      expect(lurker.slack_reactions).to be_empty
      expect(lurker.slack_messages).to be_empty
      ids = subject.map { |hsh| hsh['id'] }
      expect(ids).to_not include(lurker.id)
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
    end

    describe 'reactions' do
      %w(emoji reactions_given).each do |k|
        it "has #{k}" do
          reaction = obj.fetch('reactions').sample
          expect(reaction).to have_key k
        end
      end
    end
  end
end
