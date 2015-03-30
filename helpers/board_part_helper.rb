module WikiHouse::BoardPartHelper


  def self.tag_dictionary
    "WikiHouse"
  end

  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def tag_dictionary
      WikiHouse::PartHelper.tag_dictionary
    end
  end

  def parent_part
    raise ScriptError, "You must define a parent"
  end

  def bottom_side_length
    parent_part.bottom_side_length
  end

  def left_side_length
    parent_part.left_side_length
  end

  def tab_width
    parent_part.tab_width
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

  def top_bottom_builder(top: :tab, bottom: :tab)
    raise ArgumentError, "Only tab and slot are supported" if ![:tab, :slot].include?(top) || ![:tab, :slot].include?(bottom)
    puts "Top #{top} Bottom #{bottom}"
    #Top Tab
    z = c1.z
    high_y = c1.y
    low_y = high_y - thickness


    c5 = [c1.x, low_y, z]
    c6 = [c1.x + bottom_tab_start, low_y, z]
    c7 = [c6.x, high_y, z]
    c8 = [c7.x + tab_width, high_y, z]
    c9 = [c8.x, low_y, z]
    c10 =[c2.x, low_y, z]


    high_y = c4.y

    low_y = high_y + thickness


    c11 = [c3.x, low_y, z]
    c12 = [c8.x, low_y, z]
    c13 = [c8.x, high_y, z]
    c14 = [c6.x, high_y, z]
    c15 = [c6.x, low_y, z]
    c16 = [c4.x, low_y, z]

    pts = []
    if top == :tab
      pts << [c5, c6, c7, c8, c9, c10]
    else

      pts << [c1, c7, c6, c9, c8, c2]
    end
    if bottom == :tab
      pts << [c11, c12, c13, c14, c15, c16]
    else

      pts << [c3, c13, c12, c15, c14, c4]
    end
    pts.flatten!(1)
    if top == :tab
      WikiHouse::Fillet.by_points(pts, 2, 1, 0, reverse_it: true)
      WikiHouse::Fillet.by_points(pts, 5, 6, 7)

    else
      WikiHouse::Fillet.by_points(pts, 1, 2, 3)
      WikiHouse::Fillet.by_points(pts, 6, 5, 4, reverse_it: true)
    end
    if bottom == :tab
      WikiHouse::Fillet.by_points(pts, 12, 11, 10, reverse_it: true)
      WikiHouse::Fillet.by_points(pts, 15, 16, 17)
    else
      WikiHouse::Fillet.by_points(pts, 11, 12, 13)
      WikiHouse::Fillet.by_points(pts, 16, 15, 14, reverse_it: true)
    end


    Sk.draw_all_points(pts)


  end

  def right_slots
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
      WikiHouse::Fillet.by_points(points, 5, 4, 3, reverse_it: true)

      lines.concat(Sk.draw_points(points))
      Sk.erase_line(pc2, pc3)

    end
    lines
  end
  def side_tabs(orientation: :left)
    #need a generic way to handle building multiple tabs on the side of the board(or top)
    #need a gerneic way to handle builidng multiple slots on teh side of the board (or top)
  end
  def left_tabs(top: :slot, bottom: :slot)

    if top == :slot

      c5 = c1
      c6 = [c5.x + thickness, c5.y - thickness, c5.z]
    else
      c5 = [c1.x, c1.y - thickness, c1.z]
      c6 = [c5.x + thickness, c5.y, c5.z]

    end
    c1_5 = [c5.x + thickness, c5.y, c5.z]
    if top == :slot
      c9 = c4

    else
      c9 = [c4.x, c4.y + thickness, c1.z]
    end

    c4_5 = [c9.x + thickness, c9.y, c9.z]
    lines = []





    c7 = [c6.x, c6.y - left_side_length + (2 * thickness), c6.z]
    c8 = [c5.x, c7.y, c5.z]

    Sk.erase_line(c5, c9)
    Sk.erase_line(c5, c1_5)
    Sk.erase_line(c9, c4_5)



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

      if last_point_1.nil?
        WikiHouse::Fillet.by_points(points, 2, 1, 0, reverse_it: true)

      else
        WikiHouse::Fillet.by_points(points, 3, 2, 1, reverse_it: true)
        WikiHouse::Fillet.by_points(points, 0, 1, 2)

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


  def top_bottom_tabs
    top_bottom_builder(top: :tab, bottom: :tab)
  end

  def top_bottom_slots
    top_bottom_builder(top: :slot, bottom: :slot)
  end

end
