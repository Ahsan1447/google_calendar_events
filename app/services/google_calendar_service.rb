class GoogleCalendarService
  include HTTParty
  base_uri 'https://www.googleapis.com/calendar/v3'

  def initialize(user)
    @user = user
    @headers = {
      'Authorization' => "Bearer #{@user.access_token}",
      'Content-Type' => 'application/json'
    }
  end

  def list_events
    response = self.class.get('/calendars/primary/events', headers: @headers)
    events = JSON.parse(response.body)['items']

    events.each do |event|
      CalendarEvent.find_or_create_by(event_id: event['id'], user: @user) do |calendar_event|
        calendar_event.update(
          calendar_id: event['organizer']['email'],
          summary: event['summary'],
          description: event['description'],
          start: event['start']['dateTime'],
          end: event['end']['dateTime'],
          hangout_link: event['hangoutLink']
        )
      end
    end
  end

  def refresh_token
    if @user.token_expires_at < Time.now
      new_token = OAUTH2_CLIENT.refresh_token(@user.refresh_token).get_token
      @user.update(
        access_token: new_token.token,
        token_expires_at: Time.at(new_token.expires_at)
      )
    end
  end
end
