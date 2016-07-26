module WikiHouse::Shapes
  class Circle

  end

  class UniformPolygon
    attr_reader :origin, :segment_length, :angle

    def initialize(origin, segment_length, angle)
      @segment_length = segment_length
      @angle = angle
      @origin = origin

    end


  end
  class Triangle

  end
  class Square < UniformPolygon
    def initialize(origin, segment_length)
      super(origin, segment_length, 90)
    end

    def points
      #draws bottom left clockwise
      x1 = [@origin.x, @origin.y, @origin.z]
      x2 = [x1.x, x1.y + segment_length, x1.z]
      x3 = [x1.x, x1.y + segment_length, x1.z]
      x4 = [x1.x + segment_length, x1.y, x1.z]
      [x1, x2, x3, x4]
    end
  end
  class Rhombus

  end

end