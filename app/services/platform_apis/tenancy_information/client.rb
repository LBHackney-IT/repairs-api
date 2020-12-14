# frozen_string_literal: true

module PlatformApis
  module TenancyInformation
    class Client
      class_attribute :api_type
      self.api_type = :tenancy_information

      class << self
        include RequestConnection

        def get_tenancy_information_by_property_reference(reference)
          request.retrieve("tenancies?property_reference=#{reference}")
        end
      end
    end
  end
end
