Rails.application.routes.draw do
  get 'matches/index'
  mount_devise_token_auth_for 'User', 
                              at: 'auth', 
                              skip: [:omniauth_callbacks],
                              controllers: {
                                registrations: 'auth/registrations',
                                sessions: 'auth/sessions',
                                passwords: 'auth/passwords',
                              }

  resources :matches, only: %i[index show], controller: 'competition_matches'
  resources :rates, only: %i[index show create edit update destroy]
  resources :comments, only: %i[create update destroy]

  resources :test, only: %i[index]
  get "hello_world", to: 'application#hello_world'

  post "send_email", to: 'email#send_email'

  resource :user, only: %i[update] do
    member do
      post 'send_change_request', to: 'users#send_change_request'
      get 'has_permission/:token', to: 'users#has_permission'  # メール変更のフォームを表示する
    end
  end
end
