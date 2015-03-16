class WikiHouse::ColumnRib

  include WikiHouse::PartHelper

  def initialize(column: nil, sheet: nil, group: nil, origin: nil, label: nil)
    part_init(origin: origin, sheet: sheet, label: label)
    @column = column ? column : raise(ArgumentError, "You must provide a Column")
    @bottom_face = nil
  end
  def side_length
    @column.bottom_side_length
  end

  def tab_width
    @column.tab_width
  end

  def create_face(line_points)
    lines = Sk.draw_all_points(line_points)
    face = Sk.add_face(lines.first.all_connected)
    face
  end

  def bottom_face_line_pts
    c0 = @origin.dup
    c1 = [c0.x + thickness, c0.y - thickness, c0.z]
    c2 = [c0.x + side_length - (thickness), c1.y, c1.z]
    c3 = [c2.x, c0.y - side_length + (thickness), c2.z]
    c4 = [c1.x, c3.y, c3.z]

    points = [c1]
    x_midpoint = c1.x + (c2.x - c1.x)/2.0
    y_midpoint = c2.y - (c2.y - c3.y)/2.0
    half_tab = tab_width/2.0

    points << [x_midpoint - half_tab, c1.y, c1.z]
    points << [x_midpoint - half_tab, c1.y + thickness, c1.z]
    points << [x_midpoint + half_tab, c1.y + thickness, c1.z]
    points << [x_midpoint + half_tab, c1.y, c1.z]
    points << c2

    points << [c2.x, y_midpoint + half_tab, c2.z]
    points << [c2.x + thickness, y_midpoint + half_tab, c2.z]
    points << [c2.x + thickness, y_midpoint - half_tab, c2.z]
    points << [c2.x, y_midpoint - half_tab, c2.z]
    points << c3

    points << [x_midpoint + half_tab, c3.y, c3.z]
    points << [x_midpoint + half_tab, c3.y - thickness, c3.z]
    points << [x_midpoint - half_tab, c3.y - thickness, c3.z]
    points << [x_midpoint - half_tab, c3.y, c3.z]
    points << c4

    points << [c4.x, y_midpoint - half_tab, c4.z]
    points << [c4.x - thickness, y_midpoint - half_tab, c4.z]
    points << [c4.x - thickness, y_midpoint + half_tab, c4.z]
    points << [c4.x, y_midpoint + half_tab, c4.z]


    points
  end


  def draw!
    @bottom_face = create_face(bottom_face_line_pts)
    make_part_right_thickness(@bottom_face)
   set_group(@bottom_face.all_connected)
  end
end