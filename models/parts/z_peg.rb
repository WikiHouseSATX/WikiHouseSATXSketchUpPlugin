class WikiHouse::ZPeg


  include WikiHouse::PartHelper


  def initialize(sheet: nil, group: nil, origin: nil, label: label)
    part_init(origin: origin, sheet: sheet, label: label)

  end

  def c1
    [@origin.x, @origin.y, @origin.z]
  end

  def make_peg
    t = thickness

    c2 = [c1.x, c1.y + 8 * t, c1.z]
    c3 = [c1.x + 8 * t, c1.y + 8 * t, c1.z]
    c4 = [c1.x + 8 * t, c1.y + 12 * t, c1.z]
    c5 = [c1.x + 12 * t, c1.y + 12 * t, c1.z]

    c6 = [c1.x + 12 * t, c1.y + 4 * t, c1.z]
    c7 = [c1.x + 4 * t, c1.y + 4 * t, c1.z]
    c8 = [c1.x + 4 * t, c1.y, c1.z]

    [c1, c2, c3, c4, c5, c6, c7, c8]
  end

  def make_dowels!
    t = thickness

    d1 = [c1.x + 2 * t, c1.y + 2 * t, c1.z]
    d2 = [c1.x + 2 * t, c1.y + 6 * t, c1.z]
    d3 = [c1.x + 6 * t, c1.y + 6 * t, c1.z]
    d4 = [c1.x + 10 * t, c1.y + 6 * t, c1.z]
    d5 = [c1.x + 10 * t, c1.y + 10 * t, c1.z]
    dowels = []
    [d1, d2, d3, d4, d5].each { |d| dowels << Sk.draw_circle(center_point: d, radius: WikiHouse::Cnc.bit_radius) }
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