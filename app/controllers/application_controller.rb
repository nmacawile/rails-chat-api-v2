class ApplicationController < ActionController::API
  include Response
  include ExceptionHandler

  before_action :authorize_request
  attr_reader :current_user
  
  def authorize_request
    @current_user = (AuthorizeApiRequest.new(request.headers).call)[:user]
  end

  protected
  
  def restrict_access
    unless @chat.users.include?(current_user)
      raise ExceptionHandler::Forbidden, "Access denied"
    end
  end
end
