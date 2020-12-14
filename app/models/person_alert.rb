# frozen_string_literal: true

class PersonAlert < Alert
  include ActiveModel::Model

  class << self
    def for_resident_alerts(property_reference)
      response = for_tenancy_reference(find_tenancy_reference(property_reference))

      build(response)
    end

  private

    def find_tenancy_reference(reference)
      response = PlatformApis::TenancyInformation::Client.get_tenancy_information_by_property_reference(reference)

      # The API returns a 200 with response "tenancies": [] when no
      # tenancy agreement reference can be found for a property.
      # In this case we will return nil if response["tenancies"] is empty
      response["tenancies"].first["tenancyAgreementReference"] if response["tenancies"].any?
    end

    def for_tenancy_reference(reference)
      # Return empty array when no tenancy agreement reference has been found
      return [] unless reference

      PlatformApis::Alerts::Client.get_alerts_by_tenancy_reference(reference)["contacts"].first["alerts"]
    end
  end
end
