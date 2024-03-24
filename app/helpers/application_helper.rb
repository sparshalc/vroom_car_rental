module ApplicationHelper
  def user_avatar(user)
    user.avatar.attached? ? user.avatar : 'https://github.com/sparshalc.png'
  end

  def render_turbo_stream_flash_messages
    turbo_stream.prepend 'flash', partial: 'partials/flash'
  end

  def is_devise_path?
    params[:controller] == 'users/sessions' || params[:controller] == 'users/registrations' || params[:controller] == 'users/passwords'
  end

  def is_dashboard_path?
    params[:controller] == 'dashboard'
  end

  def is_correct_user(model)
    model.user_id == current_user.id
  end

  def class_for_available(car)
    car.availability ? 'bg-success' : 'bg-danger'
  end
end
