class Users::SessionsController < Devise::SessionsController
  def after_sign_in_path_for(resource)
    # Redirect to appropriate dashboard based on role
    dashboard_path
  end
end
