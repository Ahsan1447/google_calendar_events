GOOGLE_CLIENT_ID = ENV['GOOGLE_CLIENT_ID'].freeze
GOOGLE_CLIENT_SECRET = ENV['GOOGLE_CLIENT_SECRET'].freeze
REDIRECT_URI = ENV['GOOGLE_REDIRECT_URI'].freeze
USER_INFO_URL = 'https://www.googleapis.com/oauth2/v3/userinfo'.freeze

OAUTH2_CLIENT = OAuth2::Client.new(
  GOOGLE_CLIENT_ID, GOOGLE_CLIENT_SECRET,
  site: 'https://accounts.google.com',
  authorize_url: '/o/oauth2/auth',
  token_url: '/o/oauth2/token'
)
