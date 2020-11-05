# frozen_string_literal: true

require "faraday"
require "json"

class Connection
  def self.api(url:, key:)
    Faraday.new(url: url) do |faraday|
      faraday.response :logger, Rails.logger do |logger|
        logger.filter(/(x-api-key:\s*)\S*$/, '\1[FILTERED]')
      end

      faraday.adapter Faraday.default_adapter
      faraday.headers["Content-Type"] = "application/json"
      faraday.headers["x-api-key"] = key
    end
  end
end
