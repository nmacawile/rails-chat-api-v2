class Api::V1::AuthenticationController < ApplicationController
  def login
    auth_data = AuthenticateUser.new(params[:email], params[:password]).call
    json_response(auth_data, :ok)
  end
end
