# frozen_string_literal: true

require "rails_helper"

RSpec.describe Property do
  let(:property_attributes_1) do
    {
      "propRef" => "100023022310",
      "address1" => "16 Pitcairn House  St Thomass Square",
      "postCode" => "E9 6PT",
      "levelCode" => "7",
      "subtypCode" => "DWE"
    }
  end

  let(:property_attributes_2) do
    {
      "propRef" => "123456789",
      "address1" => "16 Pitcairn House  St Richardss Square",
      "postCode" => "E1 1AA",
      "levelCode" => "7",
      "subtypCode" => "DWE"
    }
  end

  describe ".for_address" do
    let(:address) { "16 Pitcairn House" }

    it "returns an array of property objects built from the API client response" do
      allow(PlatformApis::Properties::Client).to receive(
        :get_properties_by_address
      ).with(address).and_return(
        [
          property_attributes_1,
          property_attributes_2
        ]
      )

      properties = described_class.for_address(address)

      expect(properties.count).to eq 2
      expect(properties.first.propertyReference).to eq "100023022310"
      expect(properties.second.propertyReference).to eq "123456789"
    end
  end

  describe ".for_postcode" do
    let(:postcode) { "E9 6PT" }

    it "returns an array of property objects built from the API client response" do
      allow(PlatformApis::Properties::Client).to receive(
        :get_properties_by_postcode
      ).with(postcode).and_return(
        [
          property_attributes_1,
          property_attributes_2
        ]
      )

      properties = described_class.for_postcode(postcode)

      expect(properties.count).to eq 2
      expect(properties.first.propertyReference).to eq "100023022310"
      expect(properties.second.propertyReference).to eq "123456789"
    end
  end

  describe ".for_reference" do
    let(:reference) { "100023022310" }

    it "returns a single property object built from the API client response" do
      allow(PlatformApis::Properties::Client).to receive(
        :get_property_by_reference
      ).with(reference).and_return(
        property_attributes_1
      )

      property = described_class.for_reference(reference)

      expect(property.propertyReference).to eq "100023022310"
      expect(property.address.postalCode).to eq("E9 6PT")
      expect(property.address.shortAddress).to eq("16 Pitcairn House  St Thomass Square")
      expect(property.address.addressLine).to eq("16 Pitcairn House")
      expect(property.address.streetSuffix).to eq("St Thomass Square")
      expect(property.hierarchyType.levelCode).to eq("7")
      expect(property.hierarchyType.subTypeCode).to eq("DWE")
      expect(property.hierarchyType.subTypeDescription).to eq("Dwelling")
    end
  end

  describe ".build" do
    it "builds a new property and child models with supplied attributes" do
      expect(Address).to receive(:build).once.with(property_attributes_1)
      expect(HierarchyType).to receive(:build).once.with(property_attributes_1)

      property = described_class.build(property_attributes_1)

      expect(property.propertyReference).to eq "100023022310"
    end
  end
end
