class CalendarEventsController < ApplicationController
  def index
    google_calendar_service = GoogleCalendarService.new(@current_user)
    google_calendar_service.refresh_token
    google_calendar_service.list_events

    @events = CalendarEvent.where(user: @current_user)
    respond_to do |format|
      format.html
      format.json { render json: @events.map { |event| format_event(event) } }
    end
  end

  private

  def format_event(event)
    {
      title: event.summary,
      start: event.start,
      end: event.end,
      description: event.description,
      hangout_link: event.hangout_link
    }
  end
end
