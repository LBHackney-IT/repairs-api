# frozen_string_literal: true

class PropertySearch
  def initialize(params)
    @id = params.fetch(:id, nil)
  end

  def perform
    return id_query if id.present?
  end

private

  attr_reader :id

  def id_query
    {
      property: property,
      cautionaryAlerts: cautionary_alerts
    }
  end

  # The property exists, but the alerts API has returned a 404, so we return
  # an array for consistency
  def cautionary_alerts
    CautionaryAlert.for_property_reference(id).alerts
  rescue Request::RecordNotFoundError
    []
  end

  def property
    Property.for_reference(id)
  end
end
