# frozen_string_literal: true

require "rails_helper"

RSpec.describe PlatformApis::CautionaryAlerts::Client do
  let(:request) { double }

  before do
    allow(described_class).to receive(:request).and_return(request)
  end

  describe ".get_cautionary_alerts_by_property_reference" do
    it "calls the Request object with a property reference id" do
      expect(request).to receive(:retrieve).with("cautionary-alerts/properties/100023022310")

      described_class.get_cautionary_alerts_by_property_reference("100023022310")
    end
  end
end
