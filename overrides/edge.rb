Sketchup::Edge.class_eval do
  def to_line_position
    WikiHouse::EdgePosition.from_edge(self)
  end

  def on?(item)
    #based on https://www.youtube.com/watch?v=JlRagTNGBF0

    if item.respond_to?(:x)
      x3 = item.x
      y3 = item.y
      z3 = item.z
    elsif item.respond_to?(:position)
      x3 = item.position.x
      y3 = item.position.y
      z3 = item.position.z
    else
      raise ArgumentError, "#{item.class} is not supported for on?"
    end
    #  puts "#{item.x} #{item.y} #{item.z}"

    x1 = start.position.x
    y1 = start.position.y
    z1 = start.position.z

    x2 = self.end.position.x
    y2 = self.end.position.y
    z2 = self.end.position.z

    return true if [x1, y1, z1] == [z3, y3, z3]
    return true if [x2, y2, z2] == [z3, y3, z3]
    if (x3 > x1 && x3 > x2) || (x3 < x1 && x3 < x2) ||
        (y3 > y1 && y3 > y2) || (y3 < y1 && y3 < y2) ||
        (z3 > z1 && z3 > z2) || (z3 < z1 && z3 < z2)
      # puts "Out of range"
      return false
    end
    xt = yt = zt = nil
    if x1 == x2
      if x1 != x3
        return false
      end
    else
      xt = (x1 - x3).to_f/(x1 - x2).to_f
    end

    if y1 == y2
      if y1 != y3
        return false
      end
    else
      yt = (y1 - y3).to_f/(y1 - y2).to_f
    end

    if z1 == z2
      if z1 != z3
        return false
      end
    else
      zt = (z1 - z3).to_f/(z1 - z2).to_f
    end

    # puts "#{xt} #{yt} #{zt}"
    tvals = [xt, yt, zt].compact
    return true if tvals.length == 1
    t = tvals.first
    tvals.each { |tv| return flase if t != tv }
    true


  end

  def other_point(point)
    if point.respond_to? :position
      point = [point.position.x, point.position.y, point.position.z]
    end
    if [self.start.position.x, self.start.position.y, self.start.position.z] == point
      return self.end
    elsif [self.end.position.x, self.end.position.y, self.end.position.z] == point
      return self.start
    else
      raise ArgumentError, "Expected a point to be the start/end of the edge #{point}"
    end
  end

  #these only work on edges
  def connected_at_start
    connected_at_other_vertex(self.start)
  end

  def connected_at_end
    connected_at_other_vertex(self.end)
  end

  def connected_at_other_vertex(vertex)
   other = other_point(vertex)
    list = []
    all_connected.each do |entity|
      next if entity.typename != "Edge"
      next if entity == self
      list << entity if entity.used_by?(other)
    end
    list
  end
end