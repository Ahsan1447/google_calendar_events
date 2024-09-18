class GoogleAuthController < ApplicationController
    skip_before_action :authenticate_user!, only: [:connect, :callback]
  
    def connect
      if current_user
        redirect_to root_path
      else
        redirect_to OAUTH2_CLIENT.auth_code.authorize_url(
          scope: 'https://www.googleapis.com/auth/calendar',
          redirect_uri: REDIRECT_URI,
          access_type: 'offline',
          prompt: 'consent'
        ), allow_other_host: true
      end
    end
  
    def callback
      token = OAUTH2_CLIENT.auth_code.get_token(params[:code], redirect_uri: REDIRECT_URI)
  
      user_info = fetch_user_info(token.token)
  
      @user = User.find_or_create_by(email: user_info[:email]) do |user|
        user.access_token = token.token
        user.refresh_token = token.refresh_token
        user.token_expires_at = Time.at(token.expires_at)
      end
  
      session[:user_id] = @user.id
  
      redirect_to root_path
    end
  
    private
  
    def fetch_user_info(access_token)
      response = Faraday.get('https://www.googleapis.com/oauth2/v3/userinfo') do |req|
        req.headers['Authorization'] = "Bearer #{access_token}"
      end
  
      JSON.parse(response.body, symbolize_names: true)
    end
  end
  