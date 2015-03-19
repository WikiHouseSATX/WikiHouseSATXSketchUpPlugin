class WikiHouse::Wall

  include WikiHouse::PartHelper

  def initialize(origin: nil, sheet: nil, label: nil)
    part_init(sheet: sheet, origin: origin)


    @left_column = WikiHouse::Column.new(label: "Left", origin: @origin, sheet: sheet)
    @right_column = WikiHouse::Column.new(label: "Right", origin: [@origin.x + 40, @origin.y + 40, @origin.z + 10], sheet: sheet)
  end

  def wall_height
    80
  end


  def draw!
    Sk.find_or_create_layer(name: self.class.name)
    Sk.make_layer_active_name(name: self.class.name)
    @left_column.draw!
    @right_column.draw!

   # set_group([@left_column.group])
    set_group([@left_column.group, @right_column.group])


  end


end