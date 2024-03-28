class PoliciesController < ApplicationController

  before_action :set_car
  before_action :set_policy, only: %i[destroy]
  before_action :verify_corrent_user_or_admin,only: %i[new create]

  def index
    @policies = Policy.all
  end

  def new
    @policy = Policy.new
  end

  def create
    @policy = Policy.new(policy_params)

    respond_to do |format|
      if @policy.save
        format.turbo_stream
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @policy.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @policy.destroy!

    respond_to do |format|
      format.turbo_stream
    end
  end

  private
    def verify_corrent_user_or_admin
      routing_exception unless current_user.id == @car.user_id || current_user.admin?
    end

    def set_policy
      @policy = Policy.find(params[:id])
    end

    def set_car
      @car = Car.find(params[:car_id])
    end

    def policy_params
      params.require(:policy).permit(:title, :car_id, :user_id)
    end
end
