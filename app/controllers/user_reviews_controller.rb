class UserReviewsController < ApplicationController
  before_action :require_admin
  before_action :set_user

  def new
    @user_review = UserReview.new
  end

  def create
    @user_review = UserReview.new(new_review_params)

    @user_review.user = @user

    if @user_review.save
      @user_review.approved? ? @user.approved! : @user.refused!
      message = @user.approved? ? t('user_approved') : t('user_reproved')
      return redirect_to users_url, notice: message
    end
    render :new
  end

  private

  def new_review_params
    params.require(:user_review).permit(:status, :refusal)
  end

  def set_user
    @user = User.find params[:user_id]
  end
end
