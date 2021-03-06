module WikiHouse::BoardPartHelper


  def self.tag_dictionary
    "WikiHouse"
  end

  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def tag_dictionary
      WikiHouse::PartHelper.tag_dictionary
    end
  end

  attr_reader :top_connector, :right_connector,
              :bottom_connector, :left_connector, :face_connector


  def init_board(top_connector: nil, bottom_connector: nil, left_connector: nil, right_connector: nil, face_connector: nil)
    @top_side_points = @right_side_points = @bottom_side_points = @left_side_points = []
    @top_connector = top_connector ? top_connector : WikiHouse::NoneConnector.new()
    @right_connector = right_connector ? right_connector : WikiHouse::NoneConnector.new()
    @bottom_connector = bottom_connector ? bottom_connector : WikiHouse::NoneConnector.new()
    @left_connector = left_connector ? left_connector : WikiHouse::NoneConnector.new()
    @face_connector = face_connector ? face_connector : WikiHouse::NoneConnector.new()


  end

  def get_connector_by_side_and_name(side: :top, name: :pocket)
    case side
      when :top
        connector = @top_connector
      when :right
        connector = @right_connector
      when :bottom
        connector = @bottom_connector
      when :left
        connector = @left
      when :face
        connector = @face_connector
      else
        raise ArgumentError, "Sorry #{side} is not a valid side"

    end
    if connector.respond_to?(:each)
      connector.each do |c|
        return c if c.name == name
      end
      return nil
    else
      return connector.name == name ? connector : nil
    end
  end

  def points
    [@top_side_points[0...-1], @right_side_points[0...-1], @bottom_side_points[0...-1], @left_side_points[0...-1]].flatten(1)
  end


  def length
    parent_part.send(@length_method)
  end

  def width
    parent_part.send(@width_method)
  end

  #Bounding points define the platonic ideal of the baord
  #bounding_c1 - upper left corner
  #bounding_c2 - upper right corner
  #bounding_c3 - lower right corner
  #bounding_c4 - lower left corner
  def bounding_c1
    @origin.dup
  end

  def bounding_c2
    [bounding_c1.x + width, bounding_c1.y, bounding_c1.z]
  end

  def bounding_c3
    [bounding_c1.x + width, bounding_c1.y - length, bounding_c1.z]
  end

  def bounding_c4
    [bounding_c1.x, bounding_c1.y - length, bounding_c1.z]
  end


  def calculate_starting_thickness(connector: connector)
    starting_thickness = 0

    if top?(connector) && (@left_connector.tab? || @left_connector.rip?)
      starting_thickness = @left_connector.length
    elsif bottom?(connector) && (@right_connector.tab? || @right_connector.rip?)
      starting_thickness = @right_connector.length
    elsif right?(connector) && (@top_connector.tab? || @top_connector.rip?)
      starting_thickness = @top_connector.length
    elsif left?(connector) && (@bottom_connector.tab? || @bottom_connector.rip?)
      starting_thickness = @bottom_connector.length

    end

    starting_thickness
  end


  def build_connector(connector: nil, start_pt: nil, end_pt: nil)
    total_length = top?(connector) || bottom?(connector) ? width : length
    tabs_too_big?(total_length,
                  connector.count * connector.length,
                  connector: connector)
    if top?(connector)
      bounding_start = bounding_c1
      bounding_end = bounding_c2

    elsif right?(connector)
      bounding_start = bounding_c2
      bounding_end = bounding_c3


    elsif bottom?(connector)
      bounding_start = bounding_c3
      bounding_end = bounding_c4
    elsif left?(connector)
      bounding_start = bounding_c4
      bounding_end = bounding_c1


    else
      raise ArgumentError, :"Unsupported orientation"
    end
    return(connector.points(bounding_start: bounding_start,
                            bounding_end: bounding_end,
                            start_pt: start_pt,
                            end_pt: end_pt,
                            orientation: side_name(connector),
                            total_length: total_length,
                            starting_thickness: calculate_starting_thickness(connector: connector)))
  end


  def side_name(connector)
    return :top if top?(connector)
    return :left if left?(connector)
    return :right if right?(connector)
    return :bottom if bottom?(connector)
    return :face if face?(connector)
    nil
  end

  def tabs_too_big?(side_length, tab_total_length, connector: nil)
    raise ScriptError, "Too Many Tabs or They Are Too Big Max is #{side_length} #{connector ? " for #{side_name(connector)}" : ""}" if tab_total_length > side_length
    true
  end

  def build_top_side
    top_first = bounding_c1
    top_last = bounding_c2

    @top_side_points = build_connector(connector: @top_connector,
                                       start_pt: top_first,
                                       end_pt: top_last)


  end

  def build_right_side
    @right_side_points = build_connector(connector: @right_connector,
                                         start_pt: @top_side_points.last,
                                         end_pt: @bottom_side_points.first)

    if @right_connector.rip? || @right_connector.shelfie_hook? || @right_connector.tab?
      #need to figure out if it has been filleted
      last_points = [@top_side_points[@top_side_points.length - 1],
                     @top_side_points[@top_side_points.length - 2],
                     @top_side_points[@top_side_points.length - 3]]

      if last_points[1].x < @right_side_points.first.x
        @top_side_points[@top_side_points.length - 1] = @right_side_points.first
      else
        #puts "Going into a fillet"

        @top_side_points.pop(3)

        @right_side_points[0] = [@right_side_points.first.x, last_points[2].y, @right_side_points.first.z]
        @top_side_points << @right_side_points.first
      end
      next_points = [@bottom_side_points[0],
                     @bottom_side_points[1],
                     @bottom_side_points[2]]

      if @right_side_points.last.x > next_points[1].x
        @bottom_side_points[0] = @right_side_points.last
      else
       # puts "Going into a fillet"
        @bottom_side_points.shift(3)
        @right_side_points[@right_side_points.length - 1] = [@right_side_points.last.x, next_points[2].y, @right_side_points.last.z]
        @bottom_side_points.unshift(@right_side_points.last)
      end


    end
  end

  def build_bottom_side
    bottom_first = bounding_c3
    bottom_last = bounding_c4
    @bottom_side_points = build_connector(connector: @bottom_connector,
                                          start_pt: bottom_first,
                                          end_pt: bottom_last)

  end

  def build_left_side
    @left_side_points = build_connector(connector: @left_connector,
                                        start_pt: @bottom_side_points.last,
                                        end_pt: @top_side_points.first)

    if @left_connector.rip? || @left_connector.shelfie_hook? || @left_connector.tab?
      @bottom_side_points[@bottom_side_points.length - 1] = @left_side_points.first
      last_points = [@bottom_side_points[@bottom_side_points.length - 1],
                     @bottom_side_points[@bottom_side_points.length - 2],
                     @bottom_side_points[@bottom_side_points.length - 3]]

      if last_points[1].x > @left_side_points.first.x
        @bottom_side_points[@bottom_side_points.length - 1] = @left_side_points.first
      else
        #puts "Going into a fillet"

        @bottom_side_points.pop(3)

        @left_side_points[0] = [@left_side_points.first.x, last_points[2].y, @left_side_points.first.z]
        @bottom_side_points << @left_side_points.first
      end
      
      
      
      next_points = [@top_side_points[0],
                     @top_side_points[1],
                     @top_side_points[2]]

      if @left_side_points.last.x < next_points[1].x
        @top_side_points[0] = @left_side_points.last
      else
        #puts "Going into a fillet"
        @top_side_points.shift(3)
        @left_side_points[@left_side_points.length - 1] = [@left_side_points.last.x, next_points[2].y, @left_side_points.last.z]
        @top_side_points.unshift(@left_side_points.last)
      end


    end
  end

  def face?(c)
    c == @face_connector
  end

  def top?(c)
    c == @top_connector
  end

  def left?(c)
    c == @left_connector
  end

  def right?(c)
    c == @right_connector
  end

  def bottom?(c)
    c == @bottom_connector
  end


  def add_face_connector(connector)
    if @face_connector.is_a?(Array)
      @face_connector.concat(connector)
    else
      @face_connector = [@face_connector, connector]
    end
    @face_connector
  end

  def build_points
    build_top_side
    build_bottom_side

    build_right_side
    build_left_side
    points
  end

  def draw_non_groove_faces
    if @face_connector.is_a?(Array)

      @face_connector.each do |c|
        c.draw!(bounding_origin: bounding_c1,
                part_length: length,
                part_width: width) unless c.groove?
      end

    else
      @face_connector.draw!(bounding_origin: bounding_c1, part_length: length, part_width: width) unless @face_connector.groove?

    end
  end

  def draw_groove_faces
    if @face_connector.is_a?(Array)

      @face_connector.each do |c|
        c.draw!(bounding_origin: bounding_c1,
                part_length: length,
                part_width: width) if c.groove?
      end

    else
      @face_connector.draw!(bounding_origin: bounding_c1, part_length: length, part_width: width) if @face_connector.groove?

    end
  end

  def draw_edges!
    build_points
    Sk.draw_all_points(points)
  end

  def draw_primary_face(lines)
    face = Sk.add_face(lines)
    draw_non_groove_faces

    set_material(face)
    make_part_right_thickness(face)
    face
  end

  def draw!

    lines = draw_edges!

    face = draw_primary_face(lines)
    Sk.add_face(lines)

    draw_groove_faces

    set_group(face.all_connected)
    mark_primary_face!(face)
  end

  def set_default_properties
    mark_cutable!
  end

  def fuse(onto: nil, from: nil, other_part: nil)
    raise ArgumentError, "#{onto}/#{from} is not a valid side for fusing" unless [:bottom].include?(onto) && [:top].include?(from)
    if onto == :bottom
      if from == :top

        join_points = @bottom_side_points.clone[1...-1].concat(other_part.top_side_points[1...-1])
        unique_points = join_points.collect { |pt| [Sk.round(pt.x), Sk.round(pt.y), Sk.round(pt.z)] }.uniq #had to round to handle too many decimals in fuse
        @bottom_side_points = other_part.bottom_side_points

        @right_side_points.pop
        @right_side_points.concat(other_part.right_side_points)
        # Sk.draw_line([100, 100, 0], @bottom_side_points.first)
        # Sk.draw_line([100, 100, 0], @bottom_side_points.last)
        new_left_side = other_part.left_side_points[0...-1].clone
        @left_side_points = new_left_side.concat(@left_side_points)
        # Sk.draw_line([100, 100, 0], @left_side_points.first)
        # Sk.draw_line([100, 100, 0], @left_side_points.last)
        #
        return(unique_points)
      end

    end

  end

  def top_side_points
    @top_side_points
  end

  def bottom_side_points
    @bottom_side_points
  end

  def right_side_points
    @right_side_points
  end

  def left_side_points
    @left_side_points
  end

end
