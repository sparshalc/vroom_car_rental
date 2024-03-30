class NotificationCountChannel < ApplicationCable::Channel
  def subscribed
    stream_from "notification_count"
  end

  def unsubscribed
  end
end
