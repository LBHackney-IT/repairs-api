# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Properties" do
  describe "index" do
    context "when searching by postcode" do
      before do
        stub_properties_request(
          query_params: { postcode: "A1 1AA" },
          response_body: [
            {
              propRef: "001",
              address1: "1 Example Road",
              postCode: "A1 1AA",
              levelCode: "1",
              subtypCode: "DWE"
            }
          ],
          status: 200
        )

        get("/api/v1/properties", params: { postcode: "A1 1AA" })
      end

      it "returns JSON representations of properties" do
        parsed_response = JSON.parse(response.body)

        expect(parsed_response.first).to eq(
          {
            "propertyReference" => "001",
            "address" => {
              "shortAddress" => "1 Example Road",
              "postalCode" => "A1 1AA"
            },
            "hierarchyType" => {
              "levelCode" => "1",
              "subTypeCode" => "DWE",
              "subTypeDescription" => "Dwelling"
            }
          }
        )
      end
    end

    context "when searching by address" do
      before do
        stub_properties_request(
          query_params: { address: "1 Example Road" },
          response_body: [
            {
              propRef: "001",
              address1: "1 Example Road",
              postCode: "A1 1AA",
              levelCode: "1",
              subtypCode: "DWE"
            }
          ],
          status: 200
        )

        get("/api/v1/properties", params: { address: "1 Example Road" })
      end

      it "returns JSON representations of properties" do
        parsed_response = JSON.parse(response.body)

        expect(parsed_response.first).to eq(
          {
            "propertyReference" => "001",
            "address" => {
              "shortAddress" => "1 Example Road",
              "postalCode" => "A1 1AA"
            },
            "hierarchyType" => {
              "levelCode" => "1",
              "subTypeCode" => "DWE",
              "subTypeDescription" => "Dwelling"
            }
          }
        )
      end
    end

    context "when searching by a general query" do
      before do
        stub_properties_request(
          query_params: { address: "1 Example Road" },
          response_body: [
            {
              propRef: "001",
              address1: "1 Example Road",
              postCode: "A1 1AA",
              levelCode: "1",
              subtypCode: "DWE"
            }
          ],
          status: 200
        )

        get("/api/v1/properties", params: { q: "1 Example Road" })
      end

      it "returns JSON representations of properties" do
        parsed_response = JSON.parse(response.body)

        expect(parsed_response.first).to eq(
          {
            "propertyReference" => "001",
            "address" => {
              "shortAddress" => "1 Example Road",
              "postalCode" => "A1 1AA"
            },
            "hierarchyType" => {
              "levelCode" => "1",
              "subTypeCode" => "DWE",
              "subTypeDescription" => "Dwelling"
            }
          }
        )
      end
    end
  end

  describe "show" do
    context "when searching by a property reference" do
      before do
        stub_property_request(
          reference: "100023022310",
          response_body:
            {
              propRef: "100023022310",
              address1: "1 Example Road",
              postCode: "A1 1AA",
              levelCode: "1",
              subtypCode: "DWE"
            },
          status: 200
        )

        get("/api/v1/properties/100023022310")
      end

      it "returns a JSON representation from a single property" do
        parsed_response = JSON.parse(response.body)

        expect(parsed_response).to eq(
          {
            "propertyReference" => "100023022310",
            "address" => {
              "shortAddress" => "1 Example Road",
              "postalCode" => "A1 1AA"
            },
            "hierarchyType" => {
              "levelCode" => "1",
              "subTypeCode" => "DWE",
              "subTypeDescription" => "Dwelling"
            }
          }
        )
      end
    end
  end
end
