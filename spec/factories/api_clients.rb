# frozen_string_literal: true

FactoryBot.define do
  factory :api_client do
    client_id { 'foo' }
    client_secret { 'bar' }
  end
end
