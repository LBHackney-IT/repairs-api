# frozen_string_literal: true

require "rails_helper"

RSpec.describe HierarchyType do
  describe ".build" do
    it "builds a new hierarchy type with supplied attributes" do
      hierarchy_type = described_class.build(
        "levelCode" => "7",
        "subtypCode" => "DWE"
      )

      expect(hierarchy_type.levelCode).to eq "7"
      expect(hierarchy_type.subTypeCode).to eq "DWE"
    end
  end
end
