require 'rails_helper'

RSpec.describe "Slack Events" do
  let(:payload) { json_data(filename: event_fixture) }
  let(:event_fixture) { 'challenge_event' }
  let(:verification_token) { 'supersecret' }
  let(:auth_payload) do
    payload.tap { |p| p['token'] = verification_token }
  end

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

  it 'response with http status ok' do
    make_request
    expect(response.status).to eq(200)
  end

  it 'responds with challenge from payload' do
    make_request
    parsed_response = JSON.parse response.body
    expect(parsed_response.keys).to include 'challenge'
    expect(parsed_response['challenge']).to eq(payload['challenge'])
  end
end
