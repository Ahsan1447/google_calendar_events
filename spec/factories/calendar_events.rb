FactoryBot.define do
  factory :calendar_event do
    user
    summary { "Meeting with Team" }
    start_time { DateTime.now }
    end_time { DateTime.now + 1.hour }
    description { "Discussing project updates" }
    hangout_link { "https://meet.google.com/xyz-meeting-link" }
  end
end
