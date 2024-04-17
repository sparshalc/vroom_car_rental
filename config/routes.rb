Rails.application.routes.draw do
  get 'notifications', to: 'notification#index', as: 'notifications'
  delete 'notifications', to: 'notification#destroy_all'

  resources :cars do
    resources :bookings, except: %i[index]
    resources :comments
    resources :policies, except: %i[edit update show]
  end

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    passwords: 'users/passwords',
    invitations: 'users/invitations'
  }

  get 'bookings', to: 'user#bookings'

  resources :rooms do
    resources :messages
  end

  root "pages#home"
  get '/guides', to: 'pages#guides', as: 'guides'

  get 'dashboard', to: 'dashboard#index'
  get 'dashboard/cars', to: 'dashboard#cars'
  get 'dashboard/users', to: 'dashboard#users'
  get 'dashboard/bookings', to: 'dashboard#bookings'

  resources :booking_payments, only: %i[create]
  get 'booking_payments/success', to: "booking_payments#success"

  get "up" => "rails/health#show", as: :rails_health_check

  get '*path', to: redirect('/404.html'), constraints: lambda { |req| !req.path.start_with?('/rails/active_storage') }
end
