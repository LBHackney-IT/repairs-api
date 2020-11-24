# frozen_string_literal: true

require "swagger_helper"

RSpec.describe "Properties API" do

  path "/api/v1/properties/{propertyReference}" do

    get "Retrieves a property" do
      tags "Properties"
      produces "application/json", "application/xml"
      parameter name: :propertyReference, in: :path, type: :string

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

        let(:propertyReference) { "00023404" }
        run_test!
      end
    end
  end

  path "/api/v1/properties/?address={address}" do

    get "Retrieves all matching properties given the address params" do
      tags "Properties"
      produces "application/json", "application/xml"
      parameter name: :address, in: :path, type: :string

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

        let(:address) { "banister house" }
        run_test!
      end
    end
  end

  path "/api/v1/properties/?postcode={postcode}" do

    get "Retrieves all matching properties given the postcode params" do
      tags "Properties"
      produces "application/json", "application/xml"
      parameter name: :postcode, in: :path, type: :string

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

        let(:postcode) { "E9 6BT" }
        run_test!
      end
    end
  end

  path "/api/v1/properties/?q={params}" do

    get "Retrieves all matching properties given the query (address or postcode) params" do
      tags "Properties"
      produces "application/json", "application/xml"
      parameter name: :params, in: :path, type: :string

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

        let(:params) { "E9 6BT" }
        run_test!
      end
    end
  end
end
