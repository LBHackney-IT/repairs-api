# frozen_string_literal: true

RSpec.configure do |config|
  helpers = Module.new do
    def stub_cautionary_alerts_property_request(reference:, response_body:, status:)
      stub_request(
        :get,
        "#{Rails.application.credentials.platform_apis[:cautionary_alerts][:url]}cautionary-alerts/properties/#{reference}"
      ).with(
        headers: { "Authorization" => Rails.application.credentials.platform_apis[:cautionary_alerts][:token] },
      ).to_return(
        body: JSON.generate(response_body),
        status: status
      )
    end
  end

  config.include helpers, type: :request
end
