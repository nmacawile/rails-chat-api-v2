module Response
  def json_response(payload, status = :ok)
    render json: payload, status: status
  end
end
