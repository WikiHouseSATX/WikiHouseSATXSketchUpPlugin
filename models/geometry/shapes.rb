module Shapes
  class Circle

  end
  class Triangle

  end
  class Square

  end
  class Rhombus

  end
  class UniformPolygon
    attr_reader :origin,:segment_length, :angle
    def init(origin,segment_length, angle)
      @segment_length = segment
      @angle = angle
      @origin = origin

    end

  end
end