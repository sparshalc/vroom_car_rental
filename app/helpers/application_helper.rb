module ApplicationHelper
  def user_avatar(user)
    user.avatar.attached? ? user.avatar : 'https://github.com/sparshalc.png'
  end

  def render_turbo_stream_flash_messages
    turbo_stream.prepend "flash", partial: "partials/flash"
  end
end
