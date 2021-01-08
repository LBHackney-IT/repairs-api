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

        get("/api/v2/properties", params: { postcode: "A1 1AA" }, headers: headers)
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

        get("/api/v2/properties", params: { address: "1 Example Road" }, headers: headers)
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

        get("/api/v2/properties", params: { q: "1 Example Road" }, headers: headers)
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

        get("/api/v2/properties", params: { postcode: "A1 1AA" }, headers: nil)
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

        get("/api/v2/properties", params: { postcode: "A1 1AA" }, headers: headers)
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
      end

      context "with tenancy information details" do
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

          stub_alerts_property_request(
            reference: "100023022310",
            response_body:
              {
                "propertyReference": "100023022310",
                "alerts": [
                  {
                    "startDate": "2011-02-16",
                    "endDate": nil,
                    "alertCode": "DIS",
                    "description": "Property Under Disrepair"
                  }
                ]
              },
            status: 200
          )

          stub_tenancy_information_property_request(
            reference: "100023022310",
            response_body:
              {
                "tenancies": [
                  {
                    "tenancyAgreementReference": "011111/01",
                    "tenureType": "SEC: Secure",
                    "present": true
                  }
                ]
              },
            status: 200
          )

          stub_alerts_residents_request(
            tag_ref: "011111/01",
            response_body:
              {
                "contacts": [
                  {
                    "tenancyAgreementReference": "011111/01",
                    "alerts": [
                      {
                        "startDate": "2018-04-13",
                        "endDate": nil,
                        "alertCode": "CV",
                        "description": "No Lone Visits"
                      },
                      {
                        "startDate": "2018-04-13",
                        "endDate": nil,
                        "alertCode": "VA",
                        "description": "Verbal Abuse or Threat of"
                      }
                    ]
                  }
                ]
              },
            status: 200
          )

          get("/api/v2/properties/100023022310", headers: headers)
        end

        it "returns a JSON representation from a single property" do
          parsed_response = JSON.parse(response.body)

          expect(parsed_response).to eq(
            "property" => {
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
            },
            "alerts" => {
              "locationAlert" => [
                {
                  "type" => "DIS",
                  "comments" => "Property Under Disrepair",
                  "startDate" => "2011-02-16",
                  "endDate" => nil
                }
              ],
              "personAlert" => [
                {
                  "type" => "CV",
                  "comments" => "No Lone Visits",
                  "startDate" => "2018-04-13",
                  "endDate" => nil
                },
                {
                  "type" => "VA",
                  "comments" => "Verbal Abuse or Threat of",
                  "startDate" => "2018-04-13",
                  "endDate" => nil
                }
              ]
            },
            "tenure" => {
              "typeCode" => "SEC",
              "typeDescription" => "Secure",
              "canRaiseRepair" => true
            }
          )
        end
      end

      context "with no tenancy information details" do
        before do
          stub_property_request(
            reference: "100012345678",
            response_body:
              {
                propRef: "100012345678",
                address1: "1 Example Road",
                postCode: "A1 1AA",
                levelCode: "1",
                subtypCode: "DWE"
              },
            status: 200
          )

          stub_alerts_property_request(
            reference: "100012345678",
            response_body:
              {
                "propertyReference": "100012345678",
                "alerts": []
              },
            status: 200
          )

          stub_tenancy_information_property_request(
            reference: "100012345678",
            response_body:
              {
                "tenancies": []
              },
            status: 200
          )

          get("/api/v2/properties/100012345678", headers: headers)
        end

        it "returns a JSON representation from a single property with no tenure details and no alerts" do
          parsed_response = JSON.parse(response.body)

          expect(parsed_response).to eq(
            "property" => {
              "propertyReference" => "100012345678",
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
            },
            "alerts" => {
              "locationAlert" => [],
              "personAlert" => []
            },
            "tenure" => nil
          )
        end
      end
    end

    context "when searching by an invalid property reference" do
      before do
        stub_property_request(
          reference: "124124241",
          response_body:
            {
              "title": "Not Found",
              "status": "404"
            },
          status: 404
        )

        get("/api/v2/properties/124124241", headers: headers)
      end

      it "returns error hash response" do
        parsed_response = JSON.parse(response.body)

        expect(parsed_response).to eq(
          {
            "errors" => [
              {
                "status" => "404",
                "title" => "Not Found"
              }
            ]
          }
        )
      end
    end
  end
end
