class WikiHouse::WallPanelCap

  include WikiHouse::PartHelper
  include WikiHouse::BoardPartHelper

  def initialize(panel: nil, sheet: nil, group: nil, origin: nil, label: label)
    part_init(origin: origin, sheet: sheet, label: label)
    @panel = panel ? panel : raise(ArgumentError, "You must provide a WallPanel")

    @length_method = :panel_width
    @width_method = :panel_depth
    init_board(right_connector: WikiHouse::RipConnector.new(thickness: @sheet.thickness),
               top_connector: WikiHouse::TabConnector.new(count: 1, thickness: @sheet.thickness),
               bottom_connector: WikiHouse::TabConnector.new(count: 1, thickness: @sheet.thickness),
               left_connector: WikiHouse::RipConnector.new(thickness: @sheet.thickness),
               face_connector: WikiHouse::PocketConnector.new(count: 1, thickness: thickness, width_in_t: 2))

  end

  def parent_part
    @panel
  end
end