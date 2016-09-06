class Api::V1::UsersController < Api::V1::BaseController
  before_action :authenticate_with_token!, only: [:update, :destroy]
  respond_to :json

  def create
    user = User.new(user_params)
    if user.save
      # Todo: This is not the best way to do i
      # It should be improved
      UserMailer.send_user_confimation_email(user.id).deliver! unless Rails.env == 'test'
      render json: user, status: 201, location: [:api, user]
    else
      render json: {errors: user.errors}, status: 422
    end
  end

  def update
    user = current_user

    if user.update_attributes(user_params)
      render json: user, status: 200, location: [:api, user]
    else
      render json: {errors: user.errors}, status: 422
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
