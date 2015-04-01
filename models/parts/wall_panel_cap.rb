class WikiHouse::WallPanelCap

  include WikiHouse::PartHelper
  include WikiHouse::BoardPartHelper

  def initialize(panel: nil, sheet: nil, group: nil, origin: nil, label: label)
    part_init(origin: origin, sheet: sheet, label: label)
    @panel = panel ? panel : raise(ArgumentError, "You must provide a WallPanel")

    @length_method = :panel_width
    @width_method = :panel_depth
    init_board(right_connector: WikiHouse::NoneConnector.new(),
               top_connector: WikiHouse::TabConnector.new(count: 1),
               bottom_connector: WikiHouse::TabConnector.new(count: 1),
               left_connector: WikiHouse::NoneConnector.new(),
               face_connector: WikiHouse::PocketConnector.new(count: 1, size: 2.0 * WikiHouse::PocketConnector.standard_size))

  end

  def parent_part
    @panel
  end
end