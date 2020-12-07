# frozen_string_literal: true

require "swagger_helper"

RSpec.describe "Cautionary Alerts API" do
  let(:api_client) { create(:api_client) }
  let(:"Authorization") { "Bearer #{api_client.token}" }

  path "/api/v2/properties/{propertyReference}/cautionary-alerts" do
    get "Retrieves cautionary alerts" do
      tags "Cautionary Alerts"
      produces "application/json"

      parameter name: :propertyReference, in: :path, type: :string, description: "The property reference", example: "00023404"

      response "200", "Gets all cautionary alerts for a property" do
        before do
          stub_cautionary_alerts_property_request(
            reference: "00023404",
            response_body:
              {
                "propertyReference": "0001234",
                "alerts": [
                  {
                    "startDate": "2011-02-16",
                    "endDate": "2020-01-01",
                    "alertCode": "DIS",
                    "description": "Property Under Disrepair"
                  }
                ]
              },
            status: 200
          )
        end

        schema type: :object,
        properties: {
          propertyReference: { type: :string },
          alerts: {
            type: :array,
            items: {
              type: :object,
              properties: {
                alertCode: { type: :string },
                description: { type: :string },
                startDate: { type: :string },
                endDate: { type: :string }
              }
            }
          }
        },
        required: [ "propertyReference" ]

        let(:propertyReference) { "00023404" }
        run_test!
      end

      response "401", "Invalid auth token" do
        let(:"Authorization") { "Bearer not_a_token" }

        schema type: :object,
        properties: {
          errors: { type: :string, example: "Invalid auth token" }
        }
        let(:propertyReference) { "00023404" }

        run_test!
      end

      response "404", "Property not found" do
        before do
          stub_cautionary_alerts_property_request(
            reference: "999",
            response_body: "Property cautionary alert(s) for property reference 999 not found",
            status: 404
          )
        end

        schema type: :object,
        properties: {
          errors: {
            type: :array,
            items: {
              type: :object,
              properties: {
                title: { type: :string },
                status: { type: :string, example: "404" }
              }
            }
          }
        }

        let(:propertyReference) { "999" }
        run_test!
      end
    end
  end
end
