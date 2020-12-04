# frozen_string_literal: true

module Api::ErrorHandler
  extend ActiveSupport::Concern
  include HttpStatusCodes

  included do
    rescue_from Request::RecordNotFoundError, with: :error_as_json
    rescue_from Request::TimeoutError, with: :error_as_json
    rescue_from Request::ApiError, with: :error_as_json

  private

    def error_as_json(error)
      error_hash = eval(error.message)

      render json: {
        errors: [
          {
            title: error_hash[:message]["title"] || error_hash[:message],
            status: error_hash[:status].to_s || API_ERROR.to_s
          }
        ]
      }, status: error_hash[:status].to_s || API_ERROR.to_s
    end
  end
end
