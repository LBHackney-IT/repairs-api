# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Properties" do
  let(:api_client) { create(:api_client) }
  let(:headers) { AuthHelper.auth_headers(api_client.token) }

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

        get("/api/v1/properties", params: { postcode: "A1 1AA" }, headers: headers)
      end

      it "returns JSON representations of properties" do
        parsed_response = JSON.parse(response.body)

        expect(parsed_response.first).to eq(
          {
            "propertyReference" => "001",
            "address" => {
              "shortAddress" => "1 Example Road",
              "postalCode" => "A1 1AA",
              "addressLine" => "1 Example Road",
              "streetSuffix" => ""
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

        get("/api/v1/properties", params: { address: "1 Example Road" }, headers: headers)
      end

      it "returns JSON representations of properties" do
        parsed_response = JSON.parse(response.body)

        expect(parsed_response.first).to eq(
          {
            "propertyReference" => "001",
            "address" => {
              "shortAddress" => "1 Example Road",
              "postalCode" => "A1 1AA",
              "addressLine" => "1 Example Road",
              "streetSuffix" => ""
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

        get("/api/v1/properties", params: { q: "1 Example Road" }, headers: headers)
      end

      it "returns JSON representations of properties" do
        parsed_response = JSON.parse(response.body)

        expect(parsed_response.first).to eq(
          {
            "propertyReference" => "001",
            "address" => {
              "shortAddress" => "1 Example Road",
              "postalCode" => "A1 1AA",
              "addressLine" => "1 Example Road",
              "streetSuffix" => ""
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

    context "when searching by postcode with nil headers" do
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

        get("/api/v1/properties", params: { postcode: "A1 1AA" }, headers: nil)
      end

      it "returns JSON representations of properties" do
        parsed_response = JSON.parse(response.body)

        expect(parsed_response.first).to eq(["errors", "Invalid auth token"])
      end
    end

    context "when searching by postcode with a valid headers and the ApiClient is not present" do
      let(:api_client) { build(:api_client) }

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

        get("/api/v1/properties", params: { postcode: "A1 1AA" }, headers: headers)
      end

      it "returns JSON representations of properties" do
        parsed_response = JSON.parse(response.body)

        expect(parsed_response.first).to eq(["errors", "Couldn't find ApiClient"])
      end
    end
  end

  describe "show" do
    context "when searching by property reference" do
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

        get("/api/v1/properties/100023022310", headers: headers)
      end

      it "returns a JSON representation from a single property" do
        parsed_response = JSON.parse(response.body)

        expect(parsed_response).to eq(
          {
            "propertyReference" => "100023022310",
            "address" => {
              "shortAddress" => "1 Example Road",
              "postalCode" => "A1 1AA",
              "addressLine" => "1 Example Road",
              "streetSuffix" => ""
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
