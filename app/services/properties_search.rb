# frozen_string_literal: true

class PropertiesSearch
  def initialize(params)
    @address = params.fetch(:address, nil)
    @postcode = params.fetch(:postcode, nil)
  end

  def perform
    return [] unless valid?

    return postcode_query if postcode.present?
    return address_query if address.present?
  end

private

  attr_reader :address, :postcode

  def valid?
    address || postcode
  end

  def address_query
    Property.for_address(address)
  end

  def postcode_query
    Property.for_postcode(postcode)
  end
end
