class GoogleAuthController < ApplicationController
  skip_before_action :authenticate_user!, only: [:connect, :callback]

  def connect
    if current_user
      redirect_to root_path
    else
      redirect_to oauth_authorization_url, allow_other_host: true
    end
  end

  def callback
    token = fetch_oauth_token(params[:code])
    user_info = fetch_user_info(token.token)

    @user = find_or_create_user(user_info, token)
    session[:user_id] = @user.id

    redirect_to root_path
  end

  private

  def oauth_authorization_url
    OAUTH2_CLIENT.auth_code.authorize_url(
      scope: 'https://www.googleapis.com/auth/calendar',
      redirect_uri: REDIRECT_URI,
      access_type: 'offline',
      prompt: 'consent'
    )
  end

  def fetch_oauth_token(code)
    OAUTH2_CLIENT.auth_code.get_token(code, redirect_uri: REDIRECT_URI)
  end

  def find_or_create_user(user_info, token)
    User.find_or_create_by(email: user_info[:email]) do |user|
      user.access_token = token.token
      user.refresh_token = token.refresh_token
      user.token_expires_at = Time.at(token.expires_at)
    end
  end

  def fetch_user_info(access_token)
    response = Faraday.get(USER_INFO_URL) do |req|
      req.headers['Authorization'] = "Bearer #{access_token}"
    end

    JSON.parse(response.body, symbolize_names: true)
  end
end
