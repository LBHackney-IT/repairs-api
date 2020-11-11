# frozen_string_literal: true

class Request
  def initialize(connection)
    @connection = connection
  end

  def retrieve(path)
    response, status = get_json(path)
    status == 200 ? response : errors(response)
  end

private
  attr_reader :connection

  def errors(response)
    { message: response["message"] }
  end

  def get_json(path)
    response = connection.get(path)
    [JSON.parse(response.body), response.status]
  end
end
