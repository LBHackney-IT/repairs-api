# frozen_string_literal: true

class Request
  include HttpStatusCodes

  class PlatformApiError < StandardError; end
  class RecordNotFoundError < PlatformApiError; end
  class TimeoutError < PlatformApiError; end
  class UnauthorizedError < PlatformApiError; end
  class ApiError < PlatformApiError; end

  def initialize(connection)
    @connection = connection
  end

  def retrieve(path)
    response, status = get_json(path)

    case status
    when OK, NO_CONTENT
      response
    when NOT_FOUND
      raise RecordNotFoundError, errors(response, status)
    when UNAUTHORIZED
      raise UnauthorizedError, errors(response, status)
    when TIMEOUT_ERROR
      raise TimeoutError, errors(response, status)
    else
      raise ApiError, errors(response, status)
    end
  end

private
  attr_reader :connection

  def errors(response, status)
    { message: response, status: status }
  end

  def get_json(path)
    response = connection.get(path)
    [JSON.parse(response.body), response.status]
  end
end
