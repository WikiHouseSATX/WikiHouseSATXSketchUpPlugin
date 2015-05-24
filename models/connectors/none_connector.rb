class WikiHouse::NoneConnector < WikiHouse::Connector
  def initialize(length_in_t: 0, count: 0, width_in_t: 0)
    super
    @length_in_t = 0
    @count = 0
    @width_in_t = 0
  end

  def draw!(bounding_origin: nil, part_length: nil, part_width: nil)
    []
  end

  def length_in_t
    0
  end

  def width_in_t
    0
  end

  def count
    0
  end

  def none?
    true
  end

  def name
    :none
  end

  def points(bounding_start: nil,
             bounding_end: nil,
             start_pt: nil,
             end_pt: nil,
             orientation: nil,
             starting_thickness: nil,
             total_length: nil)
    c5 = start_pt
    c6 = end_pt
    return([c5, c6])
  end

end