# frozen_string_literal: true

module PlatformApis
  module PropertyInformationApi
    class Client
      API_URL = ENV["PROPERTIES_API_URL"]
      API_KEY = ENV["X_API_KEY"]

      def self.get_properties_by_address(address)
        request.retrieve("properties/?address=#{address}")
      end

      def self.get_properties_by_postcode(postcode)
        request.retrieve("properties/?postcode=#{postcode}")
      end

    private

      def self.connection
        Connection.api(url: API_URL, key: API_KEY)
      end

      def self.request
        @request ||= Request.new(connection)
      end
    end
  end
end
