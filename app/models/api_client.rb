# frozen_string_literal: true

class ApiClient < ApplicationRecord
  has_secure_token :client_id
  has_secure_token :client_secret

  def token
    JsonWebToken.encode(client_id: client_id, client_secret: client_secret)
  end
end
