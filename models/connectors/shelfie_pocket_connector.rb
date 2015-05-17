class WikiHouse::ShelfiePocketConnector< WikiHouse::PocketConnector


  def initialize(thickness: nil, width_in_t: 8)
    super(length_in_t: 1, width_in_t: width_in_t, thickness: thickness, rows: 1, count: 1)

  end

  def draw!(bounding_origin: nil, part_length: nil, part_width: nil)

    half_width_part = part_width/2.0
    half_width_connector = width/2.0

    offset = 2 * thickness

    return draw_pocket!(location: [bounding_origin.x + half_width_part - half_width_connector,
                                   bounding_origin.y - part_length + offset,
                                   bounding_origin.z])

  end

  def rows
    1
  end

  def count
    1
  end

  def zpeg?
    true
  end

  def shelfie_pocket?
    true
  end

  def name
    :shelfie_pocket
  end

end