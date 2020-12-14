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
      alerts: alerts
    }
  end

  def alerts
    Alert.for_property_reference(id)&.except(:propertyReference)
  end

  def property
    Property.for_reference(id)
  end
end
