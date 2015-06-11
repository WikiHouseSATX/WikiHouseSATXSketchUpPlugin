#This has to inlcude the wedge as well
class WikiHouse::DoubleUPeg
  include WikiHouse::PartHelper

  def initialize(origin: nil, sheet: nil, label: nil)
    part_init(sheet: sheet, origin: origin, label:label)

    @left_upeg = WikiHouse::UPeg.new(sheet: @sheet, origin: @origin, label: "#{label} Left", parent_part: self)
    @right_upeg = WikiHouse::UPeg.new(sheet: @sheet, origin: [@origin.x, @origin.y, @origin.z + thickness], label: "#{label} right", parent_part: self)
    @left_wedge = WikiHouse::Wedge.new(sheet: @sheet, origin:  [@origin.x , @origin.y - 9 * self.sheet.thickness, @origin.z], label: "#{label} Left", parent_part: self,
                                        width_in_t: 10, right_length_in_t: 2, left_length_in_t: 1)
    @right_wedge = WikiHouse::Wedge.new(sheet: @sheet, origin: [@origin.x , @origin.y - 9 * self.sheet.thickness, @origin.z + thickness],
                                        label: "#{label} right", parent_part: self,   width_in_t: 10, right_length_in_t: 2, left_length_in_t: 1)


  end

  def origin=(new_origin)
    @origin = new_origin
    @left_upeg.origin = new_origin
    @right_upeg.origin = [new_origin.x, new_origin.y, new_origin.z + thickness]
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
    @left_upeg.draw!
   @right_upeg.draw!
    @left_wedge.draw!
    @right_wedge.draw!

    groups = [@left_upeg.group, @right_upeg.group, @left_wedge.group, @right_wedge.group].compact
    set_group(groups)

  end


end