# frozen_string_literal: true

class Property
  include ActiveModel::Model

  attr_accessor :propertyReference, :address, :hierarchyType

  def self.for_postcode(postcode)
    response = PlatformApis::PropertyInformationApi::Client.
      get_properties_by_postcode(postcode)
    response.map { |r| build(r) }
  end

  def self.build(attributes)
    new(
      propertyReference: attributes["propRef"]&.strip,
      address: Address.build(attributes),
      hierarchyType: HierarchyType.build(attributes)
    )
  end
end
