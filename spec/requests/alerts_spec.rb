# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Alerts" do
  let(:api_client) { create(:api_client) }
  let(:headers) { AuthHelper.auth_headers(api_client.token) }

  describe "#property" do
    context "when searching by property reference and there are alerts on the property" do
      before do
        stub_alerts_property_request(
          reference: "0001234",
          response_body:
            {
              "propertyReference": "0001234",
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
          reference: "0001234",
          response_body:
            {
              "tenancies": [
                {
                  "tenancyAgreementReference": "011111/01"
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

        get("/api/v2/properties/0001234/alerts", headers: headers)
      end

      it "returns a JSON representation from a single property" do
        parsed_response = JSON.parse(response.body)

        expect(parsed_response).to eq(
          {
            "propertyReference" => "0001234",
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
          }
        )
      end
    end

    context "when searching by property reference and there are no alerts on the property" do
      before do
        stub_alerts_property_request(
          reference: "0001234",
          response_body:
            {
              "propertyReference": "0001234",
              "alerts": []
            },
          status: 200
        )
      end

      context "when a tenancy agreement reference is found" do
        before do
          stub_tenancy_information_property_request(
            reference: "0001234",
            response_body:
              {
                "tenancies": [
                  {
                    "tenancyAgreementReference": "011111/01"
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
                    "alerts": []
                  }
                ]
              },
            status: 200
          )

          get("/api/v2/properties/0001234/alerts", headers: headers)
        end

        it "returns a JSON representation for a property without alerts" do
          parsed_response = JSON.parse(response.body)

          expect(parsed_response).to eq(
            {
              "propertyReference" => "0001234",
              "locationAlert" => [],
              "personAlert" => []
            }
          )
        end
      end

      context "when a tenancy agreement reference is not found" do
        before do
          stub_tenancy_information_property_request(
            reference: "0001234",
            response_body:
              {
                "tenancies": []
              },
            status: 200
          )

          get("/api/v2/properties/0001234/alerts", headers: headers)
        end

        it "returns a JSON representation for a property without alerts" do
          parsed_response = JSON.parse(response.body)

          expect(parsed_response).to eq(
            {
              "propertyReference" => "0001234",
              "locationAlert" => [],
              "personAlert" => []
            }
          )
        end
      end
    end

    context "when searching by property reference with nil headers" do
      before do
        stub_alerts_property_request(
          reference: "0001234",
          response_body:
            {
              "propertyReference": "0001234",
              "alerts": []
            },
          status: 200
        )

        get("/api/v2/properties/0001234/alerts", headers: nil)
      end

      it "returns invalid auth token error message" do
        parsed_response = JSON.parse(response.body)

        expect(parsed_response.first).to eq(["errors", "Invalid auth token"])
      end
    end

    context "when searching by property reference with valid headers but the ApiClient is not present" do
      let(:api_client) { build(:api_client) }

      before do
        stub_alerts_property_request(
          reference: "0001234",
          response_body:
            {
              "propertyReference": "0001234",
              "alerts": []
            },
          status: 200
        )

        get("/api/v2/properties/0001234/alerts", headers: headers)
      end

      it "returns couldn't find ApiClient error message" do
        parsed_response = JSON.parse(response.body)

        expect(parsed_response.first).to eq(["errors", "Couldn't find ApiClient"])
      end
    end
  end
end
