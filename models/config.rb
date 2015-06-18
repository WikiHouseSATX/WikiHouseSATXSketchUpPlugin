require 'ostruct'
class WikiHouse::Config
  def self.machine
#  WikiHouse::Laser
    WikiHouse::Cnc
  end

  def self.sheet
    #  WikiHouse::ImperialPlywood2332Sheet
    WikiHouse::ImperialPlywood34Sheet
    # WikiHouse::ImperialFiberboardSheet
  end

  def self.current_part

    Sk.erase_all!

    parent_part = OpenStruct.new
    parent_part.length = 92
    parent_part.width = 92/2.0
    parent_part.width = 60
    parent_part.depth = 10
    parent_part.wall_panel_upegs = 3
    parent_part.door_frame_width = 34
    parent_part.number_of_internal_supports = 3
    parent_part.panel_rib_width = parent_part.width
    parent_part.side_column_length = 10
    parent_part.side_column_width = 13
    parent_part.top_column_length = 11.25
    parent_part.side_column_inner_length = 82 + 0.75
    parent_part.side_column_depth = 10
    parent_part.number_of_side_column_supports = 3
    parent_part.top_column_length = 94 - 82 - 0.75
    parent_part.number_of_top_column_supports = 3
    #  WikiHouse::WallPanelFace.new(label: "Top", origin: [0,0,0],  parent_part: parent_part)
    # WikiHouse::HalfWallPanel.new()
      p = WikiHouse::UPeg.new(label: "UPeg - 4", right_inner_leg_in_t: 4)
      p.draw!
       p.move_by(z:6).go!
     p =  WikiHouse::UPeg.new(label: "UPeg - 3", right_inner_leg_in_t: 3)
    
     p.draw!
    
      p.move_by(z:5).go!
    
     # w = WikiHouse::Wedge.new( label: "Wedge",  width_in_t: 10, right_length_in_t:5, left_length_in_t:4)
     #  w.draw!
     #  w.move_by(z: 5).go!
    p =  WikiHouse::UPeg.new(label: "UPeg - 2", right_inner_leg_in_t:2 )
      p.draw!
    #
       p.move_by(z:4).go!
      p =  WikiHouse::UPeg.new(label: "UPeg - 1",right_inner_leg_in_t: 1)
      p.draw!
    
      p.move_by(z:3).go!
     p =  WikiHouse::UPeg.new(label: "UPeg - 0", right_inner_leg_in_t: 0)
     p.draw!
    
      p.move_by(z:2).go!
       WikiHouse::UPeg.new(label: "UPeg")
    #   WikiHouse::WallPanel.new(label: "Wall Panel")
    # WikiHouse::WallColumnBoard.new(label: "Column Board",
    #                                  parent_part: parent_part, origin:[0,0,0])
    #  WikiHouse::Column.new(label: " Column",
    #                                       wall_panels_on: [Sk::NORTH_FACE,Sk::EAST_FACE])

    # WikiHouse::WallColumnRib.new(label: " Column",parent_part: parent_part,
    #                                       wall_panels_on: [Sk::WEST_FACE,Sk::SOUTH_FACE])
    #WikiHouse::DoorPanelRib.new(label: " Column", parent_part:parent_part)
    # WikiHouse::DoorPanelInnerSide.new(label: " Column", parent_part:parent_part)
    #WikiHouse::DoorPanelTopRib.new(label: " Column", parent_part:parent_part)
    #  WikiHouse::DoorPanelOuterSide.new(label: " Column", parent_part:parent_part)
    # WikiHouse::DoorPanelBottomHeader.new(label: "inner", parent_part: parent_part)
    #WikiHouse::DoorPanelTopHeader.new(label: "inner", parent_part: parent_part)
    #  WikiHouse::DoorPanelTopCap.new(label: "inner", parent_part: parent_part)
    #WikiHouse::DoorPanelTopFace.new(label: "inner", parent_part: parent_part)
    #WikiHouse::DoorPanelSideFace.new(label: "inner", parent_part: parent_part)
    # WikiHouse::DoorPanel.new(label: "Door Panel")
    #  WikiHouse::DoorWallPanel.new(label: "Door Wall Panel")
    #  WikiHouse::Column.new(label: "Column", wall_panels_on: [Sk::NORTH_FACE, Sk::SOUTH_FACE, Sk::WEST_FACE, Sk::EAST_FACE])
  end
end