Rails.application.routes.draw do
  # ================================
  # Authentication
  # ================================
  devise_for :users, controllers: {
    registrations: "users/registrations",
    sessions: "users/sessions"
  }

  # ================================
  # Root
  # ================================
  root "properties#index"

  # ================================
  # Properties
  # ================================
  resources :properties do
    member do
      patch :publish
      patch :archive
      post  :toggle_favorite
      delete :purge_image
    end
    collection do
      get :my_properties
      get :favorites
    end

    # Rental applications nested under properties
    resources :rental_applications, only: [ :new, :create ]
  end

  # ================================
  # Rental Applications (global)
  # ================================
  resources :rental_applications, only: [ :index, :show, :update, :destroy ]

  # ================================
  # Documents
  # ================================
  resources :documents, only: [ :index, :new, :create, :show, :destroy ]

  # ================================
  # Conversations & Messages
  # ================================
  resources :conversations, only: [ :index, :show, :create ] do
    resources :messages, only: :create
  end

  # ================================
  # Notifications
  # ================================
  resources :notifications, only: [ :index ] do
    member do
      patch :mark_as_read
    end
    collection do
      patch :mark_all_as_read
    end
  end

  # ================================
  # Payments
  # ================================
  resources :payments, only: [ :index, :show ] do
    member do
      post :process_payment
      get  :status
    end
  end

  # Momo callback
  post "/momo/callback", to: "payments#callback"

  # ================================
  # Dashboard
  # ================================
  get "dashboard", to: "dashboards#show"

# ================================
# Admin routes
# ================================
# Additional routes will be added here as we progress
namespace :admin do
  resources :users, only: [ :index, :show, :edit, :update ]
  resources :settings, only: [ :index, :update ]
  resources :reports, only: [ :index ]
  end



  # ================================
  # Future routes
  # ================================
  # Additional routes will be added here as we progress
  get "/privacy-policy", to: "pages#privacy_policy"
  get "/terms-of-service", to: "pages#terms_of_service"
end
