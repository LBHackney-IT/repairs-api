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
    end
  end
end
