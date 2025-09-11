Rails.application.routes.draw do
  # Devise routes with custom controllers
  devise_for :users, controllers: {
    registrations: "users/registrations",
    sessions: "users/sessions"
  }

  # Root path
  root "properties#index"

  # Properties routes
  resources :properties do
    member do
      patch :publish
      patch :archive
      post :toggle_favorite
      delete :purge_image
    end
    collection do
      get :my_properties
      get :favorites
    end
  end
   resources :conversations, only: [ :index, :show, :create ] do
    resources :messages, only: :create
  end

  # Rental applications routes
  resources :rental_applications, only: [ :index, :show, :update, :destroy ]
  resources :properties do
    resources :rental_applications, only: [ :new, :create ]
  end

  # Notifications routes
  resources :notifications, only: [ :index ] do
    member do
      patch :mark_as_read
    end
    collection do
      patch :mark_all_as_read
    end
  end
  # User dashboard
  get "dashboard", to: "dashboards#show"

  # Additional routes will be added here as we progress
end
