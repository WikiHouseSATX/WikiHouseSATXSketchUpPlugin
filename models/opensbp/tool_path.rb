# J3,4.5,2.65,0.95
# M3,4.5,2.65,-0.5
# M3,2.5,2.64,-0.5
# M3,2.63,2.64,-0.5
# M3,2.63,4.38,-0.5
# M3,2.5,4.38,-0.5
# M3,4.5,4.38,-0.5
# M3,4.38,4.38,-0.5
# M3,4.38,2.64,-0.5


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

      cut_profile = @lines.collect { |line| line.profile_type }.uniq.sort
      if cut_profile == [:outside]
        output << Osbp.move(pt: tool_path.round([@lines.first.profile_start_point.x,
                                                 @lines.first.profile_start_point.y,
                                                 tool_path.safe_z])) << "\n"
        previous_line = nil
        @lines.each_with_index do |line, lindex|
          if previous_line && previous_line.end_point == line.start_point &&
              previous_line.profile_end_point != line.profile_start_point
            output << Osbp.comment("Adding Point to link Lines for cutting") << "\n"
            point_1 = [previous_line.profile_end_point.x, line.profile_start_point.y, depth]
            point_2 = [line.profile_start_point.x, previous_line.profile_end_point.y, depth]
            if point_1.x == line.start_point.x && point_1.y == line.start_point.y
              output << Osbp.cut(pt: tool_path.round(point_2)) << "\n"
            else
              output << Osbp.cut(pt: tool_path.round(point_1)) << "\n"
            end
          end

          output << Osbp.comment("Line #{lindex}") << "\n"
          output << Osbp.comment("Profile Type: #{line.profile_type}") << "\n"
          #  output << Osbp.comment("Pt: #{Sk.point_to_s(line.start_point)}") << "\n"
          output << Osbp.cut(pt: tool_path.round([line.profile_start_point.x,
                                                  line.profile_start_point.y,
                                                  depth])) << "\n"
          output << Osbp.comment("Pt: #{Sk.point_to_s(line.end_point)}") << "\n"
          output << Osbp.cut(pt: tool_path.round([line.profile_end_point.x,
                                                  line.profile_end_point.y,
                                                  depth])) << "\n"
          previous_line = line
        end
      elsif cut_profile == [:inside]
        output << Osbp.move(pt: tool_path.round([@lines.first.profile_start_point.x,
                                                 @lines.first.profile_start_point.y,
                                                 tool_path.safe_z])) << "\n"

        @lines.each_with_index do |line, lindex|


          output << Osbp.comment("Line #{lindex}") << "\n"
          output << Osbp.comment("Profile Type: #{line.profile_type}") << "\n"
          output << Osbp.comment("Slope: #{line.slope.nil? ? "None" : line.slope.zero? ? "0" : line.slope}") << "\n"
          output << Osbp.comment("Inside Direction: #{line.inside_direction}") << "\n"

          output << Osbp.comment("Start Pt: #{Sk.point_to_s(tool_path.round(line.start_point))}") << "\n"
          output << Osbp.cut(pt: tool_path.round([line.profile_start_point.x,
                                                  line.profile_start_point.y,
                                                  depth])) << "\n"
          if line == @lines.last
            output << Osbp.comment("End Pt: #{Sk.point_to_s(tool_path.round(line.end_point))}") << "\n"
            output << Osbp.cut(pt: tool_path.round([line.profile_end_point.x,
                                                    line.profile_end_point.y,
                                                    depth])) << "\n"
          end
        end
      elsif cut_profile == [:fillet, :inside]
        output << Osbp.move(pt: tool_path.round([@lines.first.profile_start_point.x,
                                                 @lines.first.profile_start_point.y,
                                                 tool_path.safe_z])) << "\n"
         @lines.each_with_index do |line, lindex|
                output << Osbp.comment("Line #{lindex}") << "\n"
                output << Osbp.comment("Profile Type: #{line.profile_type}") << "\n"
                output << Osbp.comment("Slope: #{line.slope.nil? ? "None" : line.slope.zero? ? "0" : line.slope}") << "\n"
                output << Osbp.comment("Inside Direction: #{line.inside_direction}") << "\n"

                output << Osbp.comment("Start Pt: #{Sk.point_to_s(tool_path.round(line.start_point))}") << "\n"
                output << Osbp.move(pt: tool_path.round([line.start_point().x,
                                                        line.start_point().y,
                                                        depth])) << "\n"

         end
        # @lines.each_with_index do |line, lindex|
        #  if lindex == 0
        #   #special case where we have to consider the fillet at the end
        #    fillet_before = nil
        #    if @lines.last.fillet_profile?
        #      if @lines.last.short_fillet?
        #        fillet_before = :short_fillet
        #      else
        #        fillet_before = :long_fillet
        #      end
        #    end
        #
        #      output << Osbp.comment("Line #{lindex}") << "\n"
        #      output << Osbp.comment("Profile Type: #{line.profile_type}") << "\n"
        #      output << Osbp.comment("Slope: #{line.slope.nil? ? "None" : line.slope.zero? ? "0" : line.slope}") << "\n"
        #      output << Osbp.comment("Inside Direction: #{line.inside_direction}") << "\n"
        #
        #      output << Osbp.comment("Start Pt: #{Sk.point_to_s(tool_path.round(line.start_point))}") << "\n"
        #      output << Osbp.cut(pt: tool_path.round([line.profile_start_point(fillet_before:fillet_before).x,
        #                                              line.profile_start_point(fillet_before:fillet_before).y,
        #                                              depth])) << "\n"
        #
        #
        #  else
        #    if line.fillet_profile?
        #      if line.long_fillet?
        #        output << Osbp.comment("Line #{lindex}") << "\n"
        #        output << Osbp.comment("Profile Type: #{line.profile_type}") << "\n"
        #        output << Osbp.comment("Slope: #{line.slope.nil? ? "None" : line.slope.zero? ? "0" : line.slope}") << "\n"
        #        output << Osbp.comment("Inside Direction: #{line.inside_direction}") << "\n"
        #
        #        output << Osbp.comment("Start Pt: #{Sk.point_to_s(tool_path.round(line.start_point))}") << "\n"
        #        output << Osbp.cut(pt: tool_path.round([line.profile_start_point.x,
        #                                                line.profile_start_point.y,
        #                                                depth])) << "\n"
        #        output << Osbp.cut(pt: tool_path.round([line.profile_end_point.x,
        #                                                line.profile_end_point.y,
        #                                                depth])) << "\n"
        #
        #
        #      else
        #        output << Osbp.comment("Line #{lindex}") << "\n"
        #        output << Osbp.comment("Profile Type: #{line.profile_type}") << "\n"
        #        output << Osbp.comment("Slope: #{line.slope.nil? ? "None" : line.slope.zero? ? "0" : line.slope}") << "\n"
        #        output << Osbp.comment("Inside Direction: #{line.inside_direction}") << "\n"
        #
        #        output << Osbp.comment("Start Pt: #{Sk.point_to_s(tool_path.round(line.start_point))}") << "\n"
        #
        #      end
        #    else
        #      fillet_before = nil
        #      if @lines[lindex - 1].fillet_profile?
        #        if @lines[lindex - 1].short_fillet?
        #          fillet_before = :short_fillet
        #        else
        #          fillet_before = :long_fillet
        #        end
        #      end
        #
        #      output << Osbp.comment("Line #{lindex}") << "\n"
        #      output << Osbp.comment("Profile Type: #{line.profile_type}") << "\n"
        #      output << Osbp.comment("Slope: #{line.slope.nil? ? "None" : line.slope.zero? ? "0" : line.slope}") << "\n"
        #      output << Osbp.comment("Inside Direction: #{line.inside_direction}") << "\n"
        #
        #      output << Osbp.comment("Start Pt: #{Sk.point_to_s(tool_path.round(line.start_point))}") << "\n"
        #      output << Osbp.cut(pt: tool_path.round([line.profile_start_point(fillet_before:fillet_before).x,
        #                                              line.profile_start_point(fillet_before:fillet_before).y,
        #                                              depth])) << "\n"
        #
        #    end
        #
        #  end
        #
        # end
        # if @lines.last.profile_type == :fillet
        # @lines.each_with_index do |line, lindex|
        #
        #   if line.profile_type == :inside
        #     output << Osbp.comment("Line #{lindex}") << "\n"
        #     output << Osbp.comment("Profile Type: #{line.profile_type}") << "\n"
        #     output << Osbp.comment("Slope: #{line.slope.nil? ? "None" : line.slope.zero? ? "0" : line.slope}") << "\n"
        #     output << Osbp.comment("Inside Direction: #{line.inside_direction}") << "\n"
        #
        #     output << Osbp.comment("Start Pt: #{Sk.point_to_s(tool_path.round(line.start_point))}") << "\n"
        #     output << Osbp.cut(pt: tool_path.round([line.profile_start_point.x,
        #                                             line.profile_start_point.y,
        #                                             depth])) << "\n"
        #     if line == @lines.last
        #       output << Osbp.comment("End Pt: #{Sk.point_to_s(tool_path.round(line.end_point))}") << "\n"
        #       output << Osbp.cut(pt: tool_path.round([line.profile_end_point.x,
        #                                               line.profile_end_point.y,
        #                                               depth])) << "\n"
        #     end
        #   elsif line.profile_type == :fillet
        #
        #   end
        #
        #
        # end
      else
        raise ScriptError, "Doesn't support mixed profile types in a loop #{cut_profile.join(",")}"
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
    def length
      if slope.nil?
        (@start_point.y - @end_point.y).abs
      elsif slope.zero?
        (@start_point.x - @end_point.x).abs
      else
        tool_path.round(Math.sqrt((@start_point.x - @end_point.x)**2 + (@start_point.y - @end_point.y)))
      end
    end

    #Ignores z for all calculations :(
    def point_at_distance(point: nil, distance: nil, direction: 1)
      Sk.point_at_distance(slope: slope, point: point, distance: distance, direction: direction)
    end


    def points
      [@start_point, @end_point]
    end

    def profile_start_point(fillet_before: nil)
      case profile_type
        when :on
          start_point
        when :inside
          if slope.nil?

            pt = [start_point.x + -1 * inside_direction * tool_path.bit.radius,
                  start_point.y + inside_direction * tool_path.bit.radius,
                  start_point.z]


          elsif slope.zero?
            pt = [start_point.x + -1 * inside_direction * tool_path.bit.radius,
                  start_point.y + inside_direction * tool_path.bit.radius,
                  start_point.z]
            if fillet_before == :long_fillet
              pt.y -= tool_path.bit.radius * inside_direction
            end
          else
            if slope > 0
              pt = [start_point.x + -1 * inside_direction * tool_path.bit.radius,
                    start_point.y + -1 * inside_direction * tool_path.bit.radius,
                    start_point.z]
            else
              pt = [start_point.x + 1 * inside_direction * tool_path.bit.radius,
                    start_point.y + 1 * inside_direction * tool_path.bit.radius,
                    start_point.z]
            end

          end

        when :outside
          pt = point_at_distance(point: start_point, distance: tool_path.bit.radius, direction: inside_direction)
        when :fillet
          if long_fillet?
            if slope.nil?

              pt = [start_point.x + -1 * inside_direction * tool_path.bit.radius,
                    start_point.y + inside_direction * tool_path.bit.radius,
                    start_point.z]


            elsif slope.zero?
              pt = [start_point.x + -1 * inside_direction * tool_path.bit.radius,
                    start_point.y + inside_direction * tool_path.bit.radius,
                    start_point.z]

            else
              if slope > 0
                pt = [start_point.x + -1 * inside_direction * tool_path.bit.radius,
                      start_point.y + -1 * inside_direction * tool_path.bit.radius,
                      start_point.z]
              else
                pt = [start_point.x + 1 * inside_direction * tool_path.bit.radius,
                      start_point.y + 1 * inside_direction * tool_path.bit.radius,
                      start_point.z]
              end

            end

          else

          end
        else
          raise ScriptError, "Unsupported profile type #{profile_type}"
      end
      puts "Start Profile #{Sk.point_to_s(pt)}"
      return pt
    end

    def profile_end_point
      case profile_type
        when :on
          end_point
        when :inside
          #   inside_distance = Math.sqrt(2 *  (tool_path.bit.radius ** 2))
          #  pt = point_at_distance(point: end_point, distance: inside_distance, direction: inside_direction)
          if slope.nil?

            pt = [end_point.x + -1 * inside_direction * tool_path.bit.radius,
                  end_point.y + inside_direction * tool_path.bit.radius,
                  end_point.z]

          elsif slope.zero?
            pt = [end_point.x + inside_direction * tool_path.bit.radius,
                  end_point.y + inside_direction * tool_path.bit.radius,
                  end_point.z]
          else
            if slope < 0
              pt = [end_point.x + -1 * inside_direction * tool_path.bit.radius,
                    end_point.y + 1 * inside_direction * tool_path.bit.radius,
                    end_point.z]
            else
              pt = [end_point.x + -1 * inside_direction * tool_path.bit.radius,
                    end_point.y + 1 * inside_direction * tool_path.bit.radius,
                    end_point.z]
            end
          end
        when :outside
          pt = point_at_distance(point: end_point, distance: tool_path.bit.radius, direction: inside_direction)
        when :fillet
          if long_fillet?
            if slope.nil?

              pt = [start_point.x + -1 * inside_direction * tool_path.bit.radius * 2,
                    start_point.y + inside_direction * tool_path.bit.radius,
                    start_point.z]


            elsif slope.zero?
              pt = [start_point.x + -1 * inside_direction * tool_path.bit.radius * 2,
                    start_point.y + inside_direction * tool_path.bit.radius,
                    start_point.z]

            else
              if slope > 0
                pt = [start_point.x + -1 * inside_direction * tool_path.bit.radius * 2,
                      start_point.y + -1 * inside_direction * tool_path.bit.radius * 2,
                      start_point.z]
              else
                pt = [start_point.x + 1 * inside_direction * tool_path.bit.radius * 2,
                      start_point.y + 1 * inside_direction * tool_path.bit.radius * 2,
                      start_point.z]
              end

            end

          else

          end
        else
          raise ScriptError, "Unsupported profile type #{profile_type}"
      end
      puts "End profile #{Sk.point_to_s(pt)}"
      return pt
    end

    def profile_points
      [profile_start_point, profile_end_point]
    end
    def inside_profile?
      profile_type && profile_type == :inside
    end
    def outside_profile?
      profile_type && profile_type ==  :outside
    end
    def on_profile?
      profile_type && profile_type == :on
    end
    def fillet_profile?
      profile_type && profile_type == :fillet
    end
    def short_fillet?
      fillet_profile? && length == tool_path.bit.radius
    end
    def long_fillet?
      fillet_profile? && length == tool_path.bit.diameter
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
    max_length = unordered_loop.collect { |e| e.length }.each_with_index.max

    ordered_loop << {edge: unordered_loop[max_length[1]], direction: 1}
    unordered_loop.delete_at(max_length[1])
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
      #figure out if it is actually a fillet
      if e.length == @bit.radius && ((index + 1 < ordered_loop.length &&
          ordered_loop[index + 1][:edge].length == @bit.diameter) ||
          (index - 1 > 0 &&
              ordered_loop[index - 1][:edge].length == @bit.diameter))
        profile_type = :fillet

      end
      if e.length == @bit.diameter && ((index + 1 < ordered_loop.length &&
          ordered_loop[index + 1][:edge].length == @bit.radius) ||
          (index - 1 > 0 &&
              ordered_loop[index - 1][:edge].length == @bit.radius))
        profile_type = :fillet

      end
      if item[:direction] > 0
        start_point = e.start.position
        end_point = e.end.position
      else
        start_point = e.end.position
        end_point = e.start.position
      end

      slope = Sk.slope(start_point.x, start_point.y, end_point.x, end_point.y) #Doing it in local co-ordinates
      mid_point = Sk.midpoint(point_1: start_point, point_2: end_point, ignore_z: true)
      postive_result = face.classify_point(Sk.point_at_distance(slope: slope, point: mid_point, distance: 0.1, direction: 1))
      negative_result = face.classify_point(Sk.point_at_distance(slope: slope, point: mid_point, distance: 0.1, direction: -1))
      if postive_result <= 4
        inside_direction = 1
      elsif negative_result <= 4 && postive_result > 4
        inside_direction = -1
      end

      puts " Resuls #{postive_result} #{negative_result}"

      if inside_direction.nil?
        raise ScriptError, "#{label} #{slope.nil? ? "Nil" : slope} #{Sk.point_to_s(start_point)} #{Sk.point_to_s(end_point)} Unable to figure out the inside orientation for this edge"
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


    @loops.each do |loop|
      depths = cut_depths(depth: depth)
      depths.each_with_index do |pass_depth, i|
        output << Osbp.comment("Pass #{i + 1} #{pass_depth}") << "\n"

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