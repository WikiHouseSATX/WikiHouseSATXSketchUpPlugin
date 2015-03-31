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

  def init_board(top_connector: nil, bottom_connector: nil, left_connector: nil, right_connector: nil)
    @top_side_points = @right_side_points = @bottom_side_points = @left_side_points = []
    @top_connector = top_connector ? top_connector : WikiHouse::NoneConnector.new()
    @right_connector = right_connector ? right_connector : WikiHouse::NoneConnector.new()
    @bottom_connector = bottom_connector ? bottom_connector : WikiHouse::NoneConnector.new()
    @left_connector = left_connector ? left_connector : WikiHouse::NoneConnector.new()


  end

  def points
    [@top_side_points[0...-1], @right_side_points[0...-1], @bottom_side_points[0...-1], @left_side_points[0...-1]].flatten(1)
  end

  def parent_part
    raise ScriptError, "You must define a parent"
  end

  def length
    parent_part.send(@length_method)
  end

  def width
    parent_part.send(@width_method)
  end


  def c1
    @origin.dup
  end

  def c2
    [c1.x + width, c1.y, c1.z]
  end

  def c3
    [c1.x + width, c1.y - length, c1.z]
  end

  def c4
    [c1.x, c1.y - length, c1.z]
  end

  def top_bottom_builder(top: :tab, bottom: :tab)
    raise ArgumentError, "Only tab and slot are supported" if ![:tab, :slot].include?(top) || ![:tab, :slot].include?(bottom)

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

  def build_slots(connector: nil, start_pt: nil, end_pt: nil)

    total_length = top?(connector) || bottom?(connector) ? width : length
    c5 = start_pt
    c6 = end_pt


    slot_size = connector.size
    slot_count = connector.count

    if top?(connector) || bottom?(connector)
      total_length -= thickness unless @right_connector.none?
      total_length -= thickness unless @left_connector.none?
    elsif left?(connector) || right?(connector)
      total_length -= thickness unless @top_connector.none?
      total_length -= thickness unless @bottom_connector.none?
    end

    slot_points = [c5]
    section_width = total_length/slot_count.to_f
    slot_count.times do |i|
      if right?(connector)

        start_y = c5.y - (i * section_width)

        mid_point = start_y - section_width/2.0

        start_slot = mid_point + slot_size/2.0
        end_slot = mid_point - slot_size/2.0


        pc1 = [c5.x - thickness, start_slot, c5.z]
        pc2 = [c5.x, start_slot, c5.z]
        pc3 = [c5.x, end_slot, c5.z]
        pc4 = [c5.x - thickness, end_slot, c5.z]


      elsif left?(connector)
        start_y = c5.y + (i * section_width)

        mid_point = start_y + section_width/2.0

        start_slot = mid_point + slot_size/2.0
        end_slot = mid_point - slot_size/2.0


        pc4 = [c5.x, end_slot, c5.z]
        pc3 = [c5.x + thickness, end_slot, c5.z]
        pc2 = [pc3.x, start_slot, c5.z]
        pc1 = [c5.x, start_slot, c5.z]


      elsif top?(connector)
        start_x = c5.x + (i * section_width)

        mid_point = start_x + section_width/2.0

        start_slot = mid_point + slot_size/2.0
        end_slot = mid_point - slot_size/2.0


        pc4 = [end_slot, c5.y, c5.z]
        pc3 = [end_slot, c5.y - thickness, c5.z]
        pc2 = [start_slot, pc3.y, c5.z]
        pc1 = [start_slot, c5.y, c5.z]


      elsif bottom?(connector)
        start_x = c5.x - (i * section_width)

        mid_point = start_x - section_width/2.0

        start_slot = mid_point + slot_size/2.0
        end_slot = mid_point - slot_size/2.0


        pc1 = [start_slot, c5.y + thickness, c5.z]
        pc2 = [start_slot, c5.y, c5.z]
        pc3 = [end_slot, c5.y, c5.z]
        pc4 = [end_slot, c5.y + thickness, c5.z]
      end
      if top?(connector) || left?(connector)
        current_points = [pc4, pc3, pc2, pc1]
      else
        current_points = [pc2, pc1, pc4, pc3]
      end
      WikiHouse::Fillet.by_points(current_points, 0, 1, 2)
      WikiHouse::Fillet.by_points(current_points, 5, 4, 3, reverse_it: true)
      slot_points.concat(current_points)

    end
    slot_points << c6

  end

  def side_name(connector)
    return :top if top?(connector)
    return :left if left?(connector)
    return :right if right?(connector)
    return :bottom if bottom?(connector)
    nil
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

  def build_top_side
    if @top_connector.slot?
      top_first = c1
      top_last = c2
      @top_side_points = build_slots(connector: @top_connector,
                                     start_pt: top_first,
                                     end_pt: top_last)
    elsif @top_connector.tab?
    else
      @top_side_points = [c1, c2]

    end

  end

  def build_right_side
    if @right_connector.slot?

      @right_side_points = build_slots(connector: @right_connector,
                                       start_pt: @top_side_points.last,
                                       end_pt: @bottom_side_points.first)
    elsif @right_connector.tab?
    else
      @right_side_points = [c2, c3]
    end
  end

  def build_bottom_side
    if @bottom_connector.slot?
      bottom_first = c3
      bottom_last = c4
      @bottom_side_points = build_slots(connector: @bottom_connector,
                                        start_pt: bottom_first,
                                        end_pt: bottom_last)
    elsif @bottom_connector.tab?
    else
      @bottom_side_points = [c3, c4]
    end
  end

  def build_left_side
    if @left_connector.slot?
      @left_side_points = build_slots(connector: @left_connector,
                                      start_pt: @bottom_side_points.last,
                                      end_pt: @top_side_points.first)
    elsif @left_connector.tab?
    else
      @left_side_points = [c4, c1]
    end
  end

  def top?(c)
    c == @top_connector
  end

  def left?(c)
    c == @left_connector
  end

  def right?(c)
    c == @right_connector
  end

  def bottom?(c)
    c == @bottom_connector
  end

  def draw!

    build_top_side
    build_bottom_side

    build_right_side
    build_left_side

    #what about pockets
    lines = Sk.draw_all_points(points)
    face = Sk.add_face(lines)
    set_material(face)

    make_part_right_thickness(face)
    face2 = Sk.add_face(lines)

    set_group(face.all_connected)
    mark_primary_face!(face)
  end

end
