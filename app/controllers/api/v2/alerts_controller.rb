# frozen_string_literal: true

module Api
  module V2
    class AlertsController < ApplicationController
      def index
        @alerts = Alert.for_property_reference(params[:property_id])

        render json: @alerts.to_json
      end
    end
  end
end
