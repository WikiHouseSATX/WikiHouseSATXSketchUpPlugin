class WikiHouse::ZPegBottomConnector < WikiHouse::PocketConnector

  attr_reader :with_top_slot, :top_slot_width_in_t, :top_slot_length_in_t

  def initialize(thickness: nil, count: 1, with_top_slot: true, top_slot_width_in_t: nil, top_slot_length_in_t: nil)
    super(length_in_t: 8, width_in_t: 4, thickness: thickness, rows: 1, count: count)
    @with_top_slot = with_top_slot
    if @with_top_slot
      @top_slot_width_in_t = top_slot_width_in_t ? top_slot_width_in_t : self.class.standard_width_in_t
      @top_slot_length_in_t = top_slot_length_in_t ? top_slot_length_in_t : self.class.standard_length_in_t

    end
  end

  def draw!(bounding_origin: nil, part_length: nil, part_width: nil)

    if with_top_slot
      length_unit = top_slot_length
      width_unit = top_slot_width
    else
      length_unit = length
      width_unit = width
    end

    length_gap = Sk.round((part_length - (count * length_unit))/(count.to_f + 1.0))

    width_gap = Sk.round((part_width - (rows * width_unit))/(rows.to_f + 1.0))


    pockets_list = []
    rows.times do |row|
      base_x = ((row + 1) * width_gap) + (row * width_unit)

      count.times do |i|
        base_y = ((i + 1) * length_gap) + (i * length_unit)
        pockets_list << draw_pocket!(location: [bounding_origin.x + base_x, bounding_origin.y - base_y, bounding_origin.z])
      end
    end

    pockets_list

  end

  def top_slot_length
    with_top_slot ? top_slot_length_in_t * thickness : 0
  end

  def top_slot_width
    with_top_slot ? top_slot_width_in_t * thickness : 0
  end

  def draw_pocket!(location: nil)
    #assumes location is upper left corner

    #the centering of the pocket is a little weird - we only care about the
    # pocket on the left c1,c7,c5,c6
    if with_top_slot
      half_width_top = top_slot_width/2.0
      half_width_peg_slot = width/2.0

      t1 = [location.x, location.y, location.z]
      t2 = [t1.x + top_slot_width, t1.y, t1.z]
      t3 = [t2.x, t2.y - top_slot_length, t1.z]
      t4 = [t1.x, t3.y, t1.z]
      c1 = [location.x + half_width_top - half_width_peg_slot/2.0, t4.y, location.z]

    else
      c1 = [location.x, location.y, location.z]
    end


    c2 = [c1.x + width, c1.y, location.z]
    c3 = [c2.x, c2.y - length, location.z]
    c4 = [c3.x - width/2.0, c3.y, location.z]
    c5 = [c4.x, c1.y - length/2.0, location.z]
    c6 = [c1.x, c5.y, location.z]


    #handle fillet of this a little manually
    points = []
    if WikiHouse.machine.fillet?
      if with_top_slot
        points.concat(WikiHouse::Fillet.upper_to_right(t1))
        points.concat(WikiHouse::Fillet.upper_to_left(t2))
        if t3 != c2
          points.concat(WikiHouse::Fillet.lower_to_left(t3))
          points.concat([c2])
        else
          points.concat([c2])
        end

      else
        points.concat(WikiHouse::Fillet.upper_to_right(c1))
        points.concat(WikiHouse::Fillet.upper_to_left(c2))
      end

      points.concat(WikiHouse::Fillet.stem_to_right(c3))
      points.concat(WikiHouse::Fillet.stem_to_left(c4))
      points.concat([c5])
      points.concat(WikiHouse::Fillet.lower_to_right(c6))
      if with_top_slot
        points.concat([c1])
        points.concat(WikiHouse::Fillet.lower_to_right(t4))
      end

    else
      if with_top_slot
        points = [t1, t2, c2, c3, c4, c5, c6, c1, t4]
      else
        points = [c1, c2, c3, c4, c5, c6]
      end

    end


    pocket_lines = Sk.draw_all_points(points)
    pocket_lines.each { |e| mark_inside_edge!(e) }
    pocket_face = Sk.add_face(pocket_lines)
    pocket_face.erase!
    pocket_lines
  end

  def rows
    1
  end


  def zpeg?
    true
  end

  def zpeg_bottom?
    true
  end

  def name
    :zpeg_bottom
  end
end