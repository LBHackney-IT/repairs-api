# frozen_string_literal: true

class Property
  include ActiveModel::Model

  attr_accessor :propertyReference, :address, :hierarchyType

  class << self
    def for_address(address)
      response = PlatformApis::Properties::Client.
        get_properties_by_address(address)
      response.map { |r| build(r) }
    end

    def for_postcode(postcode)
      response = PlatformApis::Properties::Client.
        get_properties_by_postcode(postcode)
      response.map { |r| build(r) }
    end

    def for_reference(reference)
      response = PlatformApis::Properties::Client.
        get_property_by_reference(reference)

      build(response)
    end

    def build(attributes)
      new(
        propertyReference: attributes["propRef"]&.strip,
        address: Address.build(attributes),
        hierarchyType: HierarchyType.build(attributes)
      )
    end
  end
end
