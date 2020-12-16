# frozen_string_literal: true

class Tenure
  include ActiveModel::Model

  # Raisable tenure codes taken from Repairs Hub V1
  RAISABLE_TENURES = %w(ASY COM DEC INT MPA NON PVG SEC TAF TGA TRA)

  attr_accessor :typeCode, :typeDescription, :canRaiseRepair

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
        typeDescription: attribute.split(": ").last,
        canRaiseRepair: can_raise_a_repair?(attribute.split(": ").first)
      )
    end

    def can_raise_a_repair?(tenure_code)
      RAISABLE_TENURES.include?(tenure_code)
    end
  end
end
