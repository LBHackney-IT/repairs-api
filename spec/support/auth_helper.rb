# frozen_string_literal: true

module AuthHelper
  def self.auth_headers(token)
    {
      "AUTHORIZATION" => "#{token}"
    }
  end
end
