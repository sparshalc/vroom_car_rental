class NotificationController < ApplicationController
  def index
    if current_user
      @notifications =current_user.notifications.reverse
      current_user.notifications.mark_as_read!
    end
  end

  def destroy_all
    Notification.destroy_all

    respond_to do |format|
      format.turbo_stream { flash.now[:notice] = "Notification cleared!" }
    end
  end

end
