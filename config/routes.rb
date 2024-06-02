Rails.application.routes.draw do
  get 'notifications', to: 'notification#index', as: 'notifications'
  delete 'notifications', to: 'notification#destroy_all'

  resources :cars do
    member do
      get '/share', to: 'cars#share'
    end
    resource :cover_image, only: [:destroy], module: :cars
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
  get 'payments', to: 'user#payments'
  post 'subscribe_to_newsletter', to: 'user#subscribe_to_newsletter', as: 'subscribe_to_newsletter'

  resources :rooms do
    resources :messages
  end

  resources :feedbacks,only: %i[create destroy index]

  root "pages#home"
  get 'guides', to: 'pages#guides', as: 'guides'
  get 'calendar', to: 'pages#calendar', as: 'calendar'
  get 'car/bookings/:id', to: 'pages#bookings', as: 'bookings_details'
  get 'payment/success', to: 'pages#payment_success', as: 'payment_success'
  get 'pricing', to: 'pages#pricing', as: 'pricing'

  get 'dashboard', to: 'dashboard#index'
  get 'dashboard/cars', to: 'dashboard#cars'
  get 'dashboard/users', to: 'dashboard#users'
  get 'dashboard/bookings', to: 'dashboard#bookings'
  get 'dashboard/feedbacks', to: 'dashboard#feedbacks'

  resources :deluxe_subscriptions, only: %i[create]
  get 'deluxe_subscriptions/success', to: "deluxe_subscriptions#success"

  resources :booking_payments, only: %i[create]
  get 'booking_payments/success', to: "booking_payments#success"

  get "up" => "rails/health#show", as: :rails_health_check

  get '*path', to: redirect('/404.html'), constraints: lambda { |req| !req.path.start_with?('/rails/active_storage') }
end
