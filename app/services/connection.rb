# frozen_string_literal: true

class Connection
  def self.api(url:, token:)
    Faraday.new(url: url) do |faraday|
      faraday.response :logger, Rails.logger do |logger|
        logger.filter(/(Authorization:\s*)\S*$/, '\1[FILTERED]')
      end

      faraday.adapter Faraday.default_adapter
      faraday.headers["Content-Type"] = "application/json"
      faraday.headers["Authorization"] = token
    end
  end
end
