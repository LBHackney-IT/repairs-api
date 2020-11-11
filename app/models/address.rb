# frozen_string_literal: true

class Address
  include ActiveModel::Model

  attr_accessor :shortAddress, :postcode

  def self.build(attributes)
    new(
      shortAddress: attributes["address1"],
      postcode: attributes["postCode"]
    )
  end
end
