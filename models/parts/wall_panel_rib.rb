class WikiHouse::WallPanelRib

  include WikiHouse::PartHelper
  include WikiHouse::BoardPartHelper

  def initialize(panel: nil, sheet: nil, group: nil, origin: nil, label: label)
    part_init(origin: origin, sheet: sheet, label: label)
    @panel = panel ? panel : raise(ArgumentError, "You must provide a WallPanel")
    @length_method = :panel_depth
    @width_method = :panel_rib_width
    init_board(right_connector:  WikiHouse::NoneConnector.new(count: 2),
               top_connector:  WikiHouse::SlotConnector.new(count: 2),
               bottom_connector:  WikiHouse::SlotConnector.new(count: 2),
               left_connector:  WikiHouse::NoneConnector.new(count: 2))

  end


  def parent_part
    @panel
  end




end