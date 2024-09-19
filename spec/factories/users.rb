FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    access_token { 'some-access-token' }
    refresh_token { 'some-refresh-token' }
    token_expires_at { 1.hour.from_now }
  end
end
  