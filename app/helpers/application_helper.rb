module ApplicationHelper
  def user_avatar(user)
    user.avatar.attached? ? user.avatar : 'https://github.com/sparshalc.png'
  end

  def render_turbo_stream_flash_messages
    turbo_stream.prepend 'flash', partial: 'partials/flash'
  end

  def devise_path?
    params[:controller] == 'users/sessions' || params[:controller] == 'users/registrations' || params[:controller] == 'users/passwords'
  end

  def dashboard_path?
    params[:controller] == 'dashboard'
  end

  def is_correct_user(model)
    model.user_id == current_user.id
  end

  def class_for_available(car, base_class="bg")
    car.availability ? "#{base_class}-success" : "#{base_class}-danger"
  end

  def correct_user_or_admin(model)
    current_user.id == model.user_id || current_user.admin?
  end

  def active_link(active_controller, active_class, not_active, active_action="index")
    if params[:controller] == "#{active_controller}" && params[:action] == "#{active_action}"
      "#{active_class}"
    else
      "#{not_active}"
    end
  end

  def status_background(status)
    return '' if status.pending?

    status.accepted? ? 'bg-success text-white' : 'bg-danger text-white'
  end
end
