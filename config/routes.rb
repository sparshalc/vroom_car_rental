Rails.application.routes.draw do

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  root "pages#home"

  get "up" => "rails/health#show", as: :rails_health_check
end
