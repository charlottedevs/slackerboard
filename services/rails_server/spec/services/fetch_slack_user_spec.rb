require 'rails_helper'

RSpec.describe FetchSlackUser do
  subject { described_class }

  let(:perform) { subject.call(slack_identifier: slack_identifier) }
  let(:user) { build(:user) }
  let(:slack_identifier) { user.slack_identifier }

  before do
    allow(User).to receive(:find_or_initialize_by).and_return(user)
    allow(UpdateSlackUser).to receive(:call)
    allow(user).to receive(:persisted?).and_return true
  end

  context 'when user exists in the db' do
    it 'loads that user' do
      expect(User).to receive(:find_or_initialize_by)
        .with(slack_identifier: slack_identifier)
        .and_return user

      expect(perform.user).to eq user
    end

    it 'does NOT update that users slack info' do
      expect(UpdateSlackUser).to_not receive(:call)
      perform
    end
  end

  context 'when user does NOT exist in the db' do
    before do
      allow(user).to receive(:persisted?).and_return false
    end

    it 'still does a find or create' do
      expect(User).to receive(:find_or_initialize_by)
      perform
    end

    it 'updates that users slack info' do
      expect(UpdateSlackUser).to receive(:call).with(user: user, save: true)
      perform
    end
  end
end
