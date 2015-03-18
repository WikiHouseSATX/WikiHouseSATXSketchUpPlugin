class WikiHouse::ColumnBoard

  include WikiHouse::PartHelper

  def initialize(column: nil, sheet: nil, group: nil, origin: nil, label: label)
    part_init(origin: origin, sheet: sheet, label: label)
    @column = column ? column : raise(ArgumentError, "You must provide a Column")
  end

  def support_section_height
    @column.support_section_height
  end

  def number_of_internal_supports
    @column.number_of_internal_supports
  end

  def bottom_side_length
    @column.bottom_side_length
  end

  def left_side_length
    @column.left_side_length
  end

  def tab_width
    @column.tab_width
  end

  def number_of_side_tabs
    3
  end

  def bottom_tab_start
    bottom_side_length/2.0 - tab_width/2.0
  end

  def bottom_tab_end
    bottom_side_length/2.0 + tab_width/2.0
  end

  def c1
    @origin.dup
  end

  def c2
    [c1.x + bottom_side_length, c1.y, c1.z]
  end

  def c3
    [c1.x + bottom_side_length, c1.y - left_side_length, c1.z]
  end

  def c4
    [c1.x, c1.y - left_side_length, c1.z]
  end

  def right_pockets
    lines = []
    c5 = c2
    c5.y -= thickness

    c6 = c3
    c6.y += thickness

    total_length = c5.y - c6.y

    section_width = total_length/number_of_side_tabs.to_f
    number_of_side_tabs.times do |i|
      start_y = c5.y - (i * section_width)

      mid_point = start_y - section_width/2.0

      start_pocket = mid_point + tab_width/2.0
      end_pocket = mid_point - tab_width/2.0
      end_y = (i + 1) * section_width

      pc1 = [c5.x - thickness, start_pocket, c5.z]
      pc2 = [c5.x, start_pocket, c5.z]
      pc3 = [c5.x, end_pocket, c5.z]
      pc4 = [c5.x - thickness, end_pocket, c5.z]
      points = [pc2, pc1, pc4, pc3]
      WikiHouse::Fillet.by_points(points, 0, 1, 2)
      WikiHouse::Fillet.by_points(points, 5,4,3, reverse_it: true)

      lines.concat(Sk.draw_points(points))
      Sk.erase_line(pc2, pc3)

    end
    lines
  end

  def left_tabs

    c1_5 = [c1.x + thickness, c1.y, c1.z]
    c4_5 = [c4.x + thickness, c4.y, c4.z]
    lines = []
    c5 = c1
    c5.y -= thickness
    c6 = [c5.x + thickness, c5.y, c5.z]

    c7 = [c6.x, c6.y - left_side_length + (2 * thickness), c6.z]
    c8 = [c5.x, c7.y, c5.z]

    Sk.erase_line(c1, c4)
    Sk.erase_line(c1, c1_5)
    Sk.erase_line(c4, c4_5)

    Sk.draw_line(c1_5, c6)
    Sk.draw_line(c7, c4_5)
    total_length = c5.y - c8.y

    section_width = total_length/number_of_side_tabs.to_f
    last_point_1 = nil
    last_point_2 = c6
    last_point_4 = nil
    number_of_side_tabs.times do |i|
      start_y = c5.y - (i * section_width)

      mid_point = start_y - section_width/2.0

      start_pocket = mid_point + tab_width/2.0
      end_pocket = mid_point - tab_width/2.0
      pc1 = [c5.x, start_pocket, c5.z]
      pc2 = [c5.x + thickness, start_pocket, c5.z]
      pc3 = [c5.x + thickness, end_pocket, c5.z]
      pc4 = [c5.x, end_pocket, c5.z]

      points = []
      points == [last_point_4, last_point_1] if last_point_4
      if last_point_1 && last_point_2
        points << last_point_1
        points << last_point_2
      end
      if last_point_2
        points << last_point_2 unless points.include? (last_point_2)

      end

      points << pc2
      points << pc1
      points << pc4

      #  Sk.draw_line([-100,-100,0], pc4)
      if last_point_1.nil?
        WikiHouse::Fillet.by_points(points, 2, 1, 0, reverse_it: true)

      else
        WikiHouse::Fillet.by_points(points, 3, 2, 1, reverse_it: true)
        WikiHouse::Fillet.by_points(points, 0, 1, 2)

        # Sk.draw_line([-100,-100,0],points[1])
        #   Sk.draw_line([-100,-100,0], points[0])
        #  Sk.draw_line([-100,-100,0], points[9])
      end


      new_lines = Sk.draw_points(points)
      lines.concat(new_lines)
      last_point_1 = pc4
      last_point_2 = pc3
      last_point_4 = pc1


    end
    points = []
    points << last_point_4 if last_point_4
    points << last_point_1
    points << last_point_2
    points << c7

    WikiHouse::Fillet.by_points(points, 1, 2, 3)
    new_lines = Sk.draw_points(points)

    lines.concat(new_lines)
    lines
  end

  def top_bottom_pockets

    #Top Indent
    c5 = [c1.x + bottom_tab_start, c1.y, c1.z]
    c6 = [c1.x + bottom_tab_end, c1.y, c1.z]
    c7 = [c1.x + bottom_tab_end, c1.y - thickness, c1.z]
    c8 = [c1.x + bottom_tab_start, c1.y - thickness, c1.z]

    c9 = [c1.x + bottom_tab_start, c1.y - left_side_length + thickness, c1.z]
    c10 = [c1.x + bottom_tab_end, c1.y - left_side_length + thickness, c1.z]
    c11 = [c1.x + bottom_tab_end, c1.y - left_side_length, c1.z]
    c12 = [c1.x + bottom_tab_start, c1.y - left_side_length, c1.z]


    pts = [c1, c5, c8, c7, c6, c2, c3, c11, c10, c9, c12, c4]
    WikiHouse::Fillet.by_points(pts, 1, 2, 3)


    WikiHouse::Fillet.by_points(pts, 6,5,4, reverse_it: true)


    WikiHouse::Fillet.by_points(pts, 11, 12, 13)

    WikiHouse::Fillet.by_points(pts, 16, 15, 14, reverse_it: true)
    Sk.draw_all_points(pts)
  end


  def support_pockets

    half_tab = tab_width/2.0

    mid_x = bottom_side_length/2.0

    support_pockets_list = []
    number_of_internal_supports.times do |index|
      base = support_section_height * (index + 1) * -1
      c5 = [c1.x + mid_x - half_tab, c1.y + base + thickness/2.0, c1.z]
      c6 = [c1.x + mid_x + half_tab, c5.y, c1.z]
      c7 = [c6.x, c1.y + base - thickness/2.0, c1.z]
      c8 = [c5.x, c7.y, c1.z]
      points = [c5, c6, c7,c8]
      WikiHouse::Fillet.pocket_by_points(points)

      support_pockets_list << Sk.draw_all_points(points)

    end

    support_pockets_list
  end

  def draw!
    top_bottom_lines = top_bottom_pockets
    right_pockets
    left_tabs
    support_pockets_list =support_pockets

    lines = top_bottom_lines.select { |l| !l.deleted? }.first.all_connected
    face = Sk.add_face(lines)

    support_pockets_list.each do |sp|
      pocket_face = Sk.add_face(sp)
      pocket_face.erase!
    end
    make_part_right_thickness(face)
    face2 = Sk.add_face(lines)
    set_group(face.all_connected)

  end


end