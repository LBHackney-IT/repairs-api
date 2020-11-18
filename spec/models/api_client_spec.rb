# frozen_string_literal: true

require "rails_helper"

RSpec.describe ApiClient, type: :model do
  subject { described_class.create }

  context "#validations" do
    it "cannot create an api_client without a client_id set" do
      expect(subject.errors.messages[:client_id][0]).to eq("can't be blank")
    end

    it "cannot create an api_client without a client_secret set" do
      expect(subject.errors.messages[:client_secret][0]).to eq("can't be blank")
    end

    it "must have a unique client_id and client_secret" do
      create(:api_client)
      api_client = build(:api_client)
      api_client.save

      expect(api_client.errors.messages[:client_id][0]).to eq("has already been taken")
      expect(api_client.errors.messages[:client_secret][0]).to eq("has already been taken")
    end
  end
end
