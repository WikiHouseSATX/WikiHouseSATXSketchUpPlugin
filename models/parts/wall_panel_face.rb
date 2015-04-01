class WikiHouse::WallPanelFace

  include WikiHouse::PartHelper
  include WikiHouse::BoardPartHelper

  def initialize(panel: nil, sheet: nil, group: nil, origin: nil, label: label)
    part_init(origin: origin, sheet: sheet, label: label)
    @panel = panel ? panel : raise(ArgumentError, "You must provide a WallPanel")

    @length_method = :panel_height
    @width_method = :panel_rib_width
    init_board(right_connector: WikiHouse::NoneConnector.new(),
               top_connector: WikiHouse::NoneConnector.new(),
               bottom_connector: WikiHouse::NoneConnector.new(),
               left_connector: WikiHouse::NoneConnector.new(),
               face_connector: WikiHouse::PocketConnector.new(count: 3, rows: 2))

  end

  def parent_part
    @panel
  end
end