require 'rails_helper'

RSpec.describe CalendarEventsController, type: :controller do
  let(:current_user) { create(:user) }
  let(:events) do
    [
      create(:calendar_event, user: current_user, summary: 'Event 1', start_time: Time.now, end_time: Time.now + 1.hour, description: 'Description 1', hangout_link: 'http://example.com/1'),
      create(:calendar_event, user: current_user, summary: 'Event 2', start_time: Time.now, end_time: Time.now + 2.hours, description: 'Description 2', hangout_link: 'http://example.com/2')
    ]
  end

  before do
    session[:user_id] = current_user.id

    google_calendar_service_double = instance_double(GoogleCalendarService)
    
    allow(GoogleCalendarService).to receive(:new).with(current_user).and_return(google_calendar_service_double)
    
    allow(google_calendar_service_double).to receive(:refresh_token)
    allow(google_calendar_service_double).to receive(:list_events).and_return(events)
  end

  describe 'GET #index' do

    context 'when the request format is HTML' do
      it 'assigns @events and renders the index template' do
        get :index, format: :html
        expect(assigns(:events)).to eq(events)
        expect(response).to render_template(:index)
      end
    end

    context 'when the request format is JSON' do
      it 'returns a JSON representation of events' do
        get :index, format: :json
        expected_response = events.map do |event|
          {
            title: event.summary,
            start: event.start_time.as_json,
            end: event.end_time.as_json,
            description: event.description,
            hangout_link: event.hangout_link
          }
        end
        expect(response.body).to eq(expected_response.to_json)
      end
    end
  end
end
