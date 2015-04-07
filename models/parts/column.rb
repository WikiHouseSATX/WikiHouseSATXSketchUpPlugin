class WikiHouse::Column
  include WikiHouse::PartHelper


  def initialize(origin: nil, sheet: nil, label: nil, parent_part: nil, wall_panels_on: [])
    part_init(sheet: sheet, origin: origin, label: label, parent_part: parent_part)

    @column_boards = []
    4.times do |index|
      if wall_panels_on.include?(index)
        @column_boards << WikiHouse::WallColumnBoard.new(label: "#{label} Column ##{index + 1}", parent_part: self, origin: @origin, sheet: sheet)

      else
        @column_boards << WikiHouse::ColumnBoard.new(label: "#{label} Column ##{index + 1}", parent_part: self, origin: @origin, sheet: sheet)

      end
    end
    @mid_ribs = []
    @bottom_rib = WikiHouse::ColumnRib.new(parent_part: self, origin: [@origin.x, @origin.y + width, @origin.z - thickness], label: "#{label} Column Bottom")
     number_of_internal_supports.times do |index|

      @mid_ribs <<  WikiHouse::ColumnRib.new(label: "#{label} Column Mid ##{index + 1}", parent_part: self, origin: @origin)

    end
    @top_rib = WikiHouse::ColumnRib.new(label: "#{label} Column Top",
                                   parent_part: self,
                                   origin: [@origin.x, @origin.y + width, @origin.z + length -  2 * thickness])
  end

  def wall_panel_zpegs
    parent_part.wall_panel_zpegs
  end

  def number_of_internal_supports
    3
  end


  def width
    10
  end

  def length
    80
  end


  def draw!

    @column_boards.each_with_index do |board, index|

      board.draw!


      if index == 0
        alteration = board.rotate(vector: [1, 0, 0], rotation: 90.degrees).
            rotate(vector: [0, 0, 1], rotation: 0.degrees).
            move_to(point: origin)
        alteration.move_by(x: 0, y: thickness * -1, z: width * -1)
      elsif index == 1
        alteration = board.rotate(vector: [1, 0, 0], rotation: 90.degrees).
            rotate(vector: [0, 0, 1], rotation: 0.degrees).
            rotate(vector: [0, 1, 0], rotation: 90.degrees).
            move_to(point: origin).
            move_by(x: 0, y: thickness * -1, z: 0)
      elsif index == 2
        alteration = board.rotate(vector: [1, 0, 0], rotation: 90.degrees).
            rotate(vector: [0, 0, 1], rotation: 0.degrees).
            rotate(vector: [0, 1, 0], rotation: 180.degrees).
            move_to(point: origin).
            move_by(x: board.width * -1, y: thickness * -1, z: 0)
      elsif index == 3
        alteration = board.rotate(vector: [1, 0, 0], rotation: 90.degrees).
            rotate(vector: [0, 0, 1], rotation: 0.degrees).
            rotate(vector: [0, 1, 0], rotation: 270.degrees).
            move_to(point: origin).
            move_by(x: board.width * -1, y: thickness * -1 , z:  -1 * width)
      end
      alteration.go!

    end
   @top_rib.draw!
    @bottom_rib.draw!
    raise ScriptError, "The mid ribs need to be put in the right place"
     # column_board = @column_boards.first
     #  connector = column_board.face_connector
     #  connector.class.drawing_points(bounding_origin: origin,
     #                                 count: number_of_internal_supports,
     #                                 rows: 1,
     #                                 part_length: length,
     #                                 part_width: width,
     #                                 item_length: @top_rib.length,
     #                                 item_width: @top_rib.width) do |row, col, location|
     #    rib = @left_ribs[col]
     #    rib.draw!
     #
     #
     #    rib.rotate(vector: [0, 0, 1], rotation: 90.degrees).
     #        move_to(point: origin).
     #        move_by(x: 0,
     #                y: panel_rib_width * -1,
     #                z: -1 * location.y + Sk.abs(origin.y)).
     #        go!
     #
     #  end

    groups = @mid_ribs.collect { |r| r.group }.concat(@column_boards.collect { |b| b.group }).concat([@top_rib.group, @bottom_rib.group]).compact


    set_group(groups)

  end
end