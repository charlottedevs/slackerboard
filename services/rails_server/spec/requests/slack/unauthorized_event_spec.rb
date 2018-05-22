require 'rails_helper'

RSpec.describe "Slack Events" do
  let(:payload) { json_data(filename: event_fixture) }
  let(:event_fixture) { 'slack_message_created_event' }
  let(:verification_token) { 'supersecret' }
  let(:headers) do
    { "CONTENT_TYPE" => "application/json" }
  end

  let(:make_request) do
    post "/slack/events", params: auth_payload.to_json, headers: headers
  end

  before do
    allow_any_instance_of(Slack::EventsController).to receive(:verification_token)
      .and_return verification_token
  end

  context 'when no token is preset' do
    let(:auth_payload) { payload.except('token') }

    it 'returns 401 unauthorized' do
      make_request
      expect(response.status).to eq(401)
    end
  end


  context 'when bad token is preset' do
    let(:auth_payload) do
      payload.tap { |p| p['token'] = 'poop' }
    end

    it 'returns 401 unauthorized' do
      make_request
      expect(response.status).to eq(401)
    end
  end

  context 'when given a valid token' do
    let(:auth_payload) do
      payload.tap { |p| p['token'] = verification_token }
    end

    it 'returns 201 created' do
      make_request
      expect(response.status).to eq(201)
    end
  end
end
