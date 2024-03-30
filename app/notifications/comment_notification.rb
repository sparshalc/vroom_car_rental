class CommentNotification < Noticed::Base
  deliver_by :database

  def comment
    params[:message]
  end

  def creator
    comment&.user
  end

  def car
    comment&.car
  end

  def url
    car_path(params[:car])
  end
end
