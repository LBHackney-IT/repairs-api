# frozen_string_literal: true

module RequestConnection
private

  def request
    @request ||= Request.new(connection)
  end

  def connection
    Connection.api(
      url:
        Rails.application.credentials.platform_apis[api_type][:url],
      token:
        Rails.application.credentials.platform_apis[api_type][:token]
    )
  end
end
