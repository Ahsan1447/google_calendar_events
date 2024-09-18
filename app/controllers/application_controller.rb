class ApplicationController < ActionController::Base
  before_action :authenticate_user!, unless: :skip_authentication?

  private

  def authenticate_user!
    if current_user.nil?
      redirect_to sign_in_path, alert: 'You need to sign in with Google first.'
    end
  end

  def skip_authentication?
    # List routes that should not be authenticated
    ['auth/connect', 'auth/callback', 'sign_in'].include?(request.path)
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
end
