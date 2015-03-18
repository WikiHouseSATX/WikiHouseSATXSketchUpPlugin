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

    WikiHouse::Fillet.by_points(points,2,1,0, reverse_it: true)


    points << [x_midpoint - half_tab, c1.y + thickness, c1.z]

    index = points.length
    points << [x_midpoint + half_tab, c1.y + thickness, c1.z]
    points << [x_midpoint + half_tab, c1.y, c1.z]

    points << c2

    WikiHouse::Fillet.by_points(points, index , index + 1 , index + 2)
    index = points.length - 1


    points << [c2.x, y_midpoint + half_tab, c2.z]
    points << [c2.x + thickness, y_midpoint + half_tab, c2.z]

    WikiHouse::Fillet.by_points(points, index + 2 , index + 1, index, reverse_it: true)
    index = points.length

    points << [c2.x + thickness, y_midpoint - half_tab, c2.z]
    points << [c2.x, y_midpoint - half_tab, c2.z]
    points << c3
    WikiHouse::Fillet.by_points(points, index , index + 1 , index + 2)
    index = points.length - 1
    points << [x_midpoint + half_tab, c3.y, c3.z]
    points << [x_midpoint + half_tab, c3.y - thickness, c3.z]
    WikiHouse::Fillet.by_points(points, index + 2 , index + 1, index, reverse_it: true)
    index = points.length
    points << [x_midpoint - half_tab, c3.y - thickness, c3.z]
    points << [x_midpoint - half_tab, c3.y, c3.z]
    points << c4
    WikiHouse::Fillet.by_points(points, index , index + 1 , index + 2)
    index = points.length - 1
    points << [c4.x, y_midpoint - half_tab, c4.z]
    points << [c4.x - thickness, y_midpoint - half_tab, c4.z]
    WikiHouse::Fillet.by_points(points, index + 2 , index + 1, index, reverse_it: true)
    index = points.length
    points << [c4.x - thickness, y_midpoint + half_tab, c4.z]
    points << [c4.x, y_midpoint + half_tab, c4.z]
     # Sk.draw_line([0,0,0], points[index])
     # Sk.draw_line([0,0,0], points[index + 1])
     # Sk.draw_line([0,0,0], points[index + 2])
    points << c1
    WikiHouse::Fillet.by_points(points, index , index + 1 , index + 2)
    points.pop #Get rid of the c1 at the end - since it will be auto connected
    points
  end



  def draw!
    @bottom_face = create_face(bottom_face_line_pts)

    make_part_right_thickness(@bottom_face)
    set_group(@bottom_face.all_connected)
  end
end