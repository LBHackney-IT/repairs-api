# frozen_string_literal: true

class Address
  include ActiveModel::Model

  attr_accessor :shortAddress, :postalCode

  def self.build(attributes)
    new(
      shortAddress: attributes["address1"],
      postalCode: attributes["postCode"]
    )
  end
end
