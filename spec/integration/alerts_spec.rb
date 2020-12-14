# frozen_string_literal: true

require "swagger_helper"

RSpec.describe "Alerts API" do
  let(:api_client) { create(:api_client) }
  let(:"Authorization") { "Bearer #{api_client.token}" }

  path "/api/v2/properties/{propertyReference}/alerts" do
    get "Retrieves alerts" do
      tags "Alerts"
      produces "application/json"

      parameter name: :propertyReference, in: :path, type: :string, description: "The property reference", example: "00023404"

      response "200", "Gets all alerts for a property" do
        before do
          stub_alerts_property_request(
            reference: "00023404",
            response_body:
              {
                "propertyReference": "00023404",
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

          stub_tenancy_information_property_request(
            reference: "00023404",
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
                        "endDate": "2020-01-01",
                        "alertCode": "CV",
                        "description": "No Lone Visits"
                      },
                      {
                        "startDate": "2018-04-13",
                        "endDate": "2020-01-01",
                        "alertCode": "VA",
                        "description": "Verbal Abuse or Threat of"
                      }
                    ]
                  }
                ]
              },
            status: 200
          )
        end

        schema type: :object,
        properties: {
          propertyReference: { type: :string },
          locationAlert: {
            type: :array,
            items: {
              type: :object,
              properties: {
                type: { type: :string },
                comments: { type: :string },
                startDate: { type: :string },
                endDate: { type: :string }
              }
            }
          },
          personAlert: {
            type: :array,
            items: {
              type: :object,
              properties: {
                type: { type: :string },
                comments: { type: :string },
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
