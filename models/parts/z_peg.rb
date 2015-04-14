class WikiHouse::ZPeg


  include WikiHouse::PartHelper


  def initialize(sheet: nil, group: nil, origin: nil, label: label, parent_part: nil)
    part_init(origin: origin, sheet: sheet, label: label, parent_part: parent_part)

  end
  def length
    thickness * 12
  end

  def width
    thickness * 12
  end

  def bounding_c1
    @origin.dup
  end

  def bounding_c2
    [bounding_c1.x + width, bounding_c1.y, bounding_c1.z]
  end

  def bounding_c3
    [bounding_c1.x + width, bounding_c1.y - length, bounding_c1.z]
  end

  def bounding_c4
    [bounding_c1.x, bounding_c1.y - length, bounding_c1.z]
  end

  def make_peg
    t = thickness

    c2 = [bounding_c1.x, bounding_c1.y + 8 * t, bounding_c1.z]
    c3 = [bounding_c1.x + 8 * t, bounding_c1.y + 8 * t, bounding_c1.z]
    c4 = [bounding_c1.x + 8 * t, bounding_c1.y + 12 * t, bounding_c1.z]
    c5 = [bounding_c1.x + 12 * t, bounding_c1.y + 12 * t, bounding_c1.z]

    c6 = [bounding_c1.x + 12 * t, bounding_c1.y + 4 * t, bounding_c1.z]
    c7 = [bounding_c1.x + 4 * t, bounding_c1.y + 4 * t, bounding_c1.z]
    c8 = [bounding_c1.x + 4 * t, bounding_c1.y, bounding_c1.z]

    [bounding_c1, c2, c3, c4, c5, c6, c7, c8]
  end

  def make_dowels!
    return if WikiHouse.machine.bit_radius == 0
    t = thickness

    d1 = [bounding_c1.x + 2 * t, bounding_c1.y + 2 * t, bounding_c1.z]
    d2 = [bounding_c1.x + 2 * t, bounding_c1.y + 6 * t, bounding_c1.z]
    d3 = [bounding_c1.x + 6 * t, bounding_c1.y + 6 * t, bounding_c1.z]
    d4 = [bounding_c1.x + 10 * t, bounding_c1.y + 6 * t, bounding_c1.z]
    d5 = [bounding_c1.x + 10 * t, bounding_c1.y + 10 * t, bounding_c1.z]
    dowels = []
    [d1, d2, d3, d4, d5].each { |d| dowels << Sk.draw_circle(center_point: d, radius: WikiHouse.machine.bit_radius) }
    dowels.each { |d| d.each { |e| mark_inside_edge!(e) } }

    dowels
  end

  def draw!

    points = make_peg


    lines = Sk.draw_all_points(points)
    dowels = make_dowels!


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