# frozen_string_literal: true

class CautionaryAlert
  include ActiveModel::Model

  attr_accessor :propertyReference, :alerts

  class << self
    def for_property_reference(reference)
      response = PlatformApis::CautionaryAlerts::Client.
        get_cautionary_alerts_by_property_reference(reference)

      response.key?(:message) ? [] : build(response)
    end

    def build(attributes)
      new(
        propertyReference: attributes["propertyReference"],
        # rubocop:disable Layout/LineLength
        alerts: attributes["alerts"].empty? ? {} : Alert.build(attributes["alerts"].first)
        # rubocop:enable Layout/LineLength
      )
    end
  end
end
