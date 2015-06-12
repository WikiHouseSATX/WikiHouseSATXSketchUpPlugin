class WikiHouse::UPegLockPocketConnector < WikiHouse::PocketConnector


  def initialize(thickness: nil)
    super(length_in_t: 3, width_in_t: 2, thickness: thickness, rows: 1, count: 1)

  end

  def draw!(bounding_origin: nil, part_length: nil, part_width: nil)

    half_width_part = part_width/2.0
    half_width_connector = width/2.0

    offset = 2 * thickness

    lines = draw_pocket!(location: [bounding_origin.x + half_width_part - half_width_connector ,
                                    bounding_origin.y - offset,
                                    bounding_origin.z])
    lines.concat( draw_pocket!(location: [bounding_origin.x + half_width_part - half_width_connector ,
                                          bounding_origin.y - part_length + 5 * thickness,
                                          bounding_origin.z]))
    lines
  end

  def rows
    1
  end

  def count
    2
  end

  def upeg?
    true
  end

  def upeg_lock?
    true
  end

  def name
    :upeg_lock
  end
end