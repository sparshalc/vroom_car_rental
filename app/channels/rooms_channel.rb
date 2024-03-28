class RoomsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "rooms_channel"
  end

  def unsubscribed
  end
end
