# frozen_string_literal: true

module Api
  module V2
    class PropertiesController < ApplicationController
      def index
        @properties = PropertiesSearch.new(params).perform

        render json: @properties.to_json
      end

      def show
        @property = Property.for_reference(params[:id])

        render json: @property.to_json
      end
    end
  end
end
