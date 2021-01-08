# frozen_string_literal: true

require "rails_helper"

RSpec.describe Tenure do
  describe ".find_tenure_type" do
    let(:tenure_attributes) do
      {
        "tenancies" => [
          {
            "tenureType" => "SEC: Secure",
            "present" => false
          },
          {
            "tenureType" => "MPA: Mesne Profit Ac",
            "present" => true
          }
        ]
      }
    end

    let(:reference) { "100023022310" }

    it "returns any current tenure object built from the API client response" do
      allow(PlatformApis::TenancyInformation::Client).to receive(
        :get_tenancy_information_by_property_reference
      ).with(reference).and_return(
        tenure_attributes
      )

      tenure = described_class.find_tenure_type(reference)

      expect(tenure.typeCode).to eq "MPA"
      expect(tenure.typeDescription).to eq("Mesne Profit Ac")
      expect(tenure.canRaiseRepair).to eq(true)
    end
  end

  describe ".build" do
    it "builds a new tenure with supplied attributes" do
      tenure = described_class.build("SEC: Secure")

      expect(tenure.typeCode).to eq "SEC"
      expect(tenure.typeDescription).to eq("Secure")
      expect(tenure.canRaiseRepair).to eq(true)
    end
  end

  describe ".can_raise_a_repair?" do
    Tenure::RAISABLE_TENURES.each do |tenure_code|
      it "returns true for the tenure code: #{tenure_code} which can raise a repair" do
        expect(described_class.can_raise_a_repair?(tenure_code)).to eq(true)
      end
    end

    # Non raisable tenure codes taken from Repairs Hub V1
    %w(FRE FRS HPH LEA LHS LTA RSL RTM SHO SLL SMW SPS SPT SSE TBB THA THL THO TLA TPL).each do |tenure_code|
      it "returns false for the tenure code: #{tenure_code} which can not raise a repair" do
        expect(described_class.can_raise_a_repair?(tenure_code)).to eq(false)
      end
    end
  end
end
