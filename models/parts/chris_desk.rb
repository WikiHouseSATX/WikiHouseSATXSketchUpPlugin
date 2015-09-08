class WikiHouse::ChrisDesk
  class LegPocketConnector< WikiHouse::PocketConnector


    def initialize(thickness: nil, width_in_t: 8)
      super(length_in_t: 1, width_in_t: width_in_t, thickness: thickness, rows: 1, count: 1)

    end

    def draw!(bounding_origin: nil, part_length: nil, part_width: nil)

      half_width_part = part_width/2.0
      half_width_connector = width/2.0

      offset = 2 * thickness

      return draw_pocket!(location: [bounding_origin.x + half_width_part - half_width_connector,
                                     bounding_origin.y - part_length + offset,
                                     bounding_origin.z])

    end

    def rows
      1
    end

    def count
      1
    end


    def leg_pocket?
      true
    end

    def name
      :leg_pocket
    end

  end
  class Desktop
    include WikiHouse::PartHelper
    include WikiHouse::BoardPartHelper
    include WikiHouse::AttributeHelper

    def initialize(parent_part: nil, sheet: nil, group: nil, origin: nil, label: label)
      part_init(origin: origin, sheet: sheet, label: label, parent_part: parent_part)

      @length_method = :width
      @width_method = :depth
      init_board(right_connector: WikiHouse::NoneConnector.new(),
                 top_connector: WikiHouse::NoneConnector.new(),
                 bottom_connector: WikiHouse::NoneConnector.new(),
                 left_connector: WikiHouse::NoneConnector.new(),
                 face_connector: WikiHouse::NoneConnector.new())
    end

  end
  class FrontCrossBar
    #This isn't parametric yet
    include WikiHouse::PartHelper
    include WikiHouse::BoardPartHelper
    include WikiHouse::AttributeHelper


    def initialize(parent_part: nil, sheet: nil, group: nil, origin: nil, label: label)
      part_init(origin: origin, sheet: sheet, label: label, parent_part: parent_part)




      init_board(left_connector: WikiHouse::TabConnector.new(count: 3, thickness: thickness, width_in_t: 3),
                 top_connector: WikiHouse::TabConnector.new(count: 1, length_in_t: 2, thickness: thickness, width_in_t: 1),
                 bottom_connector: WikiHouse::TabConnector.new(count: 1, length_in_t: 2, thickness: thickness, width_in_t: 1),
                 right_connector: WikiHouse::NoneConnector.new,
                 face_connector: WikiHouse::NoneConnector.new())


    end
    def length
      parent_part.width - 2 * parent_part.side_leg_offset
    end


    def width
      1.75 + thickness
    end
  end
  class BackCrossBar
    #This isn't parametric yet
    include WikiHouse::PartHelper
    include WikiHouse::BoardPartHelper
    include WikiHouse::AttributeHelper


    def initialize(parent_part: nil, sheet: nil, group: nil, origin: nil, label: label)
      part_init(origin: origin, sheet: sheet, label: label, parent_part: parent_part)


      @length_method = :width
      init_board(left_connector: WikiHouse::TabConnector.new(count: 3, thickness: thickness, width_in_t: 3),
                 top_connector: WikiHouse::TabConnector.new(count: 1, length_in_t: 2, thickness: thickness, width_in_t: 3),
                 bottom_connector: WikiHouse::TabConnector.new(count: 1, length_in_t: 2, thickness: thickness, width_in_t: 3),
                 right_connector: WikiHouse::NoneConnector.new,
                 face_connector: WikiHouse::NoneConnector.new())

    end
    def length
      parent_part.width - 2 * parent_part.side_leg_offset
    end
    def width
      5.0
    end
  end
  class Leg
    #This isn't parametric yet
    include WikiHouse::PartHelper

    include WikiHouse::AttributeHelper


    def initialize(parent_part: nil, sheet: nil, group: nil, origin: nil, label: label)
      part_init(origin: origin, sheet: sheet, label: label, parent_part: parent_part)


    end

    def origin=(new_origin)
      @origin = new_origin
    end

    def length
      30 + thickness
    end

    def width
      26
    end

    def bounding_c1
      @origin.dup
    end

    def back_foot_width
      3.0
    end

    def front_foot_width
      2.5
    end

    def top_width
      15.0
    end

    def inner_gap_width
      6.0
    end

    def inner_leg_length
      24
    end

    def front_leg_from_back_origin
      14
    end

    def make_points
      t = thickness
      leg_points = []
      leg_points << [bounding_c1.x, bounding_c1.y, bounding_c1.z]
      leg_points << [bounding_c1.x + back_foot_width, bounding_c1.y - length + thickness, bounding_c1.z]

      #Top Tab
      leg_points << [bounding_c1.x + back_foot_width + 5, bounding_c1.y - length + thickness, bounding_c1.z]
      leg_points << [bounding_c1.x + back_foot_width + 5, bounding_c1.y - length, bounding_c1.z]
      leg_points << [bounding_c1.x + back_foot_width + 10, bounding_c1.y - length, bounding_c1.z]
      leg_points << [bounding_c1.x + back_foot_width + 10, bounding_c1.y - length + thickness, bounding_c1.z]
      # leg_points << [bounding_c1.x + back_foot_width + 5, bounding_c1.y - length + thickness, bounding_c1.z]
      # leg_points << [bounding_c1.x + back_foot_width + 5, bounding_c1.y - length  , bounding_c1.z]
      # leg_points << [bounding_c1.x + back_foot_width + 10, bounding_c1.y - length  , bounding_c1.z]
      # leg_points << [bounding_c1.x + back_foot_width + 10, bounding_c1.y - length + thickness  , bounding_c1.z]
      #


      leg_points << [bounding_c1.x + back_foot_width + top_width, bounding_c1.y - length + thickness, bounding_c1.z]
      leg_points << [bounding_c1.x + width, bounding_c1.y, bounding_c1.z]
      leg_points << [bounding_c1.x + width - front_foot_width, bounding_c1.y, bounding_c1.z]
      leg_points << [bounding_c1.x + front_leg_from_back_origin, bounding_c1.y - inner_leg_length, bounding_c1.z]
      leg_points << [bounding_c1.x + front_leg_from_back_origin - inner_gap_width, bounding_c1.y - inner_leg_length, bounding_c1.z]

      leg_points << [bounding_c1.x + back_foot_width, bounding_c1.y, bounding_c1.z]
      leg_points
    end
    def make_pockets!


      t = thickness


      pockets = []
      #front cross bar pocket

      c5 =  [bounding_c1.x + back_foot_width + top_width - 2 - t, bounding_c1.y - length + t + t + 0.125, bounding_c1.z]

      c6 = [c5.x + t, c5.y, c5.z]
      c7 = [c6.x, c5.y - t, c5.z]
      c8 = [c5.x, c7.y, c5.z]
      points = [c5, c6, c7, c8]

      WikiHouse::Fillet.pocket_by_points(points)

      pocket_lines = Sk.draw_all_points(points)
      pocket_lines.each { |e| mark_inside_edge!(e) }
      pockets << pocket_lines
      #back cross bar pocket
      #
      c5 = [bounding_c1.x + back_foot_width + 1.25 , bounding_c1.y - length + t + 0.625 + 3 * t, bounding_c1.z]
      c6 = [c5.x + t, c5.y, c5.z]
      c7 = [c6.x, c5.y - 3 * t, c5.z]
      c8 = [c5.x, c7.y, c5.z]
      points = [c5, c6, c7, c8]

      WikiHouse::Fillet.pocket_by_points(points)

      pocket_lines = Sk.draw_all_points(points)
      pocket_lines.each { |e| mark_inside_edge!(e) }
      pockets << pocket_lines

      pockets

    end
    def make_dowels!

      return [] if WikiHouse.machine.bit_radius == 0
      t = thickness

      dowel_points = []
      #Back Leg Dowels
      dowel_points << [bounding_c1.x + 1.5, bounding_c1.y - 1, bounding_c1.z]
      dowel_points << [bounding_c1.x + 2.1, bounding_c1.y - 4, bounding_c1.z]
      dowel_points << [bounding_c1.x + 2.7, bounding_c1.y - 8, bounding_c1.z]
      dowel_points << [bounding_c1.x + 3.3, bounding_c1.y - 12, bounding_c1.z]
      dowel_points << [bounding_c1.x + 3.9, bounding_c1.y - 16, bounding_c1.z]
      dowel_points << [bounding_c1.x + 4.5, bounding_c1.y - 20, bounding_c1.z]
      dowel_points << [bounding_c1.x + 5.1, bounding_c1.y - 24, bounding_c1.z]
      dowel_points << [bounding_c1.x + 5.7, bounding_c1.y - 28, bounding_c1.z]

      #ftont leg dowels
      dowel_points << [bounding_c1.x + 24.25, bounding_c1.y - 1, bounding_c1.z]
      dowel_points << [bounding_c1.x + 23, bounding_c1.y - 4, bounding_c1.z]
      dowel_points << [bounding_c1.x + 21.8, bounding_c1.y - 8, bounding_c1.z]
      dowel_points << [bounding_c1.x + 20.6, bounding_c1.y - 12, bounding_c1.z]
      dowel_points << [bounding_c1.x + 19.4, bounding_c1.y - 16, bounding_c1.z]
      dowel_points << [bounding_c1.x + 18.2, bounding_c1.y - 20, bounding_c1.z]
      dowel_points << [bounding_c1.x + 17, bounding_c1.y - 24, bounding_c1.z]
      dowel_points << [bounding_c1.x + 15.8, bounding_c1.y - 28, bounding_c1.z]

      # Mid
      dowel_points << [bounding_c1.x + 10, bounding_c1.y - 25.5 , bounding_c1.z]
      dowel_points << [bounding_c1.x + 10, bounding_c1.y - 28, bounding_c1.z]

      dowels = []
      dowel_points.each { |d| dowels << Sk.draw_circle(center_point: d, radius: WikiHouse.machine.bit_radius) }
      dowels.each { |d| d.each { |e| mark_inside_edge!(e) } }

      dowels
    end

    def draw!

      points = make_points


      lines = Sk.draw_all_points(points)
      if WikiHouse.machine.bit_radius != 0
        dowels = make_dowels!
      else
        dowels = []
      end
      
      pockets = make_pockets!
      
      face = Sk.add_face(lines)
      set_material(face)

      dowels.each do |sp|
        dowel_face = Sk.add_face(sp)
        dowel_face.erase!
      end
      pockets.each do |sp|
        pocket_face = Sk.add_face(sp)
        pocket_face.erase!
      end

      make_part_right_thickness(face)
      Sk.add_face(lines)

      set_group(face.all_connected)
      mark_primary_face!(face)
    end

    def set_default_properties
      mark_cutable!
    end
  end
  include WikiHouse::PartHelper


  def initialize(origin: nil, sheet: nil, label: nil, parent_part: nil)
    part_init(sheet: sheet, origin: origin, parent_part: parent_part)

    @top = Desktop.new(label: "Top", origin: @origin, sheet: sheet, parent_part: self)
    @front_cross_bar = FrontCrossBar.new(label: "Front Cross bar", origin: @origin, sheet: sheet, parent_part: self)
    @back_cross_bar = BackCrossBar.new(label: "Back Cross bar", origin: @origin, sheet: sheet, parent_part: self)

    @left_outer_leg = Leg.new(label: "Left Outer Leg", origin: @origin, sheet: sheet, parent_part: self)
    @left_inner_leg = Leg.new(label: "Left Inner Leg", origin: @origin, sheet: sheet, parent_part: self)


    @right_outer_leg = Leg.new(label: "Right Outer Leg", origin: @origin, sheet: sheet, parent_part: self)
    @right_inner_leg = Leg.new(label: "Right Inner Leg", origin: @origin, sheet: sheet, parent_part: self)


  end

  def origin=(new_origin)
    @origin = new_origin
    @top.origin = @origin
    @front_cross_bar.origin = @origin
    @back_cross_bar.origin = @origin
    @left_outer_leg.origin = @origin
    @left_inner_leg.origin = @origin
    @right_outer_leg.origin = @origin
    @right_inner_leg.origin = @origin
  end

  def length
    value = 30.775
    sheet.length == 24 ? value/4.0 : value
  end


  def width
    value = 64
    sheet.length == 24 ? value/4.0 : value
  end


  def depth
    value = 26
    sheet.length == 24 ? value/4.0 : value
  end

  def side_leg_offset # Gap between edge of top and the outer leg
    1.25
  end

  def front_leg_offset
    6
  end

  def front_cross_bar_offset #Gap between edge of top and the front cross bar
    8.0
  end

  def back_cross_bar_offset # Gap between edge of top and the back cross bar
    6.25
  end

  def draw!
    Sk.find_or_create_layer(name: self.class.name)
    Sk.make_layer_active_name(name: self.class.name)

    @top.draw!
    @top.move_by(x: 0,
                 y: 0,
                 z: length - thickness).go!

    @front_cross_bar.draw!
    @front_cross_bar.rotate(vector: [0, 0, 1], rotation: 180.degrees).
        rotate(vector: [0, 1, 0], rotation: 90.degrees).
        move_to(point: origin).
        move_by(x: -1 * length ,
                y: -1 * width + side_leg_offset,
                z: -1 * front_cross_bar_offset - thickness).go!
    @back_cross_bar.draw!
    @back_cross_bar.rotate(vector: [0, 0, 1], rotation: 180.degrees).
        rotate(vector: [0, 1, 0], rotation: 90.degrees).
        move_to(point: origin).
        move_by(x: -1 * length,
                y: -1 * width + side_leg_offset,
                z: -1 * depth + back_cross_bar_offset).go!

    rear_leg_offset = depth - @left_outer_leg.top_width - front_leg_offset

    @left_outer_leg.draw!

    @left_outer_leg.rotate(vector: [1, 0, 0], rotation: -90.degrees).
        rotate(vector: [0, 1, 0], rotation: 180.degrees).
         move_to(point: origin).
         move_by(x: -1 * ( depth + @left_outer_leg.back_foot_width  - rear_leg_offset) ,
                 y: length * -1 ,
                 z: -1 * width + side_leg_offset).go!
    @left_inner_leg.draw!

    @left_inner_leg.rotate(vector: [1, 0, 0], rotation: -90.degrees).
        rotate(vector: [0, 1, 0], rotation: 180.degrees).
        move_to(point: origin).
        move_by(x: -1 * (depth + @left_inner_leg.back_foot_width - rear_leg_offset),
                y: length * -1 ,
                z: -1 * width + side_leg_offset + thickness).go!

    @right_outer_leg.draw!

    @right_outer_leg.rotate(vector: [1, 0, 0], rotation: -90.degrees).
        rotate(vector: [0, 1, 0], rotation: 180.degrees).
        move_to(point: origin).
        move_by(x: -1 * ( depth + @right_outer_leg.back_foot_width  - rear_leg_offset) ,
                y: length * -1,
                z: -1 * ( thickness + side_leg_offset)).go!
    @right_inner_leg.draw!

    @right_inner_leg.rotate(vector: [1, 0, 0], rotation: -90.degrees).
        rotate(vector: [0, 1, 0], rotation: 180.degrees).
        move_to(point: origin).
        move_by(x: -1 * (depth + @right_inner_leg.back_foot_width - rear_leg_offset),
                y: length * -1 ,
                z: -1 * (side_leg_offset + 2 * thickness)).go!

    groups = [@top.group, @front_cross_bar.group, @back_cross_bar.group,
              @left_outer_leg.group, @left_inner_leg.group, @right_outer_leg.group, @right_inner_leg.group]


    set_group(groups.compact)
  end


end