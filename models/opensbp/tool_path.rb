class WikiHouse::ToolPath
  # DECIMAL_PLACES = 6
  class ToolLoop
    attr_reader :lines, :tool_path, :label

    def initialize(tool_path: nil, label: "")
      @lines = []
      @label = label
      @tool_path = tool_path
    end

    def add_line(start_point: nil, end_point: nil, profile_type: :outside, inside_direction: 1)
      @lines << ToolLine.new(tool_path: tool_path,
                             start_point: start_point,
                             end_point: end_point,
                             inside_direction: inside_direction,
                             profile_type: profile_type)

    end

    def to_osbp(depth: nil)
      output = ""
      output << Osbp.comment("Part #{label}") << "\n"
      output << Osbp.move(pt: tool_path.round([@lines.first.profile_start_point.x,
                                               @lines.first.profile_start_point.y,
                                               tool_path.safe_z])) << "\n"
      previous_line = nil
      @lines.each_with_index do |line, lindex|
        if previous_line && previous_line.end_point == line.start_point  &&
          previous_line.profile_end_point != line.profile_start_point
          output << Osbp.comment("Adding Point to link Lines for cutting") << "\n"
          point_1 = [previous_line.profile_end_point.x, line.profile_start_point.y, depth]
          point_2 = [line.profile_start_point.x, previous_line.profile_end_point.y, depth ]
          if point_1.x == line.start_point.x && point_1.y == line.start_point.y
            output << Osbp.cut(pt: tool_path.round(point_2)) << "\n"
          else
            output << Osbp.cut(pt: tool_path.round(point_1)) << "\n"
          end
        end
        # if last_point_used.nil? || (round(line.end_point.x) != last_point_used.x &&
        #     round(line.end_point.y) != last_point_used.y)
        #   output << Osbp.move(x: round(line.profile_end_point.x),
        #                       y: round(line.profile_end_point.y),
        #                       z: round(safe_z)) << "\n"
        # end
        output << Osbp.comment("Line #{lindex}") << "\n"
        output << Osbp.comment("Profile Type: #{line.profile_type}") << "\n"
      #  output << Osbp.comment("Pt: #{Sk.point_to_s(line.start_point)}") << "\n"
        output << Osbp.cut(pt: tool_path.round([line.profile_start_point.x,
                                                line.profile_start_point.y,
                                                depth])) << "\n"
        output << Osbp.comment("Pt: #{Sk.point_to_s(line.end_point)}") << "\n"
        output << Osbp.cut(pt: tool_path.round([line.profile_end_point.x,
                                                line.profile_end_point.y,
                                                depth])) << "\n"                                                #   output << Osbp.comment("#{Sk.point_to_s(line.profile_start_point)}") << "\n"

        #output << Osbp.cut(x:  round(line.profile_end_point.x), y:  round(line.profile_end_point.y), z: round(depth)) << "\n"
        previous_line = line
      end
      output
    end
  end
  class ToolLine
    attr_reader :start_point, :end_point, :inside_direction, :profile_type, :tool_path

    def initialize(tool_path: nil,
                   start_point: nil,
                   end_point: nil,
                   inside_direction: nil,

                   profile_type: :outside)
      @start_point = start_point
      @end_point = end_point
      @inside_direction = inside_direction
      @profile_type = profile_type
      @tool_path = tool_path

    end

    def slope
      Sk.slope(@start_point.x, @start_point.y, @end_point.x, @end_point.y)
    end

    #Ignores z for all calculations :(
    def point_at_distance(point: nil, distance: nil, direction: 1)
      if slope.nil?
        [point.x + direction * distance, point.y, point.z]
      elsif slope.zero?
        [point.x, point.y + direction * distance, point.z]
      else
        x = point.x + direction * (distance / Math.sqrt(1 + slope ** 2))
        y = slope * (x - point.x) + point.y
        [x, y, point.z]
      end
    end


    def points
      [@start_point, @end_point]
    end

    def profile_start_point
      case profile_type
        when :on
          start_point
        when :inside
        when :outside
          pt = point_at_distance(point: start_point, distance: tool_path.bit.radius, direction: inside_direction)
          puts "Start Profile #{Sk.point_to_s(pt)}"
          return pt
        else
          raise ScriptError, "Unsupported profile type #{profile_type}"
      end
    end

    def profile_end_point
      case profile_type
        when :on
          end_point
        when :inside
        when :outside
          pt = point_at_distance(point: end_point, distance: tool_path.bit.radius, direction: inside_direction)
          puts "End profile #{Sk.point_to_s(pt)}"
          return pt
        else
          raise ScriptError, "Unsupported profile type #{profile_type}"
      end
    end

    def profile_points
      [profile_start_point, profile_end_point]
    end

  end
  class ToolPoint
    attr_reader :point

    def initialize(point: point)
      @point = point
    end
  end
  attr :sheet, :clearance, :bit, :depth, :lines, :loops

  def initialize(clearance: 0.200, sheet: nil, bit: nil, depth: nil)
    @sheet = sheet ? sheet : WikiHouse.sheet.new
    @clearance = clearance
    @bit = bit
    @lines = []
    @loops = []
    @depth = depth
  end

  def self.round(val)
    if val.respond_to?(:x) && val.respond_to?(:y) && val.respond_to?(:z)
      [val.x.to_f.round(2), val.y.to_f.round(2), val.z.to_f.round(2)]
    elsif val.is_a?(Array) && val.length == 3
      [val[0].to_f.round(2), val[1].to_f.round(2), val[2].to_f.round(2)]
    else
      val.to_f.round(2)
    end

  end

  def round(val)
    self.class.round(val)
  end

  def self.round_point(pt)
    [round(pt.x), round(pt.y), round(pt.z)]
  end

  def add_line(start_point: nil, end_point: nil, profile_type: :outside, inside_direction: 1)
    @lines << ToolLine.new(tool_path: self, start_point: start_point, end_point: end_point, inside_direction: inside_direction, profile_type: profile_type)

  end

  def add_loop(face: face, loop: nil, ref_point: nil, label: "")
    tool_loop = ToolLoop.new(tool_path: self, label: label)
    tag_dictionary = WikiHouse::AttributeHelper.tag_dictionary
    original_points = loop.vertices.collect { |v| v.position }
    context_points = Sk.convert_to_global_position(loop)

    point_map = {}
    original_points.each_with_index do |op, i|
      point_map[Sk.point_to_s(op)] = context_points[i]
    end

    ordered_loop = []
    #they aren't coming off in a connected order
    #And we want to be clockwise :)

    unordered_loop = loop.edges.collect { |e| e }
    ordered_loop << {edge: unordered_loop.pop, direction: 1}
    while unordered_loop.length > 0
      puts "U Count: #{unordered_loop.length} O Count: #{ordered_loop.length}"
      found = nil
      direction = nil

      unordered_loop.each_with_index do |e, index|
        if e.start.position == ordered_loop.last[:edge].end.position
          found = index
          direction = 1
          break
        end
        if e.end.position == ordered_loop.last[:edge].end.position
          found = index
          direction = -1
          break
        end
      end
      if found.nil?
        if ordered_loop.last.end.position == ordered_loop.first.start.postition
          puts "Loop completed"
        else
          raise ArgumentError, "Loop doesn't loop :("
        end
      else
        ordered_loop << {edge: unordered_loop[found], direction: direction}
        unordered_loop.delete_at(found)
      end

    end
    ordered_loop.each_with_index do |item, index|
      e = item[:edge]

      inside_direction = nil
      if e.get_attribute tag_dictionary, "inside_edge"
        profile_type = :inside
      elsif e.get_attribute tag_dictionary, "on_edge"
        profile_type = :on
      else
        profile_type = :outside
      end
      if item[:direction] > 0
        start_point = e.start.position
        end_point = e.end.position
      else
        start_point = e.end.position
        end_point = e.start.position
      end

      slope = Sk.slope(start_point.x, start_point.y, end_point.x, end_point.y) #Doing it in local co-ordinates
      if slope.nil?

        if Sk.is_point_on_vertex_of_face?(face: face, pt: [start_point.x, start_point.y, start_point.z])

          calibration_pt = [start_point.x, start_point.y, start_point.z]
          if start_point.y < end_point.y
            calibration_pt[1] = start_point.y + (start_point.y + end_point.y)/2.0
          else
            calibration_pt[1] = start_point.y - (start_point.y + end_point.y)/2.0
          end
          postive_result = face.classify_point([calibration_pt.x + 0.01, calibration_pt.y, calibration_pt.z])
          negative_result = face.classify_point([calibration_pt.x - 0.01, calibration_pt.y, calibration_pt.z])
          if negative_result > 4 && postive_result <= 4
            inside_direction = 1
          elsif negative_result <= 4 && postive_result > 4
            inside_direction = -1
          end


        else
          raise ScriptError, "The start point isn't considered a vertex for the face provided"
        end
      elsif slope == 0
        if Sk.is_point_on_vertex_of_face?(face: face, pt: [start_point.x, start_point.y, start_point.z])
          calibration_pt = [start_point.x, start_point.y, start_point.z]
          if start_point.x < end_point.x
            calibration_pt[0] = start_point.x + (start_point.x + end_point.x)/2.0
          else
            calibration_pt[0] = start_point.x - (start_point.x + end_point.x)/2.0
          end

          postive_result = face.classify_point([calibration_pt.x, calibration_pt.y + 0.01, calibration_pt.z])
          negative_result = face.classify_point([calibration_pt.x, calibration_pt.y - 0.01, calibration_pt.z])
          if negative_result > 4 && postive_result <= 4
            inside_direction = 1
          elsif negative_result <= 4 && postive_result > 4
            inside_direction = -1
          end


        else
          raise ScriptError, "The start point isn't considered a vertex for the face provided"
        end
      else
        raise ScriptError, "We don't know how to do this slope yet"
      end
      if inside_direction.nil?
        raise ScriptError, "#{slope.nil? ? "Nil" : slope} #{Sk.point_to_s(start_point)} #{Sk.point_to_s(end_point)} Unable to figure out the inside orientation for this edge"
      end
      puts "Adding a line with slope #{slope} and #{inside_direction} for #{profile_type}"


      global_start_point = point_map[Sk.point_to_s(start_point)] #This is the point in the global x.y.z in the sketchup model

      referenced_global_start_point = [
          global_start_point.x - ref_point.x,
          global_start_point.y - ref_point.y,
          global_start_point.z - ref_point.z
      ] #This makes it relative to the ref_point (normally the 0,0 of the sheet)
      global_end_point = point_map[Sk.point_to_s(end_point)]
      referenced_global_end_point = [
          global_end_point.x - ref_point.x,
          global_end_point.y - ref_point.y,
          global_end_point.z - ref_point.z
      ]


      tool_loop.add_line(start_point: referenced_global_start_point,
                         end_point: referenced_global_end_point,
                         profile_type: profile_type,
                         inside_direction: inside_direction,
      )
    end
    @loops << tool_loop
  end

  def first_point
    @lines.first.start
  end

  def safe_z
    @sheet.thickness + @clearance
  end

  def to_osbp

    #Todo - support single points
    #Todo - support lines
    #Todo - support pockets
    output = ""

    last_point_used = nil
    depths = cut_depths(depth: depth)
    depths.each_with_index do |pass_depth, i|
      output << Osbp.comment("Pass #{i + 1} #{pass_depth}") << "\n"
      @loops.each do |loop|
        output << loop.to_osbp(depth: pass_depth)
      end
    end


    output
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