Rails.application.routes.draw do
  resources :cars do
    resources :comments
  end

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    passwords: 'users/passwords'
  }

  resources :rooms do
    resources :messages
  end

  root "pages#home"

  get 'dashboard', to: 'dashboard#index'

  get "up" => "rails/health#show", as: :rails_health_check
  get '*path' => redirect('/404.html')
end
