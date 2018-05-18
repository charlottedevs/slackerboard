require 'rails_helper'

RSpec.describe FetchUser do
  subject { described_class }

  let(:perform) { subject.call(slack_identifier: slack_identifier) }
  let(:user) { build(:user) }
  let(:slack_identifier) { user.slack_identifier }
  let(:payload) { json_data(filename: 'slack_user') }
  let(:res) { double(:res, body: payload.to_json) }
  let(:token) { 'supersecret' }
  let(:url) do
    "https://slack.com/api/users.info?token=#{token}&user=#{user.slack_identifier}"
  end

  before do
    allow(User).to receive(:find_or_create_by).and_yield(user).and_return(user)
    allow(Faraday).to receive(:get).and_return res

    allow_any_instance_of(subject).to receive(:token).and_return token
  end

  it 'receives a slack_identifier keyword arg' do
    expect { perform }.to_not raise_error
  end

  context 'when user exists in the db' do
    it 'loads that user' do
      expect(User).to receive(:find_or_create_by)
        .with(slack_identifier: slack_identifier)
        .and_return user

      expect(perform.user).to eq user
    end

    it 'does NOT fetch Slack data' do
      expect(Faraday).to_not receive(:get)
    end
  end

  context 'when user does NOT exist in the db' do
    it 'fetches that user on Slack API' do
      expect(Faraday).to receive(:get).with(url)
      perform
    end

    it 'still does a find or create' do
      expect(User).to receive(:find_or_create_by)
      perform
    end

    it 'adds data from Slack API' do
      user = perform.user
      expect(user.real_name).to eq(payload.dig('user', 'real_name'))
      expect(user.slack_handle).to eq(payload.dig('user', 'profile', 'display_name'))
      expect(user.profile_image).to eq(payload.dig('user', 'profile', 'image_32'))
    end
  end
end
