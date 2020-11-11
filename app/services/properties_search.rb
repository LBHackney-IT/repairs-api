# frozen_string_literal: true

class PropertiesSearch
  def initialize(params)
    @address = params.fetch(:address, nil)
    @postcode = params.fetch(:postcode, nil)
    @q = params.fetch(:q, nil)
  end

  def perform
    return [] unless valid?

    return postcode_query if postcode.present?
    return address_query if address.present?
    return q_query if q.present?
  end

private

  attr_reader :address, :postcode, :q

  def valid?
    address || postcode || q
  end

  def address_query
    Property.for_address(address)
  end

  def postcode_query
    Property.for_postcode(postcode)
  end

  def q_query
    if is_postcode?(q)
      Property.for_postcode(q)
    else
      Property.for_address(q)
    end
  end

  def format_postcode(s)
    s.to_s.gsub(/\s+/, "").upcase
  end

  def is_postcode?(s)
    format_postcode(s)[/^[A-Z]{1,2}([0-9]{1,2}|[0-9][A-Z])[0-9][A-Z]{2}$/]
  end
end
