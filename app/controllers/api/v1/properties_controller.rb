# frozen_string_literal: true

module Api
  module V1
    class PropertiesController < ApplicationController
      def index
        @properties = Property.for_postcode(params[:postcode])

        render json: @properties.to_json
      end
    end
  end
end
