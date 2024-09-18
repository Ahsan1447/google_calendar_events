class SessionsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:new, :create]

  def new
  end

  def create
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: 'You have been signed out.'
  end
end
