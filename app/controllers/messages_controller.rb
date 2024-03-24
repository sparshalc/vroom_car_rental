class MessagesController < ApplicationController
  def create
    @message = current_user.messages.create(content: msg_params[:content], room_id: params[:room_id])
    @room = Room.find(params[:room_id])
    @user = User.find(current_user.id)
  end

  private

  def msg_params
    params.require(:message).permit(:content, :user_id)
  end
end
