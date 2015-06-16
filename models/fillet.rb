class WikiHouse::Fillet
  def self.bit_radius
    WikiHouse.machine.bit_radius
  end

  def self.upper_to_left_side(corner)
    pt2 = [corner.x, Sk.round(corner.y - 2 * bit_radius), corner.z]
    pt3 = [Sk.round(corner.x -  bit_radius), pt2.y, corner.z]
    pt4 = [pt3.x, corner.y, corner.z]
    [pt2, pt3, pt4]
  end
  def self.upper_to_right_side(corner)

    pt2 = [corner.x +  bit_radius, corner.y , corner.z]
    pt3 = [pt2.x, Sk.round(pt2.y - 2 * bit_radius), corner.z]
    pt4 = [corner.x, pt3.y, corner.z]
    [pt2, pt3, pt4]
  end
  def self.lower_to_left_side(corner)

    pt2 = [Sk.round(corner.x -  bit_radius), corner.y, corner.z]
    pt3 = [pt2.x, Sk.round(pt2.y + 2 *  bit_radius), corner.z]
    pt4 = [corner.x, pt3.y, corner.z]
    [pt2, pt3, pt4]
  end
  def self.lower_to_right_side(corner)

    pt2 = [corner.x, Sk.round(corner.y + 2 * bit_radius), corner.z]
    pt3 = [pt2.x + bit_radius, pt2.y, corner.z]
    pt4 = [pt3.x, corner.y, corner.z]
    [pt2, pt3, pt4]
  end
  def self.upper_to_right(corner)

    pt2 = [corner.x, Sk.round(corner.y + bit_radius), corner.z]
    pt3 = [Sk.round(corner.x + 2 * bit_radius), pt2.y, corner.z]
    pt4 = [pt3.x, corner.y, corner.z]
    [pt2, pt3, pt4]
  end

  def self.upper_to_left(corner)

    pt1 = [Sk.round(corner.x - 2 * bit_radius), corner.y, corner.z]
    pt2 = [pt1.x, Sk.round(pt1.y + bit_radius), corner.z]
    pt3 = [corner.x, pt2.y, corner.z]

    [pt1, pt2, pt3]


  end

  def self.lower_to_right(corner)
    pt1 = [Sk.round(corner.x + 2 * bit_radius), corner.y, corner.z]
    pt2 = [pt1.x, Sk.round(pt1.y - bit_radius), corner.z]
    pt3 = [corner.x, pt2.y, corner.z]

    [pt1, pt2, pt3]
  end

  def self.stem_to_right(corner)
    pt1 = [corner.x, Sk.round(corner.y + 2 * bit_radius), corner.z]
    pt2 = [Sk.round(pt1.x + bit_radius), pt1.y, corner.z]
    pt3 = [pt2.x, corner.y, corner.z]

    [pt1, pt2, pt3]

  end

  def self.stem_to_left(corner)
    pt1 = [Sk.round(corner.x - bit_radius), Sk.round(corner.y + 2 * bit_radius), corner.z]
    pt2 = [corner.x, pt1.y, corner.z]
    pt4 = [pt1.x, corner.y, corner.z]

    [pt4, pt1, pt2]

  end

  def self.lower_to_left(corner)

    pt2 = [corner.x, Sk.round(corner.y - bit_radius), corner.z]
    pt3 = [Sk.round(corner.x - 2 * bit_radius), pt2.y, corner.z]
    pt4 = [pt3.x, corner.y, corner.z]
    [pt2, pt3, pt4]

  end


  def self.t_pocket_by_points(point_list)
    return point_list unless WikiHouse.machine.fillet?
    raise ArgumentError, "Expected only 8 corners" if point_list.length != 8
    pt1 = point_list[0]
    pt2 = point_list[1]
    pt3 = point_list[2]
    pt4 = point_list[3]
    pt5 = point_list[4]
    pt6 = point_list[5]
    pt7 = point_list[6]
    pt8 = point_list[7]

    point_list.clear
    point_list.concat(upper_to_right(pt1))
    point_list.concat(upper_to_left(pt2))
    point_list.concat(lower_to_left(pt3))
    point_list.concat([pt4])
    point_list.concat(stem_to_right(pt5))
    point_list.concat(stem_to_left(pt6))
    point_list.concat([pt7])
    point_list.concat(lower_to_right(pt8))


    point_list


  end

  def self.pocket_by_points(point_list)
    return point_list unless WikiHouse.machine.fillet?
    raise ArgumentError, "Expected only 4 corners" if point_list.length != 4
    pt1 = point_list[0]
    pt2 = point_list[1]
    pt3 = point_list[2]
    pt4 = point_list[3]


    if (Sk.round(pt2.x.abs - pt1.x.abs) > Sk.round(pt4.y.abs - pt1.y.abs))
      point_list.clear
      point_list.concat(upper_to_right(pt1))
      point_list.concat(upper_to_left(pt2))
      point_list.concat(lower_to_left(pt3))
      point_list.concat(lower_to_right(pt4))
    else
      point_list.clear

      point_list.concat(upper_to_left_side(pt1))
      point_list.concat(upper_to_right_side(pt2))
      point_list.concat(lower_to_right_side(pt3))
      point_list.concat(lower_to_left_side(pt4))

    end


    point_list


  end

  def self.by_points(point_list, pt1_index, pt2_index, pt3_index, reverse_it: false,
      angel_in_degrees: 90)
    return point_list unless WikiHouse.machine.fillet?
    raise ArgumentError, "Angle not supported" if angel_in_degrees != 90
    pt1 = point_list[pt1_index]
    pt2 = point_list[pt2_index]
    pt3 = point_list[pt3_index]
    #  puts "1: #{pt1} 2: #{pt2} 3: #{pt3}"
    slope = Sk.slope(pt1.x, pt1.y, pt2.x, pt2.y)
    raise ArgumentError, "Don't know how to handle slopes #{slope}" unless slope.nil? || slope == 0.0
    new_points_list = []

    [pt3_index, pt2_index, pt1_index].sort.reverse.each { |i| point_list.delete_at(i) }
    insert_point = reverse_it ? pt3_index : pt1_index


    new_points_list << pt1
    #    new_points_list << pt2
    if pt1.x == pt2.x
      if pt1.y > pt2.y
        pt2_1 = [pt2.x, Sk.round(pt2.y - bit_radius), pt2.z]
        if pt3.x < pt2.x
          #     puts "Here 5"
          pt2_2 = [pt2.x - 2 * bit_radius, pt2_1.y, pt2.z]
          pt2_3 = [pt2_2.x, pt2.y, pt2.z]
        else
          #    puts "Here 6"
          pt2_2 = [pt2.x + 2 * bit_radius, pt2_1.y, pt2.z]
          pt2_3 = [pt2_2.x, pt2.y, pt2.z]
        end

      else
        pt2_1 = [pt2.x, Sk.round(pt2.y + bit_radius), pt2.z]
        if pt3.x < pt2.x
          #   puts "Here 7"
          pt2_2 = [pt2.x - 2 * bit_radius, pt2_1.y, pt2.z]
          pt2_3 = [pt2_2.x, pt2.y, pt2.z]
        else
          #   puts "Here 7"
          pt2_2 = [pt2.x + 2 * bit_radius, pt2_1.y, pt2.z]
          pt2_3 = [pt2_2.x, pt2.y, pt2.z]
        end
      end

    elsif pt1.x > pt2.x
      pt2_1 = [Sk.round(pt2.x - bit_radius), pt2.y, pt2.z]
      if pt3.y < pt2.y
        #  puts "Here 1"
        pt2_2 = [pt2_1.x, pt2.y - 2 * bit_radius, pt2.z]
        pt2_3 = [pt2.x, pt2_2.y, pt2.z]
      else
        #  puts "Here 2"
        pt2_2 = [pt2_1.x, pt2.y + 2 * bit_radius, pt2.z]
        pt2_3 = [pt2.x, pt2_2.y, pt2.z]
      end
    else
      pt2_1 = [Sk.round(pt2.x + bit_radius), pt2.y, pt2.z]
      if pt3.y < pt2.y
        #    puts "Here 3"
        pt2_2 = [pt2_1.x, pt2.y - 2 * bit_radius, pt2.z]
        pt2_3 = [pt2.x, pt2_2.y, pt2.z]
      else
        #   puts "Here 4"
        pt2_2 = [pt2_1.x, pt2.y + 2 * bit_radius, pt2.z]
        pt2_3 = [pt2.x, pt2_2.y, pt2.z]
      end


    end
    new_points_list << pt2_1
    new_points_list << pt2_2
    new_points_list << pt2_3
    new_points_list << pt3

    new_points_list.reverse! if reverse_it
    point_list.insert(insert_point, *new_points_list)
    point_list
  end
end
