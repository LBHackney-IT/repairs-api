# frozen_string_literal: true

class HierarchyType
  include ActiveModel::Model

  attr_accessor :levelCode, :subTypeCode, :subTypeDescription

  HIERARCHY = {
    ADM: "Administrative Building",
    BLK: "Block",
    BLR: "Boiler House",
    BOO: "Booster Pump",
    CHP: "Combined Heat and Power Unit.",
    CLF: "Cleaners Facilities",
    CMH: "Community Hall",
    CON: "Concierge",
    DWE: "Dwelling",
    EST: "Estate",
    HIR: "High Rise Block (6 storeys or more)",
    LFT: "Lift",
    LND: "Lettable Non-Dwelling",
    LOR: "Low Rise Block (2 storeys or less)",
    MER: "Medium Rise Block (3-5 storeys)",
    PLA: "Playground",
    TER: "Terraced Block",
    TRA: "Traveller Site",
    WLK: "Walk-Up Block"
  }

  def self.build(attributes)
    new(
      levelCode: attributes["levelCode"],
      subTypeCode: attributes["subtypCode"],
      subTypeDescription: HIERARCHY[attributes["subtypCode"].to_sym]
    )
  end
end
