class OnlineChannel < Turbo::StreamsChannel
  def subscribed
    super
    users_online =  Kredis.unique_list "users_online"
    users_online << current_user.id

    Turbo::StreamsChannel.broadcast_prepend_to(
      verified_stream_name_from_params,
      target: 'users-list',
      partial: 'partials/user',
      locals: { user: current_user }
    )
  end

  def unsubscribed
    users_online =  Kredis.unique_list "users_online"
    users_online.remove current_user.id

    Turbo::StreamsChannel.broadcast_remove_to(
      verified_stream_name_from_params,
      target: "user_#{current_user.id}"
    )
  end
end
