require 'forwardable'
class WikiHouse::WallBuilder
  include WikiHouse::PartHelper

#  0
# 1  3
#  2

# X--WP--X
#   X--WP--X--WP
#   X--WP--X
#          |
#          WP
#          |
#          X
#
#           X
#           |
#           WP
#           |
#      X-WP-X-WP-X
#           |
#           WP
#           |
#           X
# X--WP--X
# |      |
# WP     WP
# |      |
# X--WP--X



  def initialize(origin: nil, sheet: nil, label: nil)

    @root_part = WikiHouse::Column.new(label: "Column 1", parent_part: self)
    wp = WikiHouse::WallPanel.new(label: "WP 1", parent_part: self)
    @root_part.join(part: wp, on_my_face: WikiHouse::Orientation.south, to: WikiHouse::Orientation.west)

    wp2 = WikiHouse::WallPanel.new(label: "WP 2", parent_part: self)
    wp.join(part: wp2, on_my_face: WikiHouse::Orientation.east, to: WikiHouse::Orientation.west)
    #Can't complete loop
    # #loooks like one side of the panels is off
    # @root_column = ColumnWithPanels.new(column_label: "C1",
    #                                     parent_part: self)
    #
    #
    # panel = @root_column.add_panel(face: WikiHouse::Orientation.north)
    # column2 = panel.add_right_column(column_label: "C1-C2",
    #                                  face: WikiHouse::Orientation.south
    # )
    # panel2 = column2.add_panel(face: WikiHouse::Orientation.east)
    # column3 = panel2.add_right_column(column_label: "C2", face: WikiHouse::Orientation.west)
    # panel3 = column3.add_panel(face: WikiHouse::Orientation.south)
    #  column4 = panel3.add_right_column(column_label: "C3", face: WikiHouse::Orientation.north)
    #  panel4 = column4.add_panel(face: WikiHouse::Orientation.west)
    #  column5 = panel4.add_right_column(column_label: "C3-C4", face: WikiHouse::Orientation.east)
    #  panel5 = column5.add_panel(face: WikiHouse::Orientation.west)
    # column6 = panel5.add_right_column(column_label: "C4", face: WikiHouse::Orientation.east)
    # panel6 = column6.add_panel(face: WikiHouse::Orientation.north)
    # panel6.add_right_column(rcolumn:@root_column, face: WikiHouse::Orientation.south)
  end

  def wall_height
    value = 94
    if sheet.length == 24
      value/4.0
    else
      value
    end

  end

  def wall_panel_upegs
    3
  end




  def draw!
    Sk.find_or_create_layer(name: self.class.name)
    Sk.make_layer_active_name(name: self.class.name)

    #Sk.start_operation("Draw a wall", disable_ui: true)

    @root_column.draw!
    # Sk.commit_operation
    set_group(@root_column.groups.compact.uniq)
  end


end