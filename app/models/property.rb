# frozen_string_literal: true

class Property
  include ActiveModel::Model

  attr_accessor :propertyReference, :address, :hierarchyType

  class << self
    def for_address(address)
      response = fake_response.select { |p|
        p["address1"].downcase == address.downcase
      }

      response ? response.map { |r| build(r) } : []
    end

    def for_postcode(postcode)
      response = fake_response.select { |p|
        p["postCode"].downcase == postcode.downcase
      }

      response ? response.map { |r| build(r) } : []
    end

    def for_reference(reference)
      response = fake_response.find { |p| p["propRef"] == reference }

      response ? build(response) : []
    end

    def build(attributes)
      new(
        propertyReference: attributes["propRef"]&.strip,
        address: Address.build(attributes),
        hierarchyType: HierarchyType.build(attributes)
      )
    end

    # rubocop:disable Layout/LineLength
    def fake_response
      [{ "propRef" => "000000000001", "address1" => "2 LYME GROVE HOUSE LYME GROVE", "postCode" => "E9 6PS", "levelCode" => "0", "subtypCode" => "DWE" }, { "propRef" => "000000000002", "address1" => "4 LYME GROVE HOUSE LYME GROVE", "postCode" => "E9 6PS", "levelCode" => "0", "subtypCode" => "DWE" }, { "propRef" => "000000000003", "address1" => "5 LYME GROVE HOUSE LYME GROVE", "postCode" => "E9 6PS", "levelCode" => "0", "subtypCode" => "DWE" }, { "propRef" => "000000000004", "address1" => "7 LYME GROVE HOUSE LYME GROVE", "postCode" => "E9 6PS", "levelCode" => "0", "subtypCode" => "DWE" }, { "propRef" => "000000000005", "address1" => "9 LYME GROVE HOUSE LYME GROVE", "postCode" => "E9 6PS", "levelCode" => "0", "subtypCode" => "DWE" }, { "propRef" => "000000000006", "address1" => "10 LYME GROVE HOUSE LYME GROVE", "postCode" => "E9 6PS", "levelCode" => "0", "subtypCode" => "DWE" }, { "propRef" => "000000000007", "address1" => "19 LYME GROVE HOUSE LYME GROVE", "postCode" => "E9 6PS", "levelCode" => "0", "subtypCode" => "DWE" }, { "propRef" => "000000000008", "address1" => "22 LYME GROVE HOUSE LYME GROVE", "postCode" => "E9 6PS", "levelCode" => "0", "subtypCode" => "DWE" }, { "propRef" => "000000000009", "address1" => "23 LYME GROVE HOUSE LYME GROVE", "postCode" => "E9 6PS", "levelCode" => "0", "subtypCode" => "DWE" }, { "propRef" => "000000000010", "address1" => "24 LYME GROVE HOUSE LYME GROVE", "postCode" => "E9 6PS", "levelCode" => "0", "subtypCode" => "DWE" }]
    end
    # rubocop:enable Layout/LineLength
  end
end
