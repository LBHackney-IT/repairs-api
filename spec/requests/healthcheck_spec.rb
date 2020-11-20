# frozen_string_literal: true

require "rails_helper"

RSpec.describe "healthcheck" do
  before do
    get("/healthcheck")
  end

  it "returns a status 200" do
    expect(response.status).to eq(200)
  end

  it "returns a body OK" do
    expect(response.body).to eq("OK")
  end
end
