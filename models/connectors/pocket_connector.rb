class WikiHouse::PocketConnector < WikiHouse::Connector
  attr_reader :rows
  def initialize(length_in_t: nil, count: 1, width_in_t: nil, thickness: nil, rows: 1)
    super(length_in_t: length_in_t, count:count, width_in_t: width_in_t , thickness: thickness)
    @rows = rows
  end
  def  draw_pocket!(location: nil)
    #assumes location is upper left corner

    c5 = location
    c6 = [c5.x + width, c5.y, c5.z]
    c7 = [c6.x, c5.y - length, c5.z]
    c8 = [c5.x, c7.y, c5.z]
    points = [c5,c6,c7, c8]
    WikiHouse::Fillet.pocket_by_points(points)

    pocket_lines =  Sk.draw_all_points(points)
    pocket_lines.each { |e| mark_inside_edge!(e) }
    pocket_face = Sk.add_face(pocket_lines)
    pocket_face.erase!
    pocket_lines
  end
  def draw!(bounding_origin: nil, part_length: nil, part_width: nil)

    length_gap = Sk.round((part_length - (count * length))/(count.to_f + 1.0))

    width_gap = Sk.round((part_width - (rows * width))/(rows.to_f + 1.0))


    pockets_list = []
    rows.times do |row|
      base_x = ((row + 1) * width_gap) + (row * width)

      count.times do |i|
        base_y = ((i + 1) * length_gap) + (i * length)
        pockets_list << draw_pocket!(location: [bounding_origin.x + base_x, bounding_origin.y - base_y, bounding_origin.z])
      end
    end

    pockets_list

  end

  def pocket?
    true
  end
  def name
    :pocket
  end
end