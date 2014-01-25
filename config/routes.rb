require 'sidekiq/web'

Platinum::Application.routes.draw do
  match '/users/search' => 'users#search'
  resources :fields, :schedules, :comp_groups

  resources :registrations do
    member do
      put 'cancel'
      get 'checkout'
      get 'approved'
      get 'cancelled'
    end
  end

  resources :leagues do
    member do
      get 'register'
      get 'registrations'
      post 'capture_payments'
      get 'manage_roster'
      post 'upload_roster'
      get 'setup_roster_import'
      post 'import_roster'
    end

    resources :teams, only: [:new, :create]
  end

  resources :teams, except: [:new, :create]


  resources :games do
    member do
      get 'edit_score'
      put 'update_score'
    end
  end

  resources :users do
    member do
      get 'registrations'
      get 'edit_avatar'
      put 'update_avatar'
      delete 'destroy_avatar'
      get 'login_as'
    end
  end

  if ENV['sidekiq_path']
    mount Sidekiq::Web => ENV['sidekiq_path']
  end

  get 'help/login', to: 'help#login', as: 'login_help'
  get 'help/registration', to: 'help#registration', as: 'registration_help'

  get 'profile', to: 'profile#index', as: 'user_profile'
  get 'profile/edit', to: 'profile#edit', as: 'edit_user_profile'
  get 'profile/gRank', to: 'profile#edit_g_rank', as: 'edit_g_rank_profile'
  put 'profile/gRank', to: 'profile#update_g_rank', as: 'update_g_rank_profile'

  get 'login', to: 'auth#index', as: 'auth'
  post 'login', to: 'auth#login', as: 'login'
  get 'logout', to: 'auth#logout', as: 'logout'
  get 'reset-password', to: 'auth#forgot_password', as: 'forgot_password'
  post 'reset-password', to: 'auth#reset_password', as: 'reset_password'

  root to: 'dashboard#homepage', as: 'home'
end
