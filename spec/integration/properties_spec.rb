# frozen_string_literal: true

require "swagger_helper"

RSpec.describe "Properties API" do
  let(:api_client) { create(:api_client) }

  path "/api/v2/properties/{propertyReference}" do
    get "Retrieves a property" do
      tags "Properties"
      produces "application/json"

      parameter name: :propertyReference, in: :path, required: true, type: :string, description: "The property reference", example: "00023404"

      response "200", "Property found" do
        let(:"Authorization") { "Bearer #{api_client.token}" }

        before do
          stub_property_request(
            reference: "00023404",
            response_body: {
              propRef: "001",
              address1: "1 Example Road",
              postCode: "A1 1AA",
              levelCode: "1",
              subtypCode: "DWE"
            },
            status: 200
          )

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
          property: {
            type: :object,
            properties: {
              propertyReference: { type: :string },
              address: {
                properties: {
                  shortAddress: { type: :string },
                  postalCode: { type: :string },
                  addressLine: { type: :string },
                  streetSuffix: { type: :string }
                }
              },
              hierarchyType: {
                properties: {
                  levelCode: { type: :string },
                  subTypeCode: { type: :string },
                  subTypeDescription: { type: :string }
                }
              }
            }
          },
          alerts: {
            type: :object,
            properties: {
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
            }
          },
          tenure: {
            type: :object,
            properties: {
              typeCode: { type: :string },
              typeDescription: { type: :string },
              canRaiseRepair: { type: :boolean }
            }
          }
        }

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
        let(:"Authorization") { "Bearer #{api_client.token}" }

        before do
          stub_property_request(
            reference: "999",
            response_body: "Please use a valid property reference",
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

  path "/api/v2/properties" do
    get "Retrieves all matching properties given the query params" do
      tags "Properties"
      produces "application/json"

      parameter name: :address, in: :query, type: :string, required: false, description: "A partial or full address", example: "St Thomass Square"
      parameter name: :postcode, in: :query, type: :string, required: false, description: "A postcode", example: "E9 6PT"
      parameter name: :q, in: :query, type: :string, required: false, description: "A postcode or partial or full address", example: "E9 6PT"

      before do
        stub_properties_request(
          query_params: { postcode: "E9 6BT" },
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
      end

      response "200", "Properties found" do
        let(:"Authorization") { api_client.token }

        schema type: :array,
          items: {
            type: :object,
            properties: {
              propertyReference: { type: :string },
              address: {
                properties: {
                  shortAddress: { type: :string },
                  postalCode: { type: :string },
                  addressLine: { type: :string },
                  streetSuffix: { type: :string }
                }
              },
              hierarchyType: {
                properties: {
                  levelCode: { type: :string },
                  subTypeCode: { type: :string },
                  subTypeDescription: { type: :string }
                }
              }
            }
          }

        let(:q) { "E9 6BT" }
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
