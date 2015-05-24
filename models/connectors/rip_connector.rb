
#this connector is used when you need to remove a constant thickness from an edge
class WikiHouse::RipConnector < WikiHouse::Connector
  attr_reader :rows
  def initialize(length_in_t: nil, count: 1, width_in_t: nil, thickness: nil)
    count = 1
    @count = 1
    super
    @count = 1
  end

  def count
    1
  end
  def rip?
    true
  end
  def name
    :rip
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
    if orientation == :right
      if c5.x == bounding_start.x
        c5.x -= self.length

      end
      c6.x = c5.x
    elsif orientation == :left
      if c5.x == bounding_start.x
        c5.x += self.length

      end
      c6.x = c5.x
    elsif orientation == :top
      if c5.y == bounding_start.y
        c5.y -= self.length

      end
      c6.y = c5.y
    elsif orientation == :bottom
        if c5.y == bounding_start.y
        c5.y += self.length

      end
      c6.y = c5.y
    else
      raise ArgumentError, "#{orientation} is not supported by this connector"
    end
    return([c5, c6])
  end

end