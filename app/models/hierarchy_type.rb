# frozen_string_literal: true

class HierarchyType
  include ActiveModel::Model

  attr_accessor :levelCode, :subTypeCode

  def self.build(attributes)
    new(
      levelCode: attributes["levelCode"],
      subTypeCode: attributes["subtypCode"]
    )
  end
end
