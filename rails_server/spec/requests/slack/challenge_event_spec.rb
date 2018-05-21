require 'rails_helper'

RSpec.describe "Slack Events" do
  let(:payload) { json_data(filename: event_fixture) }
  let(:event_fixture) { 'challenge_event' }

  let(:headers) do
    { "CONTENT_TYPE" => "application/json" }
  end

  let(:make_request) do
    post "/slack/events", params: payload.to_json, headers: headers
  end

  it 'responds with challenge from payload' do
    make_request
    parsed_response = JSON.parse response.body
    expect(parsed_response.keys).to include 'challenge'
    expect(parsed_response['challenge']).to eq(payload['challenge'])
  end
end
