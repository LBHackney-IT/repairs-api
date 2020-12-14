# frozen_string_literal: true

class Alert
  include ActiveModel::Model

  attr_accessor :locationAlert, :personAlert

  class << self
    def for_property_reference(reference)
      BuildAlertsService.new(reference).perform
    end

    def build(alerts)
      new(
        "#{to_s.camelize(:lower)}": alerts.map { |alert| AlertEntry.build(alert) }
      )
    end
  end
end
