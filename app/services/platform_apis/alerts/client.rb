# frozen_string_literal: true

module PlatformApis
  module Alerts
    class Client
      class_attribute :api_type
      self.api_type = :alerts

      class << self
        include RequestConnection

        def get_alerts_by_property_reference(reference)
          request.retrieve("cautionary-alerts/properties/#{reference}")
        end

        def get_alerts_by_tenancy_reference(reference)
          request.retrieve("cautionary-alerts/people?tag_ref=#{reference}")
        end
      end
    end
  end
end
