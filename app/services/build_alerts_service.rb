# frozen_string_literal: true

class BuildAlertsService
  def initialize(property_reference)
    @property_reference = property_reference
  end

  def perform
    return build_alerts if property_reference.present?
  end

private

  attr_reader :property_reference

  def build_alerts
    {
      propertyReference: property_reference,
      locationAlert: location_alerts,
      personAlert: person_alerts
    }
  end

  def location_alerts
    LocationAlert.for_address_alerts(property_reference).locationAlert
  rescue Request::RecordNotFoundError
    # The property exists, but the alerts API has returned a 404, so we return
    # an array for consistency
    []
  end

  def person_alerts
    PersonAlert.for_resident_alerts(property_reference).personAlert
  end
end
