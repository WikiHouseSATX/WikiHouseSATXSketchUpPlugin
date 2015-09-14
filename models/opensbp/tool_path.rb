class WikiHouse::ToolPath
  class ToolLine
    attr_reader :start_point, :end_point, :inside_direction
    def initialize(start_point: nil, end_point: nil, inside_direction: nil)
      @start_point = start_point
      @end_point = end_point
      @inside_direction = inside_direction
    end
    def slope
      Sk.slope(@start_point.x, @start_point.y, @end_point.x, @end_point.y)
    end
    def points
      [@start_point, @end_point]
    end
  end
  class ToolPoint
    attr_reader :point
    def initialize(point: point)
      @point = point
    end
  end
end