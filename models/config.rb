require 'ostruct'
class WikiHouse::Config
  def self.machine
   #WikiHouse::Laser
    WikiHouse::Cnc
  end
  def self.sheet
  #  WikiHouse::ImperialPlywood2332Sheet
   WikiHouse::ImperialPlywood34Sheet
  #WikiHouse::ImperialFiberboardSheet
  end
  def self.current_part
    parent_part = OpenStruct.new
    parent_part.length = 92
    parent_part.width = 92/2.0
    parent_part.width = 10
    parent_part.depth = 10
    parent_part.wall_panel_upegs = 3
    parent_part.number_of_internal_supports = 3
    parent_part.panel_rib_width = parent_part.width
    parent_part.side_column_length = 10
    parent_part.side_column_width = 13
    parent_part.top_column_length = 11.25
  #  WikiHouse::WallPanelFace.new(label: "Top", origin: [0,0,0],  parent_part: parent_part)
   # WikiHouse::HalfWallPanel.new()
     # WikiHouse::WallColumnBoard.new(label: "Column Board",
    #                                  parent_part: parent_part, origin:[0,0,0])
   #  WikiHouse::Column.new(label: " Column",
   #                                       wall_panels_on: [Sk::NORTH_FACE,Sk::EAST_FACE])

   # WikiHouse::WallColumnRib.new(label: " Column",parent_part: parent_part,
   #                                       wall_panels_on: [Sk::WEST_FACE,Sk::SOUTH_FACE])
    #WikiHouse::DoorPanelRib.new(label: " Column", parent_part:parent_part)
    #WikiHouse::DoorPanelTopRib.new(label: " Column", parent_part:parent_part)
    WikiHouse::DoorPanelOuterSide.new(label: " Column", parent_part:parent_part)

  end
end