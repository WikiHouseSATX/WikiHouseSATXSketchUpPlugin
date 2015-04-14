class WikiHouse::PocketConnector < WikiHouse::Connector
  attr_reader :rows

  def initialize(length_in_t: nil, count: 1, width_in_t: nil, thickness: nil, rows: 1)
    super(length_in_t: length_in_t, count: count, width_in_t: width_in_t, thickness: thickness)
    @rows = rows
  end

  def draw_pocket!(location: nil)
    #assumes location is upper left corner

    c5 = location
    c6 = [c5.x + width, c5.y, c5.z]
    c7 = [c6.x, c5.y - length, c5.z]
    c8 = [c5.x, c7.y, c5.z]
    points = [c5, c6, c7, c8]

    WikiHouse::Fillet.pocket_by_points(points)

    pocket_lines = Sk.draw_all_points(points)
    pocket_lines.each { |e| mark_inside_edge!(e) }
    pocket_face = Sk.add_face(pocket_lines)
    pocket_face.erase!
    pocket_lines

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
      pockets_list << draw_pocket!(location: location)
    }
    pockets_list
  end


  def pocket?
    true
  end

  def name
    :pocket
  end

end