# frozen_string_literal: true

require "rails_helper"

RSpec.describe PlatformApis::Alerts::Client do
  let(:request) { double }

  before do
    allow(described_class).to receive(:request).and_return(request)
  end

  describe ".get_alerts_by_property_reference" do
    it "calls the Request object with a property reference id" do
      expect(request).to receive(:retrieve).with("cautionary-alerts/properties/100023022310")

      described_class.get_alerts_by_property_reference("100023022310")
    end
  end

  describe ".get_alerts_by_tenancy_reference" do
    it "calls the Request object with a property reference id" do
      expect(request).to receive(:retrieve).with("cautionary-alerts/people?tag_ref=01111/01")

      described_class.get_alerts_by_tenancy_reference("01111/01")
    end
  end
end
