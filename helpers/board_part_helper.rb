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

  def init_board(top_connector: nil, bottom_connector: nil, left_connector: nil, right_connector: nil, face_connector: nil)
    @top_side_points = @right_side_points = @bottom_side_points = @left_side_points = []
    @top_connector = top_connector ? top_connector : WikiHouse::NoneConnector.new()
    @right_connector = right_connector ? right_connector : WikiHouse::NoneConnector.new()
    @bottom_connector = bottom_connector ? bottom_connector : WikiHouse::NoneConnector.new()
    @left_connector = left_connector ? left_connector : WikiHouse::NoneConnector.new()
    @face_connector = face_connector ? face_connector : WikiHouse::NoneConnector.new()


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


    slot_length = connector.length
    slot_count = connector.count
    tabs_too_big?(total_length, slot_count * slot_length, connector: connector)
    starting_thickness = 0
    if top?(connector) || bottom?(connector)
      if @right_connector.slot? || @right_connector.tab?
        total_length -= thickness
        starting_thickness = thickness
      end

      if @left_connector.slot? || @left_connector.tab?
        total_length -= thickness
        starting_thickness = thickness
      end
    elsif left?(connector) || right?(connector)
      if @top_connector.slot? || @top_connector.tab?
        total_length -= thickness
        starting_thickness = thickness
      end
      if @bottom_connector.slot? || @bottom_connector.tab?
        total_length -= thickness
        starting_thickness = thickness
      end
    end

    slot_points = [c5]


    section_gap = Sk.round((total_length - (slot_count * slot_length))/(slot_count.to_f + 1.0))

    slot_count.times do |i|
      starting_length = ((i + 1) * section_gap) + (i * slot_length) + starting_thickness
      if right?(connector)

        start_slot = c5.y - starting_length
        end_slot = start_slot - slot_length


        pc1 = [c5.x - thickness, start_slot, c5.z]
        pc2 = [c5.x, start_slot, c5.z]
        pc3 = [c5.x, end_slot, c5.z]
        pc4 = [c5.x - thickness, end_slot, c5.z]


      elsif left?(connector)

        start_slot = c5.y + starting_length
        end_slot = start_slot + slot_length


        pc4 = [c5.x, start_slot, c5.z]
        pc3 = [c5.x + thickness, start_slot, c5.z]
        pc2 = [pc3.x, end_slot, c5.z]
        pc1 = [c5.x, end_slot, c5.z]


      elsif top?(connector)

        start_slot = c5.x + starting_length

        end_slot = start_slot + slot_length


        pc4 = [start_slot, c5.y, c5.z]
        pc3 = [start_slot, c5.y - thickness, c5.z]
        pc2 = [end_slot, pc3.y, c5.z]
        pc1 = [end_slot, c5.y, c5.z]


      elsif bottom?(connector)

        start_slot = c5.x - starting_length
        end_slot = start_slot - slot_length


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

  def build_tabs(connector: nil, start_pt: nil, end_pt: nil)
    total_length = top?(connector) || bottom?(connector) ? width : length
    c5 = start_pt
    c6 = end_pt


    tab_length = connector.length
    tab_count = connector.count
    tabs_too_big?(total_length, tab_count * tab_length, connector: connector)

    starting_thickness = 0
    if top?(connector) || bottom?(connector)
      if @right_connector.slot? || @right_connector.tab?
        total_length -= thickness
        starting_thickness = thickness
      end

      if @left_connector.slot? || @left_connector.tab?
        total_length -= thickness
        starting_thickness = thickness
      end
    elsif left?(connector) || right?(connector)
      if @top_connector.slot? || @top_connector.tab?
        total_length -= thickness
        starting_thickness = thickness
      end
      if @bottom_connector.slot? || @bottom_connector.tab?
        total_length -= thickness
        starting_thickness = thickness
      end
    end
    if right?(connector)
      if c5.x == c2.x
        c5.x -= thickness

      end
      c6.x = c5.x
    elsif left?(connector)
      if c5.x == c4.x
        c5.x += thickness

      end
      c6.x = c5.x
    elsif top?(connector)
      if c5.y == c1.y
        c5.y -= thickness

      end
      c6.y = c5.y
    elsif bottom?(connector)
      if c5.y == c3.y
        c5.y += thickness

      end
      c6.y = c5.y
    end

    tab_points = [c5]
    section_gap = Sk.round((total_length - (tab_count * tab_length))/(tab_count.to_f + 1.0))

    tab_count.times do |i|
      starting_length = ((i + 1) * section_gap) + (i * tab_length) + starting_thickness

      if right?(connector)

        start_tab = c5.y - starting_length
        end_tab = start_tab - tab_length


        pc1 = [c5.x, start_tab, c5.z]
        pc2 = [c5.x + thickness, start_tab, c5.z]
        pc3 = [c5.x + thickness, end_tab, c5.z]
        pc4 = [c5.x, end_tab, c5.z]


      elsif left?(connector)

        start_tab = c5.y + starting_length
        end_tab = start_tab + tab_length


        pc4 = [c5.x - thickness, start_tab, c5.z]
        pc3 = [c5.x, start_tab, c5.z]
        pc2 = [pc3.x, end_tab, c5.z]
        pc1 = [c5.x - thickness, end_tab, c5.z]


      elsif top?(connector)

        start_tab = c5.x + starting_length

        end_tab = start_tab + tab_length


        pc4 = [start_tab, c5.y + thickness, c5.z]
        pc3 = [start_tab, c5.y, c5.z]
        pc2 = [end_tab, pc3.y, c5.z]
        pc1 = [end_tab, c5.y + thickness, c5.z]


      elsif bottom?(connector)

        start_tab = c5.x - starting_length
        end_tab = start_tab - tab_length


        pc1 = [start_tab, c5.y, c5.z]
        pc2 = [start_tab, c5.y - thickness, c5.z]
        pc3 = [end_tab, c5.y - thickness, c5.z]
        pc4 = [end_tab, c5.y, c5.z]
      end
      if top?(connector) || left?(connector)
        current_points = [pc3, pc4, pc1, pc2]
      else
        current_points = [pc1, pc2, pc3, pc4]
      end

       tab_points.concat(current_points)
      WikiHouse::Fillet.by_points(tab_points, tab_points.length - 3, tab_points.length - 4, tab_points.length - 5, reverse_it: true)

      if i > 0

        WikiHouse::Fillet.by_points(tab_points, tab_points.length - 8, tab_points.length - 7, tab_points.length - 6)

      end

    end

    tab_points << c6

    WikiHouse::Fillet.by_points(tab_points, tab_points.length - 3, tab_points.length - 2, tab_points.length - 1)
    tab_points
  end

  def side_name(connector)
    return :top if top?(connector)
    return :left if left?(connector)
    return :right if right?(connector)
    return :bottom if bottom?(connector)
    return :face if face?(connector)
    nil
  end

  def tabs_too_big?(side_length, tab_total_length, connector: nil)
    raise ScriptError, "Too Many Tabs or They Are Too Big Max is #{side_length} #{connector ? " for #{side_name(connector)}" : ""}" if tab_total_length > side_length
    true
  end

  def build_top_side
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
  end

  def build_right_side
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
      @right_side_points = [@top_side_points.last, @bottom_side_points.first]
    end
  end

  def build_bottom_side
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
  end

  def build_left_side
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
      @left_side_points = [@bottom_side_points.last, @top_side_points.first]
    end
  end

  def face?(c)
    c == @face_connector
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

  def draw_pockets!

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

    build_top_side
    build_bottom_side

    build_right_side
    build_left_side

    lines = Sk.draw_all_points(points)

    unless @face_connector.none?

      pockets_list = draw_pockets!
    end

    face = Sk.add_face(lines)
    set_material(face)

    unless @face_connector.none?
      #erase the faces
      # rib_pockets_list.each do |sp|
      #   pocket_face = Sk.add_face(sp)
      #   pocket_face.erase!
      # end
    end

    make_part_right_thickness(face)
    face2 = Sk.add_face(lines)

    set_group(face.all_connected)
    mark_primary_face!(face)
  end

  def set_default_properties
    mark_cutable!
  end
end
