class WikiHouse::ToolPath
 # DECIMAL_PLACES = 6
  class ToolLine
    attr_reader :start_point, :end_point, :inside_direction, :profile_type

    def initialize(start_point: nil, end_point: nil, inside_direction: nil, profile_type: :outside)
      @start_point = start_point
      @end_point = end_point
      @inside_direction = inside_direction
      @profile_type = profile_type
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

  def initialize(clearance: 0.200, sheet: nil, bit: nil)
    @sheet = sheet ? sheet : WikiHouse.sheet.new
    @clearance = clearance
    @bit = bit
    @lines = []
  end

  def add_line(start_point: nil , end_point: nil, profile_type: :outside, inside_direction: 1)
    @lines << ToolLine.new(start_point: start_point, end_point: end_point, inside_direction: inside_direction, profile_type: profile_type)

  end

  def to_s

    #Jog to the right place

    #loop thru the lines
    #Hande the connecting points between lines
    #Build up x/y path
    #figure out depths and then replay x/y paht

    # sbp_file.write %Q(#{Osbp.move(x: profile_points.first.gx,
    #                               y: profile_points.first.gy,
    #                               z: @clearance)}\n)
    #
    # depths = cut_depths(depth: @sheet.thickness)
    # depths.each_with_index do |depth, i|
    #   sbp_file.write %Q(#{Osbp.comment("Pass #{i + 1}")}\n)
    #   profile_points.each do |pp|
    #     sbp_file.write %Q(#{Osbp.comment(pp.edge_type)}\n)
    #
    #     sbp_file.write %Q(#{Osbp.cut(x: pp.cx, y: pp.cy, z: round(depth))}\n)
    #   end
    # end
  end

  def cut_depths(depth: nil)

    depths = []
    passes = (depth/@bit.diameter).round
    passes = 1 if passes < 1
    passes.times do |i|
      depths << (depth - (i * @bit.diameter)) * -1
    end
    depths.reverse!
    depths
  end
end