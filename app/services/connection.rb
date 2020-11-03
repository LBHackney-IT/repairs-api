# frozen_string_literal: true

require "faraday"
require "json"

class Connection
  def self.api(url:, key:)
    Faraday.new(url: url) do |faraday|
      faraday.response :logger
      faraday.adapter Faraday.default_adapter
      faraday.headers["Content-Type"] = "application/json"
      faraday.headers["x-api-key"] = key
    end
  end
end
