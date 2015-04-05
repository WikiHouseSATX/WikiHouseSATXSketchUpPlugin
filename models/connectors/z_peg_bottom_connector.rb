class WikiHouse::ZPegBottomConnector < WikiHouse::PocketConnector


  def initialize(thickness: nil, count: 1)
    super(length_in_t: 8, width_in_t: 4, thickness: thickness, rows: 1, count: count)

  end

  def draw_pocket!(location: nil)
    #assumes location is upper left corner
    #need to move down 1 thickness for the joint so it lines up

    c1 = [location.x, location.y - thickness, location.z ]
    c2 = [c1.x + width_in_t * thickness, c1.y, location.z ]
    c3 = [ c2.x, c2.y - length_in_t * thickness, location.z ]
    c4 = [ c3.x - width_in_t/2.0 * thickness, c3.y, location.z]
    c5 = [ c4.x, c1.y - length_in_t/2.0 * thickness, location.z]
    c6 = [ c1.x, c5.y, location.z]


   #handle fillet of this a little manually
    points = []


    points.concat(WikiHouse::Fillet.upper_to_right(c1))
    points.concat(WikiHouse::Fillet.upper_to_left(c2))
    points.concat(WikiHouse::Fillet.stem_to_right(c3))
    points.concat(WikiHouse::Fillet.stem_to_left(c4))
    points.concat([c5])
    points.concat(WikiHouse::Fillet.lower_to_right(c6))





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