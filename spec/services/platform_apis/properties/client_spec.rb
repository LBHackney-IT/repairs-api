# frozen_string_literal: true

require "rails_helper"

RSpec.describe PlatformApis::Properties::Client do
  let(:request) { double }

  before do
    allow(described_class).to receive(:request).and_return(request)
  end

  describe ".get_properties_by_address" do
    it "calls the Request object with an address query parameter" do
      expect(request).to receive(:retrieve).with("properties?address=16 Pitcairn House  St Thomass Square")

      described_class.get_properties_by_address("16 Pitcairn House  St Thomass Square")
    end
  end

  describe ".get_properties_by_postcode" do
    it "calls the Request object with a postcode query parameter" do
      expect(request).to receive(:retrieve).with("properties?postcode=E9 6PT")

      described_class.get_properties_by_postcode("E9 6PT")
    end
  end
end
