module ApplicationHelper
  def user_avatar(user)
    user.avatar.attached? ? user.avatar : 'avatar.png'
  end
end
