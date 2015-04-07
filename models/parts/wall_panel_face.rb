class WikiHouse::WallPanelFace

  include WikiHouse::PartHelper
  include WikiHouse::BoardPartHelper

  def initialize(parent_part: nil, sheet: nil, group: nil, origin: nil, label: label)
    part_init(origin: origin, sheet: sheet, label: label, parent_part: parent_part)
     @length_method = :length
    @width_method = :panel_rib_width
    init_board(right_connector: WikiHouse::NoneConnector.new(),
               top_connector: WikiHouse::NoneConnector.new(),
               bottom_connector: WikiHouse::NoneConnector.new(),
               left_connector: WikiHouse::NoneConnector.new(),
               face_connector: WikiHouse::PocketConnector.new(count: 3, rows: 2))

  end

end