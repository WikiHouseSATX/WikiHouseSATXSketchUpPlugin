class WikiHouse::Wall

  include WikiHouse::PartHelper
  LEFT_COLUMN_BOARD_PEG_FACE = 3
  RIGHT_COLUMN_BOARD_PEG_FACE = 1

  def initialize(origin: nil, sheet: nil, label: nil)
    origin = [27, 56, 0]
    part_init(sheet: sheet, origin: origin)

    @left_column = WikiHouse::Column.new(label: "Left", origin: @origin, sheet: @sheet, wall_panels_on: [LEFT_COLUMN_BOARD_PEG_FACE], parent_part: self)
    @wall_panel = WikiHouse::WallPanel.new(label: "Wall Panel", origin: [@origin.x + @left_column.width, @origin.y, @origin.z], sheet: @sheet, parent_part: self)
    @right_column = WikiHouse::Column.new(label: "Right", origin: [@origin.x + @left_column.width + @wall_panel.width, @origin.y, @origin.z], wall_panels_on: [RIGHT_COLUMN_BOARD_PEG_FACE], sheet: @sheet, parent_part: self)
    @left_column_zpegs = []
    @right_column_zpegs = []
    wall_panel_zpegs.times do |index|
      @left_column_zpegs << WikiHouse::DoubleZPeg.new(label: "LeftColumn #{index + 1}", origin: @left_column.origin, sheet: @sheet)
      @right_column_zpegs << WikiHouse::DoubleZPeg.new(label: "RightColumn #{index + 1}", origin: @right_column.origin, sheet: @sheet)
    end

  end



  def wall_height
    if sheet.length == 24
      22.5
    else
      90
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

  def draw!
    Sk.find_or_create_layer(name: self.class.name)
    Sk.make_layer_active_name(name: self.class.name)
    @left_column.draw!
    @wall_panel.draw!
    @right_column.draw!
    column_board = @left_column.column_board(LEFT_COLUMN_BOARD_PEG_FACE)
    connector = column_board.face_connector
    connector.class.drawing_points(bounding_origin: origin,
                                   count: wall_panel_zpegs,
                                   rows: 1,
                                   part_length: column_board.length,
                                   part_width: column_board.width,
                                   item_length: connector.top_slot_length,
                                   item_width: connector.top_slot_width) do |row, col, location|
      zpeg = @left_column_zpegs[col]
      zpeg.draw!


      zpeg.rotate(vector: [1, 0, 0], rotation: 90.degrees).
          rotate(vector: [0, 0, 1], rotation: 0.degrees).
          move_to(point: origin).
          move_by(z: -1 * zpeg.thickness - column_board.width/2.0,
                  x: zpeg.width * 0.75,
                  y: -1 * location.y + Sk.abs(origin.y) - zpeg.length * 0.75).
          go!
    end

    column_board = @right_column.column_board(RIGHT_COLUMN_BOARD_PEG_FACE)
    connector = column_board.face_connector
    connector.class.drawing_points(bounding_origin: @right_column.origin,
                                   count: wall_panel_zpegs,
                                   rows: 1,
                                   part_length: column_board.length,
                                   part_width: column_board.width,
                                   item_length: connector.top_slot_length,
                                   item_width: connector.top_slot_width) do |row, col, location|
      zpeg = @right_column_zpegs[wall_panel_zpegs - col - 1]
      zpeg.draw!


      zpeg.rotate(vector: [1, 0, 0], rotation: 90.degrees).
          rotate(vector: [0, 0, 1], rotation: 180.degrees).
          rotate(vector: [0, 1, 0], rotation: 180.degrees).
          move_to(point: zpeg.origin).
          move_by(z: -1 * zpeg.thickness + column_board.width/2.0,
                  x: zpeg.width * -0.5 - thickness, #Left right
                  y: -1 * location.y + Sk.abs(column_board.origin.y) - thickness * 2 - column_board.length).
          go!
    end

    groups = @left_column_zpegs.collect { |p| p.group }.concat(@right_column_zpegs.collect { |p| p.group }).concat([@left_column.group, @wall_panel.group, @right_column.group]).compact
    set_group(groups)
  end


end