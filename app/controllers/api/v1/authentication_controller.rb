class Api::V1::AuthenticationController < ApplicationController
  skip_before_action :authorize_request, only: :login

  def login
    auth_data = AuthenticateUser.new(params[:email], params[:password]).call
    json_response(auth_data, :ok)
  end
end
