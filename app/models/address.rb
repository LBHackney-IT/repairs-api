# frozen_string_literal: true

class Address
  include ActiveModel::Model

  attr_accessor :shortAddress, :postalCode, :addressLine, :streetSuffix

  class << self
    def build(attributes)
      new(
        shortAddress: attributes["address1"],
        postalCode: attributes["postCode"],
        addressLine: split_address(attributes["address1"]).first,
        streetSuffix: street_suffix(attributes["address1"])
      )
    end

  private

    def split_address(address)
      address.split("  ")
    end

    def split_address?(address)
      split_address(address).length > 1
    end

    def street_suffix(address)
      split_address?(address) ? split_address(address).last : ""
    end
  end
end
