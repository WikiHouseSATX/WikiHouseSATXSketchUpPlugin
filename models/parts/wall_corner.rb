require 'forwardable'
class WikiHouse::WallCorner < WikiHouse::Wall
  NORTH_FACE = 0
  EAST_FACE = 3
  SOUTH_FACE = 2
  WEST_FACE = 1
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
                   :origin, :origin=, :thickness, :drawn?
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

    def add_right_column(column_label: nil, face: nil)
      rcolumn = ColumnWithPanels.new(column_label: column_label,
                                     parent_part: parent_part)
      rcolumn.origin = origin
      rcolumn.set_panel(face: face, panel: self)
      @right_column = rcolumn
      @right_column_face = face
      @right_column
    end

    def add_left_column(column_label: nil, face: nil)
      lcolumn = ColumnWithPanels.new(column_label: column_label,
                                     parent_part: parent_part)
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
      end

      #draw the panel
      @wall_panel.draw!
      @groups.concat([@wall_panel.group])
      if left_column
        #Rotate the wall panel to line up
        if left_column_face == NORTH_FACE

          @wall_panel.rotate(vector: [0, 0, 1], rotation: 90.degrees).
              move_to(point: origin).
              move_by(z: -1 * thickness,
                      x: left_column.width,
                      y: left_column.width * -1).
              go!
        puts "I moved the wall panel"


        elsif left_column_face == WEST_FACE
          raise ScriptError, "no code"
        elsif left_column_face == SOUTH_FACE
          raise ScriptError, "no code"

        elsif left_column_face == EAST_FACE
          raise ScriptError, "no code"

        else
          raise ArgumentError, "Face can only be 0,1,2,3 not #{left_column_face}"
        end


      end
      #draw the right column
      wp_bounding_box = @wall_panel.bounds
      left_front_bottom = wp_bounding_box.corner(0)
      @wall_panel.origin = left_front_bottom

      if right_column
        unless right_column.drawn?
          #fix the origin

          if right_column_face == NORTH_FACE
            raise ScriptError, "no code"

          elsif right_column_face == WEST_FACE
            raise ScriptError, "no code"
          elsif right_column_face == SOUTH_FACE
            # right_column.column.move_to(point: origin).
            #     move_by(z: 0,
            #             x: 0,
            #             y: 100).
            #     go!
            right_column.origin = [Sk.round(left_front_bottom.x) + 20,
                                   left_front_bottom.y + 60,
                                   left_front_bottom.z]
            puts "Setting the origin to #{Sk.point_to_s(right_column.origin)}"
          elsif right_column_face == EAST_FACE
            raise ScriptError, "no code"
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
    def_delegators :@column, :parent_part, :sheet, :origin, :origin=,
                   :thickness, :drawn?, :width, :length

    def_delegators :parent_part, :face_label

    def initialize(column_label: nil, parent_part: nil)
      @column = WikiHouse::Column.new(label: column_label, origin: parent_part.origin,
                                      sheet: parent_part.sheet,
                                      wall_panels_on: [],
                                      parent_part: parent_part)

      @parent_part = parent_part
      @panels = {}
      @zpegs = {}
      @groups = []
    end


    def set_panel(face: nil, panel: nil)
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

          if key == 0
            zpeg = zpegs[key][col]
            zpeg.draw!


            zpeg.rotate(vector: [1, 0, 0], rotation: 90.degrees).
                rotate(vector: [0, 1, 0], rotation: 90.degrees).
                move_to(point: zpeg.origin).
                move_by(z: -1 * zpeg.thickness + column_board.width/2.0,
                        x: zpeg.width * 0.75,
                        y: -1 * location.y + Sk.abs(origin.y) - zpeg.length * 0.75).
                go!

          elsif key == 1
            zpeg = zpegs[key][parent_part.wall_panel_zpegs - col - 1]
            zpeg.draw!


            zpeg.rotate(vector: [1, 0, 0], rotation: 90.degrees).
                rotate(vector: [0, 0, 1], rotation: 180.degrees).
                rotate(vector: [0, 1, 0], rotation: 180.degrees).
                move_to(point: zpeg.origin).
                move_by(z: -1 * zpeg.thickness + column_board.width/2.0,
                        x: zpeg.width * -0.5 - thickness, #Left right
                        y: -1 * location.y + Sk.abs(column_board.origin.y) - thickness * 2 - column_board.length).
                go!
          elsif key == 2
            zpeg = zpegs[key][parent_part.wall_panel_zpegs - col - 1]
            zpeg.draw!


            zpeg.rotate(vector: [1, 0, 0], rotation: 90.degrees).
                rotate(vector: [0, 1, 0], rotation: -90.degrees).
                move_to(point: zpeg.origin).
                move_by(z: -1 * zpeg.thickness - column_board.width/2.0,
                        x: zpeg.width * -0.5 + thickness, #In/Out
                        y: -1 * location.y + Sk.abs(column_board.origin.y) - thickness * 3 - zpeg.width/2.0).
                go!

          elsif key == 3
            zpeg = zpegs[key][col]
            zpeg.draw!


            zpeg.rotate(vector: [1, 0, 0], rotation: 90.degrees).
                rotate(vector: [0, 0, 1], rotation: 0.degrees).
                move_to(point: zpeg.origin).
                move_by(z: -1 * zpeg.thickness - column_board.width/2.0,
                        x: zpeg.width * 0.75,
                        y: -1 * location.y + Sk.abs(origin.y) - zpeg.length * 0.75).
                go!
          else
            raise ScriptError, "Unsupported face"
          end

        end

      end
    end

    def build_zpegs(face: nil, peg_label: nil)
      @zpegs ||= {}
      [0, 1, 2, 3, 4].each { |f| @zpegs[f] ||= [] }
      parent_part.wall_panel_zpegs.times do |index|

        p_label = "#{peg_label} #{face_label(face)}-#{index + 1}"
        #puts "#{p_label}"
        @zpegs[face] << WikiHouse::DoubleZPeg.new(label: p_label,
                                                  origin: column.origin, sheet: column.sheet)

      end
      @zpegs
    end
  end

  def initialize(origin: nil, sheet: nil, label: nil)
    origin = [27, 100, 0]
    part_init(sheet: sheet, origin: origin)
    @column1 = WikiHouse::Column.new(label: "First", origin: origin,
                                    sheet: sheet,
                                    wall_panels_on: [],
                                    parent_part: self)
    @column2 = WikiHouse::Column.new(label: "Second", origin: origin,
                                    sheet: sheet,
                                    wall_panels_on: [],
                                    parent_part: self)

    @wall_panel1 = WikiHouse::WallPanel.new(label: "First", origin: origin,
                                           sheet: sheet, parent_part: self)
    @wall_panel2 = WikiHouse::WallPanel.new(label: "Second", origin: origin,
                                           sheet: sheet, parent_part: self)
   #DJE - the problem is that the origins of the sub parts dont' get updated.
    #need to confirm that when you update the origin after creation that the part gets drawn at the right place.

    @wall_panel1.draw!
    @wall_panel2.origin = [27, 80, 0]
    @wall_panel2.draw!
    # @root_column = ColumnWithPanels.new(column_label: "Middle",
    #                                     parent_part: self)
    #
    # panel = @root_column.add_panel(face: NORTH_FACE)
    # column = panel.add_right_column(column_label: "End",
    #                                 face: SOUTH_FACE
    # )

    # panel = @root_column.add_panel(face: 1)
    # column = panel.add_right_column(column_label: "End",
    #                                 face: 3,
    # )
    # panel = @root_column.add_panel(face: 2)
    # column = panel.add_right_column(column_label: "End",
    #                                 face: 3,
    # )
    # panel = @root_column.add_panel(face: 3)
    # column = panel.add_right_column(column_label: "End",
    #                                 face: 3,
    # )

    # @left_column = WikiHouse::Column.new(label: "Left", origin: @origin,
    #                                      sheet: @sheet,
    #                                      wall_panels_on: LEFT_COLUMN_BOARD_PEG_FACES, parent_part: self)
    # @left_wall_panel = WikiHouse::WallPanel.new(label: "Left Wall Panel",
    #                                             origin: [@origin.x + @left_column.width, @origin.y, @origin.z],
    #                                             sheet: @sheet, parent_part: self)
    # @middle_column = WikiHouse::Column.new(label: "Middle",
    #                                        origin: [@origin.x + @left_column.width + @left_wall_panel.width, @origin.y, @origin.z],
    #                                        sheet: @sheet,
    #                                        wall_panels_on: MIDDLE_COLUMN_BOARD_PEG_FACES, parent_part: self)
    # @right_wall_panel = WikiHouse::WallPanel.new(label: "Right Wall Panel",
    #                                              origin: [@origin.x + @left_column.width + @left_wall_panel.width + @middle_column.width, @origin.y, @origin.z],
    #                                              sheet: @sheet, parent_part: self)
    #
    # @right_column = WikiHouse::Column.new(label: "Right",
    #                                       origin: [@origin.x + @left_column.width + @left_wall_panel.width + @middle_column.width + @right_wall_panel.width,
    #                                                @origin.y, @origin.z],
    #                                       wall_panels_on: RIGHT_COLUMN_BOARD_PEG_FACES, sheet: @sheet, parent_part: self)
    # @left_column_zpegs = build_zpegs(faces: LEFT_COLUMN_BOARD_PEG_FACES, peg_label: "Left Column",
    #                                  column: @left_column)
    # @right_column_zpegs = build_zpegs(faces: RIGHT_COLUMN_BOARD_PEG_FACES, peg_label: "Right Column", column: @right_column)
    # @middle_column_zpegs = build_zpegs(faces: MIDDLE_COLUMN_BOARD_PEG_FACES, peg_label: "Middle Column",
    #                                    column: @middle_column)
    # add_column(wall_panels_on: [1], column_label: "Left")
    # add_column(wall_panels_on: [3], column_label: "Right")
    # add_wall_panel(column_1_index: 0, column_1_face: 1, column_2_index: 1, column_2_face: 3)

  end

# def add_column(wall_panels_on: [], column_label: nil)
#   clabel
#   @columns_with_panels << ColumnWithPanels.new(column_label: column_label,
#                                                wall_panels_on: wall_panels_on,
#                                                parent_part: self)
# end
#
# def add_wall_panel(column_1_index:nil, column_1_face:nil, column_2_index:nil, column_2_face:nil)
#   @panel_count += 1
#   panel = WikiHouse::WallPanel.new(label: "Wall Panel ##{@panel_count}",
#                                    origin: origin,
#                                    sheet: @sheet, parent_part: self)
#
#   @columns_with_panels[column_1_index].set_panel(face: column_1_face, panel: panel)
#   @columns_with_panels[column_2_index].set_panel(face: column_2_face, panel: panel)
# end
  def face_label(face_value)
    return "North" if face_value == NORTH_FACE
    return "East" if face_value == EAST_FACE
    return "South" if face_value == SOUTH_FACE
    return "West" if face_value == WEST_FACE
    "Unknown"
  end

  def draw!
    Sk.find_or_create_layer(name: self.class.name)
    Sk.make_layer_active_name(name: self.class.name)

  #   @root_column.draw!
  #   set_group(@root_column.groups.compact.uniq)
   end
end