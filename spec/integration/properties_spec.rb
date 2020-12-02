# frozen_string_literal: true

require "swagger_helper"

RSpec.describe "Properties API" do
  path "/api/v2/properties/{propertyReference}" do
    get "Retrieves a property" do
      tags "Properties"
      produces "application/json"

      security [Bearer: {}]

      parameter name: :propertyReference, in: :path, type: :string

      let(:api_client) { create(:api_client) }

      response "200", "Property found" do
        schema type: :object,
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
          },
          required: [ "propertyReference" ]

        let(:Authorization) { "Bearer #{api_client.token}" }
        let(:propertyReference) { "00023404" }

        run_test!
      end
    end
  end

  path "/api/v2/properties/?address={address}" do
    get "Retrieves all matching properties given the address params" do
      tags "Properties"
      produces "application/json"

      security [Bearer: {}]

      parameter name: :address, in: :path, type: :string

      let(:api_client) { create(:api_client) }

      response "200", "Properties found" do
        schema type: :object,
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

        let(:Authorization) { "Bearer #{api_client.token}" }
        let(:address) { "banister house" }

        run_test!
      end
    end
  end

  path "/api/v2/properties/?postcode={postcode}" do
    get "Retrieves all matching properties given the postcode params" do
      tags "Properties"
      produces "application/json"

      security [Bearer: {}]

      parameter name: :postcode, in: :path, type: :string

      let(:api_client) { create(:api_client) }

      response "200", "Properties found" do
        schema type: :object,
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

        let(:Authorization) { "Bearer #{api_client.token}" }
        let(:postcode) { "E9 6BT" }

        run_test!
      end
    end
  end

  path "/api/v2/properties/?q={params}" do
    get "Retrieves all matching properties given the query (address or postcode) params" do
      tags "Properties"
      produces "application/json"

      security [Bearer: {}]

      parameter name: :params, in: :path, type: :string

      let(:api_client) { create(:api_client) }

      response "200", "Properties found" do
        schema type: :object,
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

        let(:Authorization) { "Bearer #{api_client.token}" }
        let(:params) { "E9 6BT" }

        run_test!
      end
    end
  end
end
