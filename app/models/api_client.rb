# frozen_string_literal: true

class ApiClient < ApplicationRecord
  validates :client_id, :client_secret, presence: true
  validates :client_id, :client_secret, uniqueness: true

  def token
    JsonWebToken.encode(client_id: client_id, client_secret: client_secret)
  end
end
