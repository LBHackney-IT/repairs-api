# frozen_string_literal: true

class AlertEntry
  include ActiveModel::Model

  attr_accessor :type, :comments, :startDate, :endDate

  class << self
    def build(attributes)
      new(
        type: attributes["alertCode"],
        comments: attributes["description"],
        startDate: attributes["startDate"],
        endDate: attributes["endDate"]
      )
    end
  end
end
