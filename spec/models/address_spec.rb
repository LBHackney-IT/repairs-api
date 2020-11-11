# frozen_string_literal: true

require "rails_helper"

RSpec.describe Address do
  describe ".build" do
    it "builds a new address with supplied attributes" do
      address = described_class.build(
        "address1" => "16 Pitcairn House  St Thomass Square",
        "postCode" => "E9 6PT"
      )

      expect(address.shortAddress).to eq "16 Pitcairn House  St Thomass Square"
      expect(address.postcode).to eq "E9 6PT"
    end
  end
end
