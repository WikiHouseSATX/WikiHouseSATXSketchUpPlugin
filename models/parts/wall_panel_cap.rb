class WikiHouse::WallPanelCap

  include WikiHouse::PartHelper
  include WikiHouse::BoardPartHelper

  def initialize(panel: nil, sheet: nil, group: nil, origin: nil, label: label)
    part_init(origin: origin, sheet: sheet, label: label)
    @panel = panel ? panel : raise(ArgumentError, "You must provide a WallPanel")
  end

  def parent_part
    @panel
  end

  def bottom_side_length
    parent_part.panel_depth
  end

  def left_side_length
    parent_part.panel_width
  end

  def rib_pockets
    #Single rib - that is double thickness
    half_tab = tab_width/2.0

    mid_x = bottom_side_length/2.0

    pocket_thickness = thickness * 2.0

    rib_pockets_list = []

    base = left_side_length/2.0 * -1
    c5 = [c1.x + mid_x - half_tab, c1.y + base + pocket_thickness/2.0, c1.z]
    c6 = [c1.x + mid_x + half_tab, c5.y, c1.z]
    c7 = [c6.x, c1.y + base - pocket_thickness/2.0, c1.z]
    c8 = [c5.x, c7.y, c1.z]
    points = [c5, c6, c7, c8]
    WikiHouse::Fillet.pocket_by_points(points)

    rib_pockets_list << Sk.draw_all_points(points)
    rib_pockets_list.last.each { |e| mark_inside_edge!(e) }


    rib_pockets_list
  end

  def draw!

    top_bottom_lines = top_bottom_tabs
    rib_pockets_list = rib_pockets
    lines = top_bottom_lines.select { |l| !l.deleted? }.first.all_connected
    face = Sk.add_face(lines)
    set_material(face)
    rib_pockets_list.each do |sp|
      pocket_face = Sk.add_face(sp)
      pocket_face.erase!
    end
    make_part_right_thickness(face)
    face2 = Sk.add_face(lines)

    set_group(face.all_connected)
    mark_primary_face!(face)
  end


end