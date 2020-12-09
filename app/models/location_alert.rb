# frozen_string_literal: true

class LocationAlert < Alert
  include ActiveModel::Model

  class << self
    def for_address_alerts(property_reference)
      response = PlatformApis::Alerts::Client.
        get_alerts_by_property_reference(property_reference)

      build(response["alerts"])
    end
  end
end
