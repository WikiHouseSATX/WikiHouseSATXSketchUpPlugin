class WikiHouse::WallPanelOuterSide

  include WikiHouse::PartHelper
  include WikiHouse::BoardPartHelper


  def initialize(parent_part: nil, sheet: nil, group: nil, origin: nil, label: label)
    part_init(origin: origin, sheet: sheet, label: label, parent_part: parent_part)

    @length_method = :length
    @width_method = :depth
    init_board(right_connector: WikiHouse::RipConnector.new( thickness: @sheet.thickness),
               top_connector: WikiHouse::SlotConnector.new(count: 1, thickness: @sheet.thickness),
               bottom_connector: WikiHouse::SlotConnector.new(count: 1, thickness: @sheet.thickness),
               left_connector: WikiHouse::RipConnector.new( thickness: @sheet.thickness),
               face_connector: WikiHouse::TPocketConnector.new(count: 3))

  end

 end