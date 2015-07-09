#Only fillet if the groove doesn't go the entire widht
#need to push instead of deleting the face

class WikiHouse::GrooveConnector < WikiHouse::Connector
  attr_reader :rows, :depth_in_t, :sheet

  def initialize(depth_in_t: 0, length_in_t: nil, count: 1, width_in_t: nil, sheet: nil, rows: 1)
    if depth_in_t >= 1
      raise ArgumentError, "A groove can't go all the way thru - that would be a pocket"
    end

    super(length_in_t: length_in_t, count: count, width_in_t: width_in_t, thickness: sheet.thickness)
    @sheet = sheet
    @rows = rows
  end
  def set_material(face, face_material: nil)
    if face_material.nil?
      face_material =  sheet.material
    end
    face.material = face_material
  end
  def depth
    depth_in_t * thickness
  end

  def draw_groove!(location: nil, fillet_off: false)
    #assumes location is upper left corner

    #bottom Face
    c5 = location
    c6 = [c5.x + width, c5.y, c5.z]
    c7 = [c6.x, c5.y - length, c5.z]
    c8 = [c5.x, c7.y, c5.z]

    #left Side
    c9 = [c5.x, c5.y, c5.z + thickness]
    c10 = [c6.x, c6.y, c6.z + thickness]

    #right side
    c11 = [c7.x, c7.y, c7.z + thickness]
    c12 = [c8.x, c8.y, c8.z + thickness]


    bottom_points = [c5,c6,c7,c8]
    top_points = [c9,c10,c11, c12]
    # c5c6 = Sk.draw_line(c5, c6)
    # c6c7 = Sk.draw_line(c6, c7)
    # c7c8 = Sk.draw_line(c7, c8)
    # c8c5 = Sk.draw_line(c8, c5)
    #
    # c9c10 = Sk.draw_line(c9, c10)
    # c10c11 = Sk.draw_line(c10, c11)
    # c11c12 = Sk.draw_line(c11, c12)
    # c12c9 = Sk.draw_line(c12, c9)
    #
    #  c5c9 = Sk.draw_line(c5, c9)
    #
    #  c6c10 = Sk.draw_line(c6, c10)
    #  c7c11 = Sk.draw_line(c7, c11)
    #  c8c12 = Sk.draw_line(c8, c12)
    #
     unless fillet_off
      #This needs to be redesigned for the 3d view
     # WikiHouse::DogBoneFillet.pocket_by_points(bottom_points)
       WikiHouse::DogBoneFillet.pocket_by_points(top_points)
      # Sk.draw_all_points(bottom_points)
       Sk.draw_all_points(top_points)
    end


    groove_face = Sk.add_face(top_points)
    set_material(groove_face)

    puts "Faces #{groove_face}"
    groove_face.reverse!
    groove_face.pushpull (thickness - depth)
        # groove_lines = [c5c6,
        #                 c6c7,
        #                 c7c8,
        #                 c8c5,
        #                 c9c10,
        #                 c10c11,
        #                 c11c12,
        #                 c12c9,
        #                 c5c9,
        #                 c6c10,
        #                 c7c11,
        #                 c8c12]
    groove_lines = []
    #  bottom_points =  [c5,c6,c7,c8]
    #  top_points = [c9,c10,c11,c12]
    #  bottom_pocket_lines = Sk.draw_all_points(bottom_points)
    #  top_pocket_lines = Sk.draw_all_points(top_points)
    #  pocket_lines = bottom_pocket_lines.concat(top_pocket_lines)
    #  pocket_lines << Sk.draw_line(c5,c9)
    #  pocket_lines << Sk.draw_line(c6,c10)
    #  pocket_lines << Sk.draw_line(c7,c11)
    #  pocket_lines << Sk.draw_line(c8,c12)
    #
    #
    #  pocket_lines.each { |e| mark_inside_edge!(e) }
    #  groove_group = Sk.add_group(pocket_lines)
    #  pocket_face = Sk.add_face(pocket_lines, group: groove_group)
    #  puts  "Face is #{pocket_face}"
    # # pocket_face.reverse!
    #  pocket_face.pushpull thickness
    #  #pocket_face.erase!
    groove_lines

  end

  def draw!(bounding_origin: nil, part_length: nil, part_width: nil)
    pockets_list = []
    self.class.drawing_points(bounding_origin: bounding_origin,
                              count: count,
                              rows: self.respond_to?(:rows) ? rows : 1,
                              part_length: part_length,
                              part_width: part_width,
                              item_length: length,
                              item_width: width) { |row, col, location|
      pockets_list << draw_groove!(location: location)
    }
    pockets_list
  end


  def groove?
    true
  end

  def name
    :groove
  end

end