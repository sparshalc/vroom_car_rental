class CommentsController < ApplicationController
  before_action :set_car, only: %i[new create destroy]

  def new
    @comment = @car.comments.new
  end

  def create
    @comment = @car.comments.new(comments_params)
    @comment.user_id = current_user.id

    respond_to do |format|
      if @comment.save
        format.turbo_stream { flash.now[:notice] = "Comment Added!" }
      else
        redirect_to root_path, alert: 'Failed to delete comment.'
      end
    end
  end

  def destroy
    @comment = @car.comments.find(params[:id])

    respond_to do |format|
      if @comment.destroy
        format.turbo_stream { flash.now[:notice] = "Comment destroyed!" }
      else
        redirect_to root_path, alert: 'Failed to delete comment.'
      end
    end
  end

  private

  def set_car
    @car = Car.find(params[:car_id])
  end

  def comments_params
    params.require(:comment).permit(:title)
  end
end
