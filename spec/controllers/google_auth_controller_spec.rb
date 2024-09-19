require 'rails_helper'
require 'webmock/rspec'

RSpec.describe GoogleAuthController, type: :controller do
  let(:oauth2_client) { double('OAuth2::Client') }
  let(:token) { double('OAuth2::AccessToken', token: 'access_token', refresh_token: 'refresh_token', expires_at: Time.now.to_i + 3600) }
  let(:invalid_code) { 'invalid_code' }
  let(:oauth2_error) { OAuth2::Error.new('Invalid code') }

  before do
    allow(OAUTH2_CLIENT).to receive(:auth_code).and_return(oauth2_client)
    allow(oauth2_client).to receive(:authorize_url).and_return('https://example.com/auth')
  end

	describe 'GET #connect' do
    context 'when the user is logged in' do
      before do
        # Create a user in the test database and set the session
        @user = User.create!(email: 'user@example.com')
        session[:user_id] = @user.id
      end

      it 'redirects to the root path' do
        get :connect
        expect(response).to redirect_to(root_path)
      end
    end

    context 'when the user is not logged in' do
      it 'redirects to the authorization URL' do
        get :connect
        expect(response).to redirect_to('https://example.com/auth')
      end
    end
  end

  describe 'GET #callback' do
    context 'when a valid code is provided' do
      before do
        allow(oauth2_client).to receive(:get_token).with('valid_code', redirect_uri: REDIRECT_URI).and_return(token)
        allow_any_instance_of(GoogleAuthController).to receive(:fetch_user_info).and_return(email: 'user@example.com')
      end

      it 'creates or updates the user' do
        expect {
          get :callback, params: { code: 'valid_code' }
        }.to change(User, :count).by(1)
      end

      it 'sets the user in the session' do
        get :callback, params: { code: 'valid_code' }
        expect(session[:user_id]).to eq(User.find_by(email: 'user@example.com').id)
      end

      it 'redirects to the root path' do
        get :callback, params: { code: 'valid_code' }
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
