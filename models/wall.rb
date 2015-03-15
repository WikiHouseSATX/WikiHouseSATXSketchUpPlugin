class WikiHouse::Wall

  include WikiHouse::PartHelper

  def initialize(origin: nil, sheet: nil)
    part_init(sheet: sheet, origin: origin)


    @left_column = WikiHouse::Column.new(origin: @origin, sheet: sheet)
    @right_column = WikiHouse::Column.new(origin: [@origin.x + 20, @origin.y, @origin.z], sheet: sheet)
  end

  def wall_height
    80
  end


  def draw!
    @left_column.draw!
 #   @right_column.draw!
  end
end