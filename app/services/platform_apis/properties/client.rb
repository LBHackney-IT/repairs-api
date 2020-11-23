# frozen_string_literal: true

module PlatformApis
  module Properties
    class Client
      class_attribute :api_type
      self.api_type = :properties

      class << self
        include RequestConnection

        def get_properties_by_address(address)
          request.retrieve("properties?address=#{address}")
        end

        def get_properties_by_postcode(postcode)
          request.retrieve("properties?postcode=#{postcode}")
        end

        def get_property_by_reference(reference)
          request.retrieve("properties/#{reference}")
        end
      end
    end
  end
end
