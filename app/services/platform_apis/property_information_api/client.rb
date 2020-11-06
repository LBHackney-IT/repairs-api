# frozen_string_literal: true

module PlatformApis
  module PropertyInformationApi
    class Client
      def self.get_properties_by_address(address)
        request.retrieve("properties?address=#{address}")
      end

      def self.get_properties_by_postcode(postcode)
        request.retrieve("properties?postcode=#{postcode}")
      end

      private

      def self.request
        @request ||= Request.new(connection)
      end

      def self.connection
        Connection.api(
          url: Rails.application.credentials.platform_apis[:properties][:url],
          key: Rails.application.credentials.platform_apis[:properties][:x_api_key]
        )
      end
    end
  end
end
