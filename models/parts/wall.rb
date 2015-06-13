require 'forwardable'
class WikiHouse::Wall
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

  class ColumnWallPanel

    attr_accessor :left_column, :right_column, :parent_part,
                  :groups, :left_column_face, :right_column_face

    extend Forwardable
    def_delegators :@wall_panel, :parent_part, :sheet,
                   :origin, :origin=, :thickness, :drawn?, :bounds, :label
    def_delegators :parent_part, :face_label

    def initialize(label: nil, origin: nil, sheet: nil, parent_part: nil)
      @wall_panel = WikiHouse::WallPanel.new(label: label, origin: origin,
                                             sheet: sheet, parent_part: parent_part)
      @left_column = @right_column = @left_column_face = @right_column_face = nil
      @parent_part = parent_part
      @groups = []
    end

    def origin
      @wall_panel.origin
    end

    def sheet
      @wall_panel.sheet
    end

    def add_right_column(column_label: nil, face: nil, rcolumn: nil)
      unless rcolumn
        rcolumn = ColumnWithPanels.new(column_label: column_label,
                                       parent_part: parent_part)
        rcolumn.origin = origin
      end


      rcolumn.set_panel(face: face, panel: self)
      @right_column = rcolumn
      @right_column_face = face
      @right_column
    end

    def add_left_column(column_label: nil, face: nil, lcolumn: nil)
      unless lcolumn
        lcolumn = ColumnWithPanels.new(column_label: column_label,
                                       parent_part: parent_part)
      end
      lcolumn.origin = origin
      lcolumn.set_panel(face: face, panel: self)
      @left_column = lcolumn
      @left_column_face = face
      @left_column
    end

    def draw!

      #Draw left column
      @groups = []
      if left_column
        left_column.draw! unless left_column.drawn?
        @groups.concat(left_column.groups)
        @wall_panel.origin = left_column.origin
      end

      #draw the panel
      @wall_panel.draw!
      @groups.concat([@wall_panel.group])
      if left_column
        #Rotate the wall panel to line up
        if left_column_face == Sk::SOUTH_FACE

          @wall_panel.rotate(vector: [0, 0, 1], rotation: 90.degrees).
              move_to(point: origin).
              move_by(z: -1 * thickness,
                      x: left_column.width,
                      y: left_column.width * -1).
              go!


        elsif left_column_face == Sk::EAST_FACE
          @wall_panel.rotate(vector: [0, 0, 1], rotation: 180.degrees).
              move_to(point: origin).
              move_by(z: -1 * thickness,
                      x: (@wall_panel.length) * 0,
                      y: left_column.width * -1).
              go!
        elsif left_column_face == Sk::NORTH_FACE


          @wall_panel.rotate(vector: [0, 0, 1], rotation: 270.degrees).
              move_to(point: origin).
              move_by(z: -1 * thickness,
                      x: (@wall_panel.length) * 0,
                      y: left_column.width * 0).
              go!

        elsif left_column_face == Sk::WEST_FACE
          @wall_panel.
              move_to(point: origin).
              move_by(z: -1 * thickness,
                      x: left_column.width,
                      y: left_column.width * 0).
              go!

        else
          raise ArgumentError, "Face can only be 0,1,2,3 not #{left_column_face}"
        end


      end
      #draw the right column
      wp_bounding_box = @wall_panel.bounds


      if right_column
        unless right_column.drawn?


          if right_column_face == Sk::SOUTH_FACE
            left_front_bottom = wp_bounding_box.corner(0)
            @wall_panel.origin = [left_front_bottom.x + right_column.width,
                                  left_front_bottom.y,
                                  left_front_bottom.z]
            right_column.origin = [Sk.round(@wall_panel.origin.x) - right_column.width,
                                   @wall_panel.origin.y - 0 * @wall_panel.thickness - right_column.width,
                                   @wall_panel.origin.z + 1 * @wall_panel.thickness]


          elsif right_column_face == Sk::EAST_FACE
            right_front_bottom = wp_bounding_box.corner(1)

            @wall_panel.origin = right_front_bottom
            right_column.origin = [Sk.round(@wall_panel.origin.x),
                                   @wall_panel.origin.y - 0 * @wall_panel.thickness,
                                   @wall_panel.origin.z + 1 * @wall_panel.thickness]
          elsif right_column_face == Sk::NORTH_FACE
            left_back_bottom = wp_bounding_box.corner(2)
            @wall_panel.origin = left_back_bottom

            right_column.origin = [Sk.round(@wall_panel.origin.x),
                                   @wall_panel.origin.y,
                                   @wall_panel.origin.z + 1 * @wall_panel.thickness]

          elsif right_column_face == Sk::WEST_FACE
            left_front_bottom = wp_bounding_box.corner(0)

            @wall_panel.origin = left_front_bottom
            right_column.origin = [Sk.round(@wall_panel.origin.x) - right_column.width,
                                   @wall_panel.origin.y + 0 * @wall_panel.thickness,
                                   @wall_panel.origin.z + 1 * @wall_panel.thickness]
          else
            raise ArgumentError, "Face can only be 0,1,2,3 not #{right_column_face}"
          end


          right_column.draw!

        end

        @groups.concat(right_column.groups)
      end
      @groups
    end
  end
  class ColumnWithPanels
    attr_accessor :column, :zpegs, :panels, :groups
    extend Forwardable
    def_delegators :@column, :parent_part, :sheet, :origin,
                   :thickness, :drawn?, :width, :length, :bounds, :label, :mark_wall_panel_on!

    def_delegators :parent_part, :face_label

    def initialize(column_label: nil, parent_part: nil)
      @column = WikiHouse::Column.new(label: column_label, origin: parent_part.origin,
                                      sheet: parent_part.sheet,
                                      wall_panels_on: [],
                                      parent_part: parent_part)

      @drawing = false
      @parent_part = parent_part
      @panels = {}
      @zpegs = {}
      @groups = []
    end

    def origin=(new_origin)
      @column.origin = new_origin

      zpegs.each do |key, value|
        next if value == []

        value.each do  |zp|
          zp.origin = new_origin

        end
      end
    end

    def set_panel(face: nil, panel: nil)
      raise ArgumentError, "Sorry #{face} is already in use" unless @panels[face].nil?
      @panels[face] = panel
      @column.mark_wall_panel_on!(face)
      build_zpegs(face: face, peg_label: @column.label)

    end

    def add_panel(face: nil, panel: nil)
      if panel.nil?
        panel = ColumnWallPanel.new(label: "Panel on #{face_label(face)}",
                                    origin: origin,
                                    sheet: sheet,
                                    parent_part: parent_part)
      end
      set_panel(face: face, panel: panel)
      panel.left_column = self
      panel.left_column_face = face
      panel
    end

    def draw!
      return if @drawing
      @drawing = true
      @groups = []
      unless @column.drawn?

        @column.draw!
        @groups.concat([@column.group])
        draw_zpegs!
        zpegs.keys.each do |k|
          @groups.concat(zpegs[k].collect { |v| v.group })
        end
      end
      @panels.each do |key, panel|
        unless panel.drawn?

          panel.draw!
        end

        @groups.concat(panel.groups)
      end
      @groups
    end

    def build_zpegs(face: nil, peg_label: nil)
      @zpegs ||= {}
      [0, 1, 2, 3, 4].each { |f| @zpegs[f] ||= [] }
      parent_part.wall_panel_zpegs.times do |index|

        p_label = "#{peg_label} #{face_label(face)}-#{index + 1}"

        @zpegs[face] << WikiHouse::DoubleZPeg.new(label: p_label,
                                                  origin: column.origin,
                                                  sheet: column.sheet)

      end
      @zpegs
    end

    private
    def draw_zpegs!
      zpegs.each do |key, value|
        next if value == []

        column_board = column.column_board(key)
        connector = column_board.face_connector
        connector.class.drawing_points(bounding_origin: column.origin,
                                       count: parent_part.wall_panel_zpegs,
                                       rows: 1,
                                       part_length: column_board.length,
                                       part_width: column_board.width,
                                       item_length: connector.top_slot_length,
                                       item_width: connector.top_slot_width) do |row, col, location|

          if key == Sk::SOUTH_FACE
            zpeg = zpegs[Sk::SOUTH_FACE][col]
            zpeg.draw!


            zpeg.rotate(vector: [1, 0, 0], rotation: 90.degrees).
                rotate(vector: [0, 1, 0], rotation: 90.degrees).
                move_to(point: zpeg.origin).
                move_by(z: -1 * zpeg.thickness + column_board.width/2.0,
                        x: column_board.width - zpeg.length + 7 * zpeg.thickness,
                        y: -1 * location.y + origin.y - zpeg.thickness * 9).
                go!

          elsif key == Sk::EAST_FACE
            zpeg = zpegs[Sk::EAST_FACE][parent_part.wall_panel_zpegs - col - 1]
            zpeg.draw!


            zpeg.rotate(vector: [1, 0, 0], rotation: 90.degrees).
                #  rotate(vector: [0, 0, 1], rotation: 180.degrees).
                rotate(vector: [0, 1, 0], rotation: 180.degrees).
                move_to(point: zpeg.origin).
                move_by(z: -1 * zpeg.thickness + column_board.width/2.0,
                        x: zpeg.thickness * -5, #Left right
                        y: -1 * location.y + column_board.origin.y - zpeg.thickness * 9).
                go!
          elsif key == Sk::NORTH_FACE
            zpeg = zpegs[Sk::NORTH_FACE][parent_part.wall_panel_zpegs - col - 1]
            zpeg.draw!


            zpeg.rotate(vector: [1, 0, 0], rotation: 90.degrees).
                rotate(vector: [0, 1, 0], rotation: -90.degrees).
                move_to(point: zpeg.origin).
                move_by(z: -1 * zpeg.thickness - column_board.width/2.0,
                        x: zpeg.thickness * -5, #In/Out
                        y: -1 * location.y + column_board.origin.y - zpeg.thickness * 9).
                go!

          elsif key == Sk::WEST_FACE

            zpeg = zpegs[Sk::WEST_FACE][parent_part.wall_panel_zpegs - col - 1]
            zpeg.draw!

            zpeg.rotate(vector: [1, 0, 0], rotation: 90.degrees).
                 rotate(vector: [0, 0, 1], rotation: 0.degrees).
                 move_to(point: column.origin).
                 move_by(z: -1 * zpeg.thickness - column_board.width/2.0,
                         x:   column_board.width - zpeg.length + 7 * zpeg.thickness , #Left right
                         y:  -1 * location.y + origin.y - zpeg.thickness * 9).

                go!
          else
            raise ScriptError, "Unsupported face"
          end

        end

      end
    end


  end

  def initialize(origin: nil, sheet: nil, label: nil)

    #Can't complete loop
    #loooks like one side of the panels is off
    @root_column = ColumnWithPanels.new(column_label: "C1",
                                        parent_part: self)


    panel = @root_column.add_panel(face: Sk::NORTH_FACE)
    column2 = panel.add_right_column(column_label: "C1-C2",
                                     face: Sk::SOUTH_FACE
    )
    # panel2 = column2.add_panel(face: Sk::EAST_FACE)
    # column3 = panel2.add_right_column(column_label: "C2", face: Sk::WEST_FACE)
    # panel3 = column3.add_panel(face: Sk::SOUTH_FACE)
    #  column4 = panel3.add_right_column(column_label: "C3", face: Sk::NORTH_FACE)
    #  panel4 = column4.add_panel(face: Sk::WEST_FACE)
    #  column5 = panel4.add_right_column(column_label: "C3-C4", face: Sk::EAST_FACE)
    #  panel5 = column5.add_panel(face: Sk::WEST_FACE)
    # column6 = panel5.add_right_column(column_label: "C4", face: Sk::EAST_FACE)
    # panel6 = column6.add_panel(face: Sk::NORTH_FACE)
    # panel6.add_right_column(rcolumn:@root_column, face: Sk::SOUTH_FACE)
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


  def face_label(face_value)
    return "North" if face_value == Sk::NORTH_FACE
    return "East" if face_value == Sk::EAST_FACE
    return "South" if face_value == Sk::SOUTH_FACE
    return "West" if face_value == Sk::WEST_FACE
    "Unknown"
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