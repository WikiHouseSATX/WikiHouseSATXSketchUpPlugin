class WikiHouse::WallPanelOuterSide

  include WikiHouse::PartHelper
  include WikiHouse::BoardPartHelper


  def initialize(parent_part: nil, sheet: nil, group: nil, origin: nil, label: label)
    part_init(origin: origin, sheet: sheet, label: label, parent_part: parent_part)

    @length_method = :length
    @width_method = :depth
    init_board(right_connector: WikiHouse::TabConnector.new(count: 2, thickness: @sheet.thickness),
               top_connector: WikiHouse::SlotConnector.new(count: 1, thickness: @sheet.thickness),
               bottom_connector: WikiHouse::SlotConnector.new(count: 1, thickness: @sheet.thickness),
               left_connector: WikiHouse::TabConnector.new(count: 2, thickness: @sheet.thickness),
               face_connector: [
                   WikiHouse::UPegPassThruConnector.new(thickness: @sheet.thickness, count: parent_part.number_of_internal_supports),
                   WikiHouse::UPegEndPassThruConnector.new(thickness: @sheet.thickness),
                   WikiHouse::PocketConnector.new(count: parent_part.number_of_internal_supports)]
    )

  end

end