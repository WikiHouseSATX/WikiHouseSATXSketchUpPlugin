class WikiHouse::DoubleZPeg
  include WikiHouse::PartHelper

  def initialize(origin: nil, sheet: nil, label: nil)
    part_init(sheet: sheet, origin: origin, label:label)

    @left_zpeg = WikiHouse::ZPeg.new(sheet: @sheet, origin: @origin, label: "#{label} Left", parent_part: self)
    @right_zpeg = WikiHouse::ZPeg.new(sheet: @sheet, origin: [@origin.x, @origin.y, @origin.z + thickness], label: "#{label} right", parent_part: self)
  end


  def length
    thickness * 12
  end

  def width
    thickness * 12
  end
  def depth
    thickness * 2
  end
  def draw!

    Sk.find_or_create_layer(name: self.class.name)
    Sk.make_layer_active_name(name: self.class.name)
    @left_zpeg.draw!
    @right_zpeg.draw!


    groups = [@left_zpeg.group, @right_zpeg.group].compact
    set_group(groups)

  end


end