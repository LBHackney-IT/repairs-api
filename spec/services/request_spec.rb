# frozen_string_literal: true

require "rails_helper"

RSpec.describe Request do
  describe "#retrieve" do
    let(:path) { "/properties" }
    let(:connection) { double }

    before do
      expect(connection).to receive(:get).with(path).and_return(response)
    end

    subject { described_class.new(connection) }

    context "when the response code is 200" do
      let(:response) do
        double(
          status: 200,
          body: "[]"
        )
      end

      it "returns a parsed JSON response body" do
        expect(subject.retrieve(path)).to eq []
      end
    end

    context "when the response code is not 200" do
      let(:response) do
        double(
          status: 400,
          body: "{\"message\":\"Forbidden\"}"
        )
      end

      it "returns a parsed JSON response body message" do
        expect(subject.retrieve(path)).to eq(
          { message: "Forbidden" }
        )
      end
    end
  end
end
