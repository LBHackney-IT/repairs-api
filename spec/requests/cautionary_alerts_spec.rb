# frozen_string_literal: true

require "rails_helper"

RSpec.describe "CautionaryAlerts" do
  let(:api_client) { create(:api_client) }
  let(:headers) { AuthHelper.auth_headers(api_client.token) }

  describe "#property" do
    context "when searching by property reference and there are alerts on the property" do
      before do
        stub_cautionary_alerts_property_request(
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

        get("/api/v2/properties/0001234/cautionary-alerts", headers: headers)
      end

      it "returns a JSON representation from a single property" do
        parsed_response = JSON.parse(response.body)

        expect(parsed_response).to eq(
          {
            "propertyReference" => "0001234",
            "alerts" => [
              {
                "alertCode" => "DIS",
                "description" => "Property Under Disrepair",
                "startDate" => "2011-02-16",
                "endDate" => nil
              }
            ]
          }
        )
      end
    end

    context "when searching by property reference and there are no alerts on the property" do
      before do
        stub_cautionary_alerts_property_request(
          reference: "0001234",
          response_body:
            {
              "propertyReference": "0001234",
              "alerts": []
            },
          status: 200
        )

        get("/api/v2/properties/0001234/cautionary-alerts", headers: headers)
      end

      it "returns a JSON representation from a single property" do
        parsed_response = JSON.parse(response.body)

        expect(parsed_response).to eq(
          {
            "propertyReference" => "0001234",
            "alerts" => []
          }
        )
      end
    end

    context "when searching by property reference with nil headers" do
      before do
        stub_cautionary_alerts_property_request(
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

        get("/api/v2/properties/0001234/cautionary-alerts", headers: nil)
      end

      it "returns invalid auth token error message" do
        parsed_response = JSON.parse(response.body)

        expect(parsed_response.first).to eq(["errors", "Invalid auth token"])
      end
    end

    context "when searching by property reference with valid headers but the ApiClient is not present" do
      let(:api_client) { build(:api_client) }

      before do
        stub_cautionary_alerts_property_request(
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

        get("/api/v2/properties/0001234/cautionary-alerts", headers: headers)
      end

      it "returns couldn't find ApiClient error message" do
        parsed_response = JSON.parse(response.body)

        expect(parsed_response.first).to eq(["errors", "Couldn't find ApiClient"])
      end
    end

    context "when searching by a property reference that has no alerts" do
      before do
        stub_cautionary_alerts_property_request(
          reference: "0123",
          response_body: "Property cautionary alert(s) for property reference 0123 not found",
          status: 404
        )

        get("/api/v2/properties/0123/cautionary-alerts", headers: headers)
      end

      it "returns error hash response" do
        parsed_response = JSON.parse(response.body)

        expect(parsed_response).to eq(
          {
            "errors" => [
              {
                "status" => "404",
                "title" => "Property cautionary alert(s) for property reference 0123 not found"
              }
            ]
          }
        )
      end
    end
  end
end
