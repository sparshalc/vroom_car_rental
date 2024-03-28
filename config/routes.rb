Rails.application.routes.draw do
  resources :cars do
    resources :comments
    resources :policies, except: %i[edit update show]
  end

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    passwords: 'users/passwords',
    invitations: 'users/invitations'
  }

  resources :rooms do
    resources :messages
  end

  root "pages#home"

  get 'dashboard', to: 'dashboard#index'
  get 'dashboard/cars', to: 'dashboard#cars'
  get 'dashboard/users', to: 'dashboard#users'

  get "up" => "rails/health#show", as: :rails_health_check

  get '*path', to: redirect('/404.html'), constraints: lambda { |req| !req.path.start_with?('/rails/active_storage') }
end
