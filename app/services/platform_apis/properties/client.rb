# frozen_string_literal: true

module PlatformApis
  module Properties
    class Client
      class << self
        def get_properties_by_address(address)
          request.retrieve("properties?address=#{address}")
        end

        def get_properties_by_postcode(postcode)
          request.retrieve("properties?postcode=#{postcode}")
        end

      private

        def request
          @request ||= Request.new(connection)
        end

        # rubocop:disable Layout/LineLength
        def connection
          Connection.api(
            url:
              Rails.application.credentials.platform_apis[:properties][:url],
            key:
              Rails.application.credentials.platform_apis[:properties][:x_api_key]
          )
        end
        # rubocop:enable Layout/LineLength
      end
    end
  end
end
