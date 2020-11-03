# frozen_string_literal: true

module Api
  module V1
    class PropertiesController < ApplicationController
      def index
        @properties = PropertiesSearch.new(params).perform

        render json: @properties.to_json
      end
    end
  end
end
