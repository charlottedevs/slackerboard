require 'rails_helper'

RSpec.describe Slackerboard do
  subject { described_class.new.to_json }
  let(:user) { create(:user) }
  let(:slack_channel) { create(:slack_channel) }
  let(:slack_reaction) { create(:slack_reaction, user: user) }
  let(:obj) { subject.sample }
  let(:slack_message) do
    create(:slack_message, user: user, slack_channel: slack_channel)
  end

  before do
    slack_message
    slack_reaction
  end

  describe 'initialization' do
    subject { described_class }
    it 'receives options' do
      expect { subject.new(since: 5.days.ago) }.to_not raise_error
      expect { subject.new }.to_not raise_error
    end

    it 'returns an array' do
      expect(subject.new.to_json).to be_a Array
    end
  end

  describe 'this_week' do
    subject { described_class.new(since: Date.today.monday).to_json }

    let(:old_message) do
      create(:slack_message,
             user: user,
             slack_channel: slack_channel,
             created_at: 3.years.ago
            )
    end

    it 'only returns message from this week' do
      old_message # setup
      expect(user.slack_messages_count).to eq(2) # old + new
      user_stats = subject.find { |hsh| hsh['id'] == user.id }

      message_stats = user_stats['messages'].find do |hsh|
        hsh['slack_identifier'] == slack_channel.slack_identifier
      end

      expect(message_stats['messages_sent']).to eq(1) # only new
    end

    context 'all time' do
      subject { described_class.new.to_json }

      it 'only returns message from this week' do
        old_message # setup
        expect(user.slack_messages_count).to eq(2) # old + new
        user_stats = subject.find { |hsh| hsh['id'] == user.id }

        message_stats = user_stats['messages'].find do |hsh|
          hsh['slack_identifier'] == slack_channel.slack_identifier
        end

        expect(message_stats['messages_sent']).to eq(2) # both
      end
    end
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
