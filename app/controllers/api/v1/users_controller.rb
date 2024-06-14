class Api::V1::UsersController < ApplicationController
  skip_before_action :authorize_request, only: :create

  def index
    @users = UserQuery.new(params[:q]).call
              .excluding(current_user)
              .page(params[:page])
              .per(params[:per_page])
    json_response @users
  end

  def create
    user = User.create!(user_params)
    auth_data = AuthenticateUser.new(params[:email], params[:password]).call
    json_response(
      { **auth_data,
        message: "Account created successfully." },
      :created)
  end

  private

  def user_params
    params.permit(:email, :password, :first_name, :last_name, :handle)
  end
end
