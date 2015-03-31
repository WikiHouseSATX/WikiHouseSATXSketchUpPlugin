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
    section_gap = Sk.round((total_length - (slot_count * slot_size))/(slot_count.to_f + 1.0))

    slot_count.times do |i|
      starting_length = ((i + 1) * section_gap) + (i * slot_size) + thickness
      if right?(connector)

        start_slot =  c5.y - starting_length
        end_slot = start_slot - slot_size


        pc1 = [c5.x - thickness, start_slot, c5.z]
        pc2 = [c5.x, start_slot, c5.z]
        pc3 = [c5.x, end_slot, c5.z]
        pc4 = [c5.x - thickness, end_slot, c5.z]


      elsif left?(connector)

        start_slot = c5.y + starting_length
        end_slot = start_slot + slot_size


        pc4 = [c5.x, start_slot, c5.z]
        pc3 = [c5.x + thickness, start_slot, c5.z]
        pc2 = [pc3.x, end_slot, c5.z]
        pc1 = [c5.x, end_slot, c5.z]


      elsif top?(connector)

        start_slot = c5.x + starting_length

        end_slot = start_slot + slot_size


        pc4 = [start_slot, c5.y, c5.z]
        pc3 = [start_slot, c5.y - thickness, c5.z]
        pc2 = [end_slot, pc3.y, c5.z]
        pc1 = [end_slot, c5.y, c5.z]


      elsif bottom?(connector)

        start_slot =  c5.x - starting_length
        end_slot = start_slot - slot_size


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
   #   WikiHouse::Fillet.by_points(current_points, 0, 1, 2)
   # WikiHouse::Fillet.by_points(current_points, 5, 4, 3, reverse_it: true)
      slot_points.concat(current_points)

    end
    slot_points << c6

  end

  def build_tabs(connector: nil, start_pt: nil, end_pt: nil)

    total_length = top?(connector) || bottom?(connector) ? width : length
    c5 = start_pt
    c6 = end_pt


    tab_size = connector.size
    tab_count = connector.count

    if top?(connector) || bottom?(connector)
      total_length -= thickness unless @right_connector.none?
      total_length -= thickness unless @left_connector.none?
    elsif left?(connector) || right?(connector)
      total_length -= thickness unless @top_connector.none?
      total_length -= thickness unless @bottom_connector.none?
    end



    tab_points = [c5]
    section_width = total_length/(tab_count.to_f + 1.0)
    tab_count.times do |i|
      current_section_width = (i + 1) * section_width
      if right?(connector)

        start_y = c5.y - current_section_width - thickness

        mid_point = start_y# - section_width/2.0

        start_tab = mid_point + tab_size/2.0
        end_tab = mid_point - tab_size/2.0


        pc1 = [c5.x - thickness, start_tab, c5.z]
        pc2 = [c5.x, start_tab, c5.z]
        pc3 = [c5.x, end_tab, c5.z]
        pc4 = [c5.x - thickness, end_tab, c5.z]


      elsif left?(connector)
        start_y = c5.y + current_section_width + thickness

        mid_point = start_y #+ section_width/2.0

        start_tab = mid_point + tab_size/2.0
        end_tab = mid_point - tab_size/2.0


        pc4 = [c5.x, end_tab, c5.z]
        pc3 = [c5.x + thickness, end_tab, c5.z]
        pc2 = [pc3.x, start_tab, c5.z]
        pc1 = [c5.x, start_tab, c5.z]


      elsif top?(connector)
        start_x = c5.x + current_section_width + thickness

        mid_point = start_x #+ section_width/2.0

        start_tab = mid_point + tab_size/2.0
        end_tab = mid_point - tab_size/2.0


        pc4 = [end_tab, c5.y, c5.z]
        pc3 = [end_tab, c5.y - thickness, c5.z]
        pc2 = [start_tab, pc3.y, c5.z]
        pc1 = [start_tab, c5.y, c5.z]


      elsif bottom?(connector)
        start_x = c5.x - current_section_width - thickness

        mid_point = start_x #- section_width/2.0

        start_tab = mid_point + tab_size/2.0
        end_tab = mid_point - tab_size/2.0


        pc1 = [start_tab, c5.y + thickness, c5.z]
        pc2 = [start_tab, c5.y, c5.z]
        pc3 = [end_tab, c5.y, c5.z]
        pc4 = [end_tab, c5.y + thickness, c5.z]
      end
      if top?(connector) || left?(connector)
        current_points = [pc4, pc3, pc2, pc1]
      else
        current_points = [pc2, pc1, pc4, pc3]
      end
      WikiHouse::Fillet.by_points(current_points, 0, 1, 2)
      WikiHouse::Fillet.by_points(current_points, 5, 4, 3, reverse_it: true)
      tab_points.concat(current_points)

    end
    tab_points << c6




  end

  def side_name(connector)
    return :top if top?(connector)
    return :left if left?(connector)
    return :right if right?(connector)
    return :bottom if bottom?(connector)
    nil
  end


  def build_top_side
    puts "Before #{Sk.point_to_s(c1)}"
    top_first = c1
    top_last = c2
    if @top_connector.slot?

      @top_side_points = build_slots(connector: @top_connector,
                                     start_pt: top_first,
                                     end_pt: top_last)
    elsif @top_connector.tab?
      @top_side_points = build_tabs(connector: @top_connector,
                                    start_pt: top_first,
                                    end_pt: top_last)
    else
      @top_side_points = [top_first, top_last]

    end
    puts "After #{Sk.point_to_s(@top_side_points[0])}"
  end

  def build_right_side
    puts "Before #{Sk.point_to_s(@top_side_points[0])}"
    if @right_connector.slot?

      @right_side_points = build_slots(connector: @right_connector,
                                       start_pt: @top_side_points.last,
                                       end_pt: @bottom_side_points.first)
    elsif @right_connector.tab?
      @right_side_points = build_tabs(connector: @right_connector,
                                      start_pt: @top_side_points.last,
                                      end_pt: @bottom_side_points.first)
      @top_side_points[@top_side_points.length - 1] = @right_side_points.first
      @bottom_side_points[0] = @right_side_points.last
    else
      @right_side_points = [c2, c3]
    end
    puts "After #{Sk.point_to_s(@top_side_points[0])}"
  end

  def build_bottom_side
    puts "Before #{Sk.point_to_s(@top_side_points[0])}"
    bottom_first = c3
    bottom_last = c4
    if @bottom_connector.slot?

      @bottom_side_points = build_slots(connector: @bottom_connector,
                                        start_pt: bottom_first,
                                        end_pt: bottom_last)
    elsif @bottom_connector.tab?
      @bottom_side_points = build_tabs(connector: @bottom_connector,
                                       start_pt: bottom_first,
                                       end_pt: bottom_last)
    else
      @bottom_side_points = [bottom_first, bottom_last]
    end
    puts "After #{Sk.point_to_s(@top_side_points[0])}"
  end

  def build_left_side
    puts "Before #{Sk.point_to_s(@top_side_points[0])}"
    if @left_connector.slot?
      @left_side_points = build_slots(connector: @left_connector,
                                      start_pt: @bottom_side_points.last,
                                      end_pt: @top_side_points.first)
    elsif @left_connector.tab?
      @left_side_points = build_tabs(connector: @left_connector,
                                     start_pt: @bottom_side_points.last,
                                     end_pt: @top_side_points.first)
      @bottom_side_points[@bottom_side_points.length - 1] = @left_side_points.first
      @top_side_points[0] = @left_side_points.last

    else
      @left_side_points = [c4, c1]
    end
    puts "After #{Sk.point_to_s(@top_side_points[0])}"
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
