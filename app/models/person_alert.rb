# frozen_string_literal: true

class PersonAlert < Alert
  include ActiveModel::Model

  class << self
    def for_resident_alerts(property_reference)
      response = for_tenancy_reference(find_tenancy_reference(property_reference))

      build(response["contacts"].first["alerts"])
    end

  private

    def find_tenancy_reference(reference)
      response = PlatformApis::TenancyInformation::Client.get_tenancy_information_by_property_reference(reference)

      response["tenancies"].first["tenancyAgreementReference"]
    end

    def for_tenancy_reference(reference)
      PlatformApis::Alerts::Client.get_alerts_by_tenancy_reference(reference)
    end
  end
end
