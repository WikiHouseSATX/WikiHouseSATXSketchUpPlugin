class WikiHouse::UPegEndPassThruConnector < WikiHouse::PocketConnector


  def initialize(thickness: nil, top_on: true, bottom_on: true)
    super(length_in_t: 9, width_in_t: 2, thickness: thickness, rows: 1, count: 1)
    @top_on = top_on
    @bottom_on = bottom_on
  end

  def draw!(bounding_origin: nil, part_length: nil, part_width: nil)

    half_width_part = part_width/2.0
    half_width_connector = width/2.0

    offset = 4 * thickness
    lines = []
    if @bottom_on

      lines.concat(draw_pocket!(location: [bounding_origin.x + half_width_part - half_width_connector,
                                           bounding_origin.y - offset,
                                           bounding_origin.z]))
    end
    if @top_on

      lines.concat(draw_pocket!(location: [bounding_origin.x + half_width_part - half_width_connector,
                                           bounding_origin.y - part_length + offset + (@length_in_t * thickness),
                                           bounding_origin.z]))
    end
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

  def upeg_end_pass_thru?
    true
  end

  def name
    :upeg_end_pass_thru
  end
end