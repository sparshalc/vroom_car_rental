class FeedbacksController < ApplicationController
  before_action :set_feedback, only: %i[destroy ]

  def index
    @feedbacks = Feedback.all
    @feedback = Feedback.new
  end

  def create
    @feedback = current_user.feedbacks.build(feedback_params)

    respond_to do |format|
      if @feedback.save
        format.turbo_stream { flash[:now] = "Feedback successfully sent"}
      else
        format.html { render :index, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @feedback.destroy!

    respond_to do |format|
      format.html { redirect_to feedbacks_url, notice: "Feedback was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    def set_feedback
      @feedback = Feedback.find(params[:id])
    end

    def feedback_params
      params.require(:feedback).permit(:name, :email, :message, :user_id, :private)
    end
end
