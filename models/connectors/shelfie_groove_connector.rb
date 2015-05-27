class WikiHouse::ShelfieGrooveConnector  < WikiHouse::GrooveConnector
  def initialize(depth_in_t: nil, length_in_t: nil, count: 1, width_in_t: nil, sheet: nil, rows: 1)
    @depth_in_t = depth_in_t
    @depth_in_t ||= Sk.round(1.0/3.0)

    super(depth_in_t: @depth_in_t,length_in_t: length_in_t, count: count, width_in_t: width_in_t, sheet: sheet, rows:rows)

  end

  def draw!(bounding_origin: nil, part_length: nil, part_width: nil)

    offset = 3 * thickness

    return draw_groove!(location: [bounding_origin.x + 5,
                                   bounding_origin.y - offset,
                                   bounding_origin.z],
                        fillet_off: false)

  end
  def shelfie_groove?
    true
  end
  def name
    :shelfie_groove
  end
end