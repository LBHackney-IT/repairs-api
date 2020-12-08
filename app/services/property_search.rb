# frozen_string_literal: true

class PropertySearch
  def initialize(params)
    @id = params.fetch(:id, nil)
  end

  def perform
    return id_query if id.present?
  end

private

  attr_reader :id

  def id_query
    Property.for_reference(id)
  end
end
