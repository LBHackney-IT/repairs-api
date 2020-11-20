# frozen_string_literal: true

class ApplicationController < ActionController::API
  before_action :authenticate_token!

  def authenticate_token!
    payload = JsonWebToken.decode(auth_token)
    ApiClient.find_by!(
      client_id: payload["client_id"],
      client_secret: payload["client_secret"]
    )
  rescue ActiveRecord::RecordNotFound => e
    render json: { errors: e.message }, status: :unauthorized
  rescue JWT::DecodeError
    render json: { errors: "Invalid auth token" }, status: :unauthorized
  end

private

  def auth_token
    @auth_token ||= request.headers.fetch("Authorization", "").split(" ").last
  end
end
