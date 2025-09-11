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

  # User dashboard
  get "dashboard", to: "dashboards#show"

  # Additional routes will be added here as we progress
end
