# frozen_string_literal: true

module PlatformApis
  module CautionaryAlerts
    class Client
      class_attribute :api_type
      self.api_type = :cautionary_alerts

      class << self
        include RequestConnection

        def get_cautionary_alerts_by_property_reference(reference)
          request.retrieve("cautionary-alerts/properties/#{reference}")
        end
      end
    end
  end
end
