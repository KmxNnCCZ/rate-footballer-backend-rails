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

  resources :matches, only: %i[index], controller: 'competition_matches'
  resources :team, only: %i[index]


  resources :test, only: %i[index]
  get "hello_world", to: 'application#hello_world'
end
