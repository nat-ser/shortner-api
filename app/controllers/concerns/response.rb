# frozen_string_literal: true

# controller helper to render json with status
module Response
  def json_response(object, status = :ok)
    render json: object, status: status
  end
end
