class Api::V1::UsersController < ApplicationController
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
    params.permit(:email, :password, :first_name, :last_name)
  end
end
