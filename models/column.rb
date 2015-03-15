class WikiHouse::Column
  include WikiHouse::PartHelper

  def initialize(origin: nil, sheet: nil)
    part_init(sheet: sheet, origin: origin)
    @column_boards = []
    4.times do |index|
      @column_boards << WikiHouse::ColumnBoard.new(column: self, origin: [@origin.x + (20 * index), @origin.y + 20, @origin.z], sheet: sheet)
    end
    @ribs = []
    @ribs << WikiHouse::ColumnRib.new(column: self, origin: @origin)
    number_of_internal_supports.times do |index|
      height = support_section_height * (index + 1) - thickness/2.0
      rib = WikiHouse::ColumnRib.new(column: self, origin: [@origin.x, @origin.y, @origin.z + height])
      @ribs << rib
    end
    rib = WikiHouse::ColumnRib.new(column: self, origin: [@origin.x, @origin.y, @origin.z + left_side_length - thickness])
    @ribs << rib

  end
  def support_section_height
    left_side_length/(number_of_internal_supports.to_f + 1.0)
  end
  def number_of_internal_supports
    2
  end

  def bottom_side_length
    10
  end

  def left_side_length
    80

  end

  def tab_width
    5
  end


  def draw!

    #At the end it should group all the compenents together
    @ribs.each {|rib| rib.draw!}
    @column_boards.each {|board| board.draw!}

    return
    @column.move_to!([0, 0, 0])
    column_board2 = column_board.copy


    # tr = Geom::Transformation.rotation point, [1, 0, 0], -90.degrees
    #column_board.move! tr

    # column_board3 = column_board.copy
    #  column_board4 = column_board.copy

    #
    point = Geom::Point3d.new 0, 0, 0
    tr = Geom::Transformation.rotation point, [0, 0, 1], 90.degrees
    tm = Geom::Transformation.new(Geom::Point3d.new(-1 * @column.bottom_side_length, 0, 0))

    tr2 = Geom::Transformation.rotation point, [1, 0, 0], 90.degrees

    column_board2.move! tr * tm * tr2


    #    @top_column_cap = ColumnRib.new(@column, origin: [0, 0, @column.left_side_length])
    #  @top_column_cap.draw!

  end
end