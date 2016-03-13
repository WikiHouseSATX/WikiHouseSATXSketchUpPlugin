class WikiHouse::NotchConnector < WikiHouse::Connector
  attr_reader :rows
  def initialize(length_in_t: nil, count: 1, width_in_t: nil, thickness: nil)
    count = 1
    @count = 1
    super
    @count = 1
  end

  def notch_size
    thickness
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
    c5 = start_pt.clone
    c6 = start_pt.clone
    c7 = start_pt.clone
    c8 = end_pt.clone

    if orientation == :right
      if c5.x == bounding_start.x
        c5.x -= self.length

      end
      c6.x = c5.x
      c6.y += notch_size
      c7.y = c6.y
    elsif orientation == :left
      if c5.x == bounding_start.x
        c5.x += self.length

      end
      c6.x = c5.x
      c6.y += notch_size
      c7.y = c6.y
    elsif orientation == :top
      if c5.y == bounding_start.y
        c5.y -= self.length

      end
      c6.y = c5.y
      c6.x += notch_size
      c7.x = c6.x
    elsif orientation == :bottom
      if c5.y == bounding_start.y
        c5.y += self.length

      end
      c6.y = c5.y
      c6.x += notch_size
      c7.x = c6.x
    else
      raise ArgumentError, "#{orientation} is not supported by this connector"
    end
  #  return([start_pt, end_pt])
    return([c5, c6,c7 , c8])
  end

end