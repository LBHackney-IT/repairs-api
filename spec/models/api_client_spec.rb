# frozen_string_literal: true

require "rails_helper"

RSpec.describe ApiClient, type: :model do
  subject { described_class.create }

  it "generates a new client secret" do
    expect(subject.client_secret).not_to be_empty
    expect(subject.client_id).not_to be_empty
  end

  context "when the api_client exists" do
    before do
      create(:api_client)
    end

    it "raises an error" do
      api_client = build(:api_client)

      expect { api_client.save }.to raise_error(ActiveRecord::RecordNotUnique)
    end
  end
end
