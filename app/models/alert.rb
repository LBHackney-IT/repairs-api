# frozen_string_literal: true

class Alert
  include ActiveModel::Model

  attr_accessor :alertCode, :description, :startDate, :endDate

  class << self
    def build(attributes)
      new(
        alertCode: attributes["alertCode"],
        description: attributes["description"],
        startDate: attributes["startDate"],
        endDate: attributes["endDate"]
      )
    end
  end
end
