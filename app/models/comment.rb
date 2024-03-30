class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :car

  has_noticed_notifications

  after_create_commit { broadcast_notification }
  after_destroy_commit { remove_destroyed_notifications }

  def remove_destroyed_notifications
    Notification.all.each do |notification|
      if notification.params[:message].nil?
        notification.delete
      end
    end
  end

  def broadcast_notification
    return if user == car.user

    CommentNotification.with(message: self).deliver_later(car.user)

    broadcast_prepend_to "notifications_#{car.user.id}",
                          target: "notifications_#{car.user.id}",
                          partial: 'notifications/notification',
                          locals: { user:, car:, unread: true}

    ActionCable.server.broadcast 'notification_count', { car_user: car.user.id, user: user, notifications: car.user.notifications.count, car_name: car.name }
  end
end
