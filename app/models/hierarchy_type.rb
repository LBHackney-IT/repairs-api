# frozen_string_literal: true

class HierarchyType
  include ActiveModel::Model

  attr_accessor :levelCode, :subtypCode

  def self.build(attributes)
    new(
      levelCode: attributes["levelCode"],
      subtypCode: attributes["subtypCode"]
    )
  end
end
