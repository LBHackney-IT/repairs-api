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
      alerts: alerts,
      tenure: tenure
    }
  end

  def alerts
    Alert.for_property_reference(id)&.except(:propertyReference)
  end

  def tenure
    Tenure.find_tenure_type(id)
  end

  def property
    Property.for_reference(id)
  end
end
