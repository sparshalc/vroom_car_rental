class Users::InvitationsController < Devise::InvitationsController
  skip_before_action :authenticate_user!
  before_action :configure_permitted_parameters
  before_action :configure_permitted_parameters, if: :devise_controller?

  def update
    super do |resource|
      resource.update(password: params["user"]["password"],
                      phone_number: params["user"]["phone_number"],
                      full_name: params["user"]["full_name"],
                      avatar: params["user"]["avatar"],
                      location: params["user"]["location"])
        redirect_to new_user_session_path and return
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:invite, keys: [:phone_number, :full_name, :avatar, :password, :location])
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:accept_invitation, keys: [:phone_number, :full_name, :avatar, :password, :location])
  end
end
