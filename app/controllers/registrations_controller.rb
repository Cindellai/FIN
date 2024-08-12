class RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]

  protected

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :first_name, :last_name, :role, :profile_picture, :bio])
  end

  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:username, :first_name, :last_name, :profile_picture, :role, :bio])
  end
end
