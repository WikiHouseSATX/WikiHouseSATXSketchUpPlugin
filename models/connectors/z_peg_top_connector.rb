class WikiHouse::ZPegTopConnector < WikiHouse::PocketConnector


  def initialize(thickness: nil)
    super(length_in_t: 4, width_in_t: 2, thickness: thickness, rows: 1, count: 1)

  end

  def draw!(bounding_origin: nil, part_length: nil, part_width: nil)

    half_width_part = part_width/2.0
    half_width_connector = width/2.0

    offset = 3 * thickness

    return draw_pocket!(location: [bounding_origin.x + half_width_part - half_width_connector , bounding_origin.y - offset, bounding_origin.z])

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

  def zpeg_top?
    true
  end

  def name
    :zpeg_top
  end
end