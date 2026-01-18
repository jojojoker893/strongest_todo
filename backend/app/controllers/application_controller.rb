class ApplicationController < ActionController::API
  def current_user
    @current_user
  end

  def authenticate_user!
    header = request.headers["Authorization"]
    return render_unauthorized if header.blank?
    token = header&.split(" ").last

    user = JwtAuth.call(token)

    if user
      @current_user = user
    else
      render_unauthorized
    end
  end

  def render_unauthorized
    render json: { error: "unauthorized" }, status: :unauthorized
  end

  def record_not_found
    render json: { error: "Not Found" }, status: :not_found
  end

end
