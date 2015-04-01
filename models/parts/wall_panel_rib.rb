class WikiHouse::WallPanelRib

  include WikiHouse::PartHelper
  include WikiHouse::BoardPartHelper

  def initialize(panel: nil, sheet: nil, group: nil, origin: nil, label: label)
    part_init(origin: origin, sheet: sheet, label: label)
    @panel = panel ? panel : raise(ArgumentError, "You must provide a WallPanel")
    @length_method = :panel_rib_width
    @width_method = :panel_depth
    init_board(right_connector:  WikiHouse::TabConnector.new(count: 2, width: @sheet.thickness),
               top_connector:  WikiHouse::TabConnector.new(count: 1, width: @sheet.thickness),
               bottom_connector:  WikiHouse::TabConnector.new(count: 1, width: @sheet.thickness),
               left_connector:  WikiHouse::TabConnector.new(count: 2, width: @sheet.thickness))

  end


  def parent_part
    @panel
  end


end