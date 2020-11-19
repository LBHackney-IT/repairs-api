# frozen_string_literal: true

class Address
  include ActiveModel::Model

  attr_accessor :shortAddress, :postalCode, :addressLine

  class << self
    def build(attributes)
      new(
        shortAddress: attributes["address1"],
        postalCode: attributes["postCode"],
        addressLine: address_line(attributes["address1"])
      )
    end

  private

    def address_line(address)
      address.split("  ").first
    end
  end
end
