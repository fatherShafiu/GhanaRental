Rails.application.routes.draw do
  # Devise routes with custom controllers
  devise_for :users, controllers: {
    registrations: "users/registrations",
    sessions: "users/sessions"
  }

  # Root path
  root "pages#home"

  # User dashboard based on role
  get "dashboard", to: "dashboards#show"

  # Additional routes will be added here as we progress
end
