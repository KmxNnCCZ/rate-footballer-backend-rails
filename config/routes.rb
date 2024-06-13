Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', 
                              at: 'auth', 
                              skip: [:omniauth_callbacks],
                              controllers: {
                                registrations: 'auth/registrations'
                              }

  namespace :auth do
    resources :sessions, only: %i[index]
  end
end
