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

    context "when the response code is 200 (OK)" do
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

    context "when the response code is 400 (Bad Request)" do
      let(:response) do
        double(
          status: 400,
          body: "\"Bad request\""
        )
      end

      it "returns a parsed JSON response body message" do
        expect {
          subject.retrieve(path)
        }.to raise_error(described_class::ApiError).
         with_message("{:message=>\"Bad request\", :status=>400}")
      end
    end

    context "when the response code is 403 (Forbidden)" do
      let(:response) do
        double(
          status: 403,
          body: "\"Forbidden\""
        )
      end

      it "returns a parsed JSON response body error message with status" do
        expect {
          subject.retrieve(path)
        }.to raise_error(described_class::ApiError).
         with_message("{:message=>\"Forbidden\", :status=>403}")
      end
    end

    context "when the response code is 404 (Not Found)" do
      let(:response) do
        double(
          status: 404,
          body: "\"Record not found\""
        )
      end

      it "returns a parsed JSON response body error message with status" do
        expect {
          subject.retrieve(path)
        }.to raise_error(described_class::RecordNotFoundError).
         with_message("{:message=>\"Record not found\", :status=>404}")
      end
    end

    context "when the response code is 500 (API Error)" do
      let(:response) do
        double(
          status: 500,
          body: "\"API error\""
        )
      end

      it "returns a parsed JSON response body error message with status" do
        expect {
          subject.retrieve(path)
        }.to raise_error(described_class::ApiError).
         with_message("{:message=>\"API error\", :status=>500}")
      end
    end

    context "when the response code is 504 (Timeout Error)" do
      let(:response) do
        double(
          status: 504,
          body: "\"Timeout Error\""
        )
      end

      it "returns a parsed JSON response body error message with status" do
        expect {
          subject.retrieve(path)
        }.to raise_error(described_class::TimeoutError).
         with_message("{:message=>\"Timeout Error\", :status=>504}")
      end
    end
  end
end
