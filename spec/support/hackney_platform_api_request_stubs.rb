# frozen_string_literal: true

RSpec.configure do |config|
  helpers = Module.new do
    def stub_properties_request(query_params:, response_body:, status:)
      stub_request(
        :get,
        "#{Rails.application.credentials.platform_apis[:properties][:url]}properties"
      ).with(
        headers: { "X-Api-Key" => Rails.application.credentials.platform_apis[:properties][:x_api_key] },
        query:   query_params
      ).to_return(
        body: JSON.generate(response_body),
        status: status
      )
    end

    def stub_property_request(reference:, response_body:, status:)
      stub_request(
        :get,
        "#{Rails.application.credentials.platform_apis[:properties][:url]}properties/#{reference}"
      ).with(
        headers: { "X-Api-Key" => Rails.application.credentials.platform_apis[:properties][:x_api_key] },
      ).to_return(
        body: JSON.generate(response_body),
        status: status
      )
    end
  end

  config.include helpers, type: :request
end
