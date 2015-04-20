class WikiHouse::WallCorner

  include WikiHouse::PartHelper
  LEFT_COLUMN_BOARD_PEG_FACES = [3]
  MIDDLE_COLUMN_BOARD_PEG_FACES = [1,3]
  RIGHT_COLUMN_BOARD_PEG_FACES = [1]

  def initialize(origin: nil, sheet: nil, label: nil)
    origin = [27, 100, 0]
    part_init(sheet: sheet, origin: origin)

    @left_column = WikiHouse::Column.new(label: "Left", origin: @origin,
                                         sheet: @sheet,
                                         wall_panels_on: LEFT_COLUMN_BOARD_PEG_FACES, parent_part: self)
    @left_wall_panel = WikiHouse::WallPanel.new(label: "Left Wall Panel",
                                                origin: [@origin.x + @left_column.width, @origin.y, @origin.z],
                                                sheet: @sheet, parent_part: self)
    @middle_column = WikiHouse::Column.new(label: "Middle",
                                           origin: [@origin.x + @left_column.width + @left_wall_panel.width, @origin.y, @origin.z],
                                           sheet: @sheet,
                                           wall_panels_on: MIDDLE_COLUMN_BOARD_PEG_FACES, parent_part: self)
    @right_wall_panel = WikiHouse::WallPanel.new(label: "Right Wall Panel",
                                                 origin: [@origin.x + @left_column.width + @left_wall_panel.width + @middle_column.width, @origin.y, @origin.z],
                                                 sheet: @sheet, parent_part: self)

    @right_column = WikiHouse::Column.new(label: "Right",
                                          origin: [@origin.x + @left_column.width + @left_wall_panel.width + @middle_column.width + @right_wall_panel.width,
                                                   @origin.y, @origin.z],
                                          wall_panels_on: RIGHT_COLUMN_BOARD_PEG_FACES, sheet: @sheet, parent_part: self)
    @left_column_zpegs = build_zpegs(faces: LEFT_COLUMN_BOARD_PEG_FACES, peg_label: "Left Column",
     column: @left_column)
    @right_column_zpegs = build_zpegs(faces: RIGHT_COLUMN_BOARD_PEG_FACES, peg_label: "Right Column", column: @right_column)
    @middle_column_zpegs = build_zpegs(faces: MIDDLE_COLUMN_BOARD_PEG_FACES, peg_label: "Middle Column",
                                       column: @middle_column)

  end

  def build_zpegs(faces: nil, peg_label: nil, column: nil)
    zpegs = {}
    faces.each { |f| zpegs[f] = [] }
    wall_panel_zpegs.times do |index|
      faces.each do |f|
        p_label = "#{peg_label} #{f+1}-#{index + 1}"
        #puts "#{p_label}"
        zpegs[f] << WikiHouse::DoubleZPeg.new(label: p_label ,
                                              origin: column.origin, sheet: sheet)
      end

    end
    zpegs
  end

  def wall_height
    if sheet.length == 24
      22.5
    else
      94
    end
  end

  def wall_panel_zpegs
    3
  end

  def draw_zpegs!(column: nil, zpegs: nil)
    zpegs.each do |key, value|
      column_board = column.column_board(key)
    #  puts "Board #{column_board.group.name}"
      connector = column_board.face_connector
      connector.class.drawing_points(bounding_origin: column.origin,
                                     count: wall_panel_zpegs,
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
          zpeg = zpegs[key][wall_panel_zpegs - col - 1]
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
          zpeg = zpegs[key][wall_panel_zpegs - col - 1]
          zpeg.draw!


          zpeg.rotate(vector: [1, 0, 0], rotation: 90.degrees).
              rotate(vector: [0, 1, 0], rotation: -90.degrees).
              move_to(point: zpeg.origin).
               move_by(z: -1 * zpeg.thickness - column_board.width/2.0,
                       x: zpeg.width * -0.5 + thickness , #In/Out
                       y: -1 * location.y + Sk.abs(column_board.origin.y) - thickness * 3  - zpeg.width/2.0).
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

  def draw!
    Sk.find_or_create_layer(name: self.class.name)
    Sk.make_layer_active_name(name: self.class.name)
     @left_column.draw!
     @left_wall_panel.draw!
     @middle_column.draw!
     @right_wall_panel.draw!
     @right_column.draw!

     draw_zpegs!(column: @left_column, zpegs: @left_column_zpegs)
     draw_zpegs!(column: @right_column, zpegs: @right_column_zpegs)

    draw_zpegs!(column: @middle_column, zpegs: @middle_column_zpegs)


    groups = [@left_column.group, @left_wall_panel.group, @middle_column.group, @right_wall_panel.group, @right_column.group]

     @left_column_zpegs.keys.each do |k|
       groups.concat(@left_column_zpegs[k].collect {|v| v.group})
     end
    @right_column_zpegs.keys.each do |k|
      groups.concat(@right_column_zpegs[k].collect {|v| v.group})
    end
    @middle_column_zpegs.keys.each do |k|
      groups.concat(@middle_column_zpegs[k].collect {|v| v.group})
    end

    groups = groups.compact
    set_group(groups)
  end
end