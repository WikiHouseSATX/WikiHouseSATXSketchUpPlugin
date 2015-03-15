class WikiHouse::SJoint < WikiHouse::Joint
  include WikiHouse::DrawingHelper
  # This class was based on the original S-Joint 3.4
  #  We made some changes
  # The parallelogram  had 77.5 and 102.5 as the angles - we changed it to 71.45 degrees
  # The width of the parallelogram  was slightly less than the  width of the baord - we made it the width of the baord


  def self.version
    3.5
  end

  def angle_in_degrees
    71.45
  end

  def join!(face, first_point, last_point, orientation)
    face_group = face.parent

    if first_point.y < last_point.y
      start = last_point
      finish = first_point
    else
      start = first_point
      finish = last_point
    end
    #start & finish is a straight line down the middle of the part.
    #need to add kind of joint
    puts "I'm an SJoint" if WikiHouse::LOG_ON
    #Mid point Line

    # all_connected = face.all_connected
    # puts "I have #{all_connected.count}"
    # puts "Type    Id    Start  End"
    # all_connected.each do |i|
    #   next if i.typename == "Face"
    #   start_on = i.on?(start)
    #   end_on = i.on?(finish)
    #   puts "#{i.typename} #{i.entityID}  #{start_on} #{end_on}"
    # end
    #
    set_total_height_from_line(start, finish, orientation)
    puts "Total Height #{total_height}"
    puts "Start #{start}"
    puts "Finish #{finish}"
    #71.45 degrees makes

    one_third_height = total_height/3.0

    parallelogram_points = build_parallelogram_points(finish.x - (2 * one_third_height),
                                                      start.y, total_height,
                                                      total_height, angle_in_degrees)

    bottom_triangle_leg = one_third_height/Math.tan(self.class.degrees_to_radians(angle_in_degrees))
    x1 = parallelogram_points[3].x
    y1 = parallelogram_points[3].y
    x2 = finish.x - (2 * one_third_height) + bottom_triangle_leg
    y2 = finish.y + (2 * one_third_height)

    line1 = draw_line([x1, y1, 0], [x2, y2, 0], group: face_group)
    line1_position = line1.to_line_position

    x1 = finish.x - (2 * one_third_height) + bottom_triangle_leg
    x2 = finish.x
    y = finish.y + (2 * one_third_height)
    line2 = draw_line([x1, y, 0], [x2, y, 0], group: face_group)

    # Top left
    fillet1 = WikiHouse::Fillet.new(fillet_on: line2, fillet_off: line1, angle_in_degrees: angle_in_degrees, group: face_group)
    fillet1.draw!


    x1 = finish.x
    x2 = parallelogram_points[2].x - bottom_triangle_leg
    y = finish.y + (1 * one_third_height)
    line4 = draw_line([x1, y, 0], [x2, y, 0], group: face_group)
    line4_position = WikiHouse::EdgePosition.from_edge(line4)

    line3 = draw_line(line2.end, line4.start, group: face_group)
    line3_position = WikiHouse::EdgePosition.from_edge(line3)


    fillet2 = WikiHouse::Fillet.new(fillet_on: line3, fillet_off: line2, group: face_group)
    fillet2.draw!

    fillet3 = WikiHouse::Fillet.new(fillet_on: line3, fillet_off: line4, group: face_group)
    fillet3.draw!


    lock = WikiHouse::JointLock.new(lock_on: line3, joint: self, group: face_group)

    lock.draw!


    x1 = parallelogram_points[2].x - bottom_triangle_leg
    y1 = finish.y + (1 * one_third_height)
    x2 = parallelogram_points[1].x
    y2 = parallelogram_points[1].y

    line5 = draw_line([x1, y1, 0], [x2, y2, 0], group: face_group)
    line5_position = line5.to_line_position
    fillet = WikiHouse::Fillet.new(fillet_on: line4_position, fillet_off: line5_position, angle_in_degrees: angle_in_degrees, group: face_group)
    fillet.draw!

    #all_connected = line1.all_connected
    possible_starts = line1.connected_at_end #should be three
    raise ScriptError, "I only know how to handle three edges" if possible_starts.length != 2


    if possible_starts[0].on?([line1.end.position.x, line1.start.position.y, line1.start.position.z])
      up_outer_line = possible_starts[0]
      down_outer_line = possible_starts[1]
    else
      up_outer_line = possible_starts[1]
      down_outer_line = possible_starts[0]
    end

    up_outer_path = face_group.path_from(line1_position.start, line5_position.end, forbidden_edges: [line1, down_outer_line])

    up_part_edges = up_outer_path
    up_part_edges.concat([])


   # down_outer_path = face_group.path_from(line1_position.start, line5_position.end, forbidden_edges: [line1, up_outer_line])
    # Find path for up

    #find path for down


    # Fuse them into the part
    # Turn into group
  end
end
