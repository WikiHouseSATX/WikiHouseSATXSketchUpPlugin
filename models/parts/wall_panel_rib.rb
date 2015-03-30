class WikiHouse::WallPanelRib

  include WikiHouse::PartHelper
  include WikiHouse::BoardPartHelper

  def initialize(panel: nil, sheet: nil, group: nil, origin: nil, label: label)
    part_init(origin: origin, sheet: sheet, label: label)
    @panel = panel ? panel : raise(ArgumentError, "You must provide a WallPanel")
  end

  def top_connector
    :tab
  end
  def bottom_connector
    :tab
  end
  def parent_part
    @panel
  end

  def number_of_face_tabs
    parent_part.number_of_face_tabs
  end
  def bottom_side_length
    parent_part.panel_depth
  end

  def left_side_length
    parent_part.panel_rib_width
  end

  def number_of_side_tabs
    parent_part.number_of_face_tabs
  end

  def draw!

    top_bottom_lines = top_bottom_tabs
    left_tabs(top: :tab, bottom: :tab)
   # righ_tabs
    lines = top_bottom_lines.select { |l| !l.deleted? }.first.all_connected
    face = Sk.add_face(lines)
    set_material(face)

    make_part_right_thickness(face)
    face2 = Sk.add_face(lines)

    set_group(face.all_connected)
    mark_primary_face!(face)
  end


end