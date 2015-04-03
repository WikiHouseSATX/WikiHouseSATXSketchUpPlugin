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
end