Rails.application.routes.draw do
  root 'calendar_events#index'

  get 'auth/connect', to: 'google_auth#connect', as: :google_connect
  get 'auth/callback', to: 'google_auth#callback', as: :google_callback
  get 'sign_in', to: 'sessions#new', as: :sign_in
  delete 'sign_out', to: 'sessions#destroy', as: :destroy_session
  get 'calendar_events', to: 'calendar_events#index', as: :calendar_events
end
