require 'rails_helper'
require 'webmock/rspec'
require 'oauth2'

RSpec.describe GoogleCalendarService, type: :service do
  let(:user) { create(:user) }
  let(:service) { described_class.new(user) }
  
  let(:new_access_token) { double('OAuth2::AccessToken', token: 'new_access_token', expires_at: (Time.now + 3600).to_i) }
  let(:token) { double('OAuth2::AccessToken', refresh!: new_access_token) }

  before do
    allow(OAuth2::AccessToken).to receive(:new).and_return(token)
  end

  describe '#list_events' do
    let(:events_response) do
      {
        'items' => [
          {
            'id' => 'event_id_1',
            'organizer' => { 'email' => 'organizer@example.com' },
            'summary' => 'Event 1',
            'description' => 'Description 1',
            'start' => { 'dateTime' => '2024-09-19T09:00:00Z' },
            'end' => { 'dateTime' => '2024-09-19T10:00:00Z' },
            'hangoutLink' => 'https://example.com/hangout1'
          }
        ]
      }.to_json
    end

    before do
      stub_request(:get, "https://www.googleapis.com/calendar/v3/calendars/primary/events")
        .to_return(status: 200, body: events_response)
    end

    it 'fetches and creates or updates calendar events' do
      expect {
        service.list_events
      }.to change { CalendarEvent.count }.by(1)
      
      calendar_event = CalendarEvent.last
      expect(calendar_event.event_id).to eq('event_id_1')
      expect(calendar_event.calendar_id).to eq('organizer@example.com')
      expect(calendar_event.summary).to eq('Event 1')
      expect(calendar_event.description).to eq('Description 1')
      expect(calendar_event.start_time).to eq('2024-09-19T09:00:00Z')
      expect(calendar_event.end_time).to eq('2024-09-19T10:00:00Z')
      expect(calendar_event.hangout_link).to eq('https://example.com/hangout1')
    end
  end
end
