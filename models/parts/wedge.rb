class WikiHouse::Wedge

  include WikiHouse::AttributeHelper
  include WikiHouse::PartHelper


  def initialize(left_length_in_t: nil,
                 right_length_in_t: nil,
                 width_in_t: nil,
                 sheet: nil, group: nil, origin: nil, label: label, parent_part: nil)
    part_init(origin: origin, sheet: sheet, label: label, parent_part: parent_part)
    @left_length_in_t = left_length_in_t
    @right_length_in_t = right_length_in_t || left_length_in_t
    @width_in_t = width_in_t
    raise ArgumentError, "You must provdie a length and width" if @left_length_in_t <= 0 || @right_length_in_t <= 0 || @width_in_t <= 0

  end
  def origin=(new_origin)
    @origin = new_origin
  end
  def length
   right_length
  end

  def left_length
    thickness * @left_length_in_t
  end
  def right_length
    thickness * @right_length_in_t
  end
  def width
    thickness * @width_in_t
  end

  def bounding_c1

    @origin.dup
  end

  def bounding_c2

      length_diff = right_length - left_length
      [bounding_c1.x + width, bounding_c1.y + length_diff , bounding_c1.z]


  end

  def bounding_c3
    [bounding_c2.x , bounding_c2.y - right_length, bounding_c2.z]
  end

  def bounding_c4
    [bounding_c1.x , bounding_c1.y - left_length, bounding_c1.z]
  end

  def make_peg
    t = thickness
    c1 = bounding_c1
    c2 = bounding_c2
    c3 = bounding_c3
    c4 = bounding_c4


    [c1,c2, c3, c4]
  end

  def make_dowels!
     return [] if WikiHouse.machine.bit_radius == 0
     t = thickness

     d1 = [bounding_c1.x + (@width_in_t/2.0) * t, (bounding_c1.y + bounding_c4.y)/2.05 , bounding_c1.z]
     d2 = [bounding_c2.x - width * 0.15,(bounding_c1.y + bounding_c4.y)/2.1 , bounding_c1.z]

     dowels = []
     [d1, d2].each { |d| dowels << Sk.draw_circle(center_point: d, radius: WikiHouse.machine.bit_radius) }
     dowels.each { |d| d.each { |e| mark_inside_edge!(e) } }

     dowels
  end

  def draw!

    points = make_peg


    lines = Sk.draw_all_points(points)
    if WikiHouse.machine.bit_radius != 0
      dowels = make_dowels!
    else
      dowels = []
    end

    face = Sk.add_face(lines)
    set_material(face)

    dowels.each do |sp|
      dowel_face = Sk.add_face(sp)
      dowel_face.erase!
    end

    make_part_right_thickness(face)
    Sk.add_face(lines)

    set_group(face.all_connected)
    mark_primary_face!(face)
  end

  def set_default_properties
    mark_cutable!
  end
end