# frozen_string_literal: true

module Api
  module V2
    class CautionaryAlertsController < ApplicationController
      def index
        @property = CautionaryAlert.for_property_reference(params[:property_id])

        render json: @property.to_json
      end
    end
  end
end
