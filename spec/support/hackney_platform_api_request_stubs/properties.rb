# frozen_string_literal: true

RSpec.configure do |config|
  helpers = Module.new do
    def stub_properties_request(query_params:, response_body:, status:)
      stub_request(
        :get,
        "#{Rails.application.credentials.platform_apis[:properties][:url]}properties"
      ).with(
        headers: { "Authorization" => Rails.application.credentials.platform_apis[:properties][:token] },
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
        headers: { "Authorization" => Rails.application.credentials.platform_apis[:properties][:token] },
      ).to_return(
        body: JSON.generate(response_body),
        status: status
      )
    end
  end

  config.include helpers, type: :request
end
