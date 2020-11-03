# frozen_string_literal: true

module Api
  module V1
    class PropertiesController < ApplicationController
      def index
        if params[:postcode]
          @properties = Property.for_postcode(params[:postcode])
        else
          @properties = Property.for_address(params[:address])
        end

        render json: @properties.to_json
      end
    end
  end
end
