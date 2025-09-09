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
    end
    collection do
      get :my_properties
      get :favorites # Add this line
    end
  end

  # User dashboard based on role
  get "dashboard", to: "dashboards#show"

  # Additional routes will be added here as we progress
end
