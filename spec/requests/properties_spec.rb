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
              "subTypeCode" => "DWE"
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
              "subTypeCode" => "DWE"
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
              "subTypeCode" => "DWE"
            }
          }
        )
      end
    end
  end

  def stub_properties_request(query_params:, response_body:, status:)
    stub_request(
      :get,
      "#{Rails.application.credentials.platform_apis[:properties][:url]}properties"
    ).with(
      headers: { "X-Api-Key" => Rails.application.credentials.platform_apis[:properties][:x_api_key] },
      query:   query_params
    ).to_return(
      body: JSON.generate(response_body),
      status: status
    )
  end
end
