# frozen_string_literal: true

class Tenure
  include ActiveModel::Model

  attr_accessor :typeCode, :typeDescription

  class << self
    def find_tenure_type(reference)
      response = PlatformApis::TenancyInformation::Client.get_tenancy_information_by_property_reference(reference)

      # The API returns a 200 with response "tenancies": [] when no
      # tenancy agreement reference can be found for a property.
      # In this case we will return nil if response["tenancies"] is empty
      build(response["tenancies"].first["tenureType"]) if response["tenancies"].any?
    end

    # we are receiving just 1 line of a string as a response: "LEA: Leasehold (RTB)"
    # and we need to have code and description of a tenureType separately
    # that is why we are using split method
    def build(attribute)
      new(
        typeCode: attribute.split(": ").first,
        typeDescription: attribute.split(": ").last
      )
    end
  end
end
