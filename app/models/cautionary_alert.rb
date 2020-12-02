# frozen_string_literal: true

class CautionaryAlert
  include ActiveModel::Model

  attr_accessor :propertyReference, :alerts

  class << self
    def for_property_reference(reference)
      response = PlatformApis::CautionaryAlerts::Client.
        get_cautionary_alerts_by_property_reference(reference)

      build(response)
    end

    def build(attributes)
      new(
        propertyReference: attributes["propertyReference"],
        alerts: attributes["alerts"].map { |alert| Alert.build(alert) }
      )
    end
  end
end
