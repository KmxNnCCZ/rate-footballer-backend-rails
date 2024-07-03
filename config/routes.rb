Rails.application.routes.draw do
  get 'matches/index'
  mount_devise_token_auth_for 'User', 
                              at: 'auth', 
                              skip: [:omniauth_callbacks],
                              controllers: {
                                registrations: 'auth/registrations'
                              }

  namespace :auth do
    resources :sessions, only: %i[index]
  end

  resources :matches, only: %i[index show], controller: 'competition_matches'
  resources :rates, only: %i[index show create edit update destroy]
  resources :comments, only: %i[create update destroy]

  resources :test, only: %i[index]
  get "hello_world", to: 'application#hello_world'

  post "send_email", to: 'email#send_email'
end
