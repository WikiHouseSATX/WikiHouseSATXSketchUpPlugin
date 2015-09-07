class WikiHouse::ChrisDesk

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


      @width_method = :depth
      init_board(right_connector: WikiHouse::NoneConnector.new(),
                 top_connector: WikiHouse::NoneConnector.new(),
                 bottom_connector: WikiHouse::NoneConnector.new(),
                 left_connector: WikiHouse::NoneConnector.new(),
                 face_connector: WikiHouse::NoneConnector.new())
    end

    def length
      parent_part.width - (2 * side_offset)
    end
    def side_offset
      parent_part.side_leg_offset + 2 * thickness
    end
    def width
      1.75
    end
  end
  class BackCrossBar
    #This isn't parametric yet
    include WikiHouse::PartHelper
    include WikiHouse::BoardPartHelper
    include WikiHouse::AttributeHelper


    def initialize(parent_part: nil, sheet: nil, group: nil, origin: nil, label: label)
      part_init(origin: origin, sheet: sheet, label: label, parent_part: parent_part)


      @width_method = :depth
      init_board(right_connector: WikiHouse::NoneConnector.new(),
                 top_connector: WikiHouse::NoneConnector.new(),
                 bottom_connector: WikiHouse::NoneConnector.new(),
                 left_connector: WikiHouse::NoneConnector.new(),
                 face_connector: WikiHouse::NoneConnector.new())
    end

    def length
      parent_part.width - (2 * side_offset)
    end
    def side_offset
      parent_part.side_leg_offset + 2 * thickness
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
      30
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
      leg_points << [bounding_c1.x + back_foot_width, bounding_c1.y - length, bounding_c1.z]
      leg_points << [bounding_c1.x + back_foot_width + top_width, bounding_c1.y - length, bounding_c1.z]
      leg_points << [bounding_c1.x + width, bounding_c1.y, bounding_c1.z]
      leg_points << [bounding_c1.x + width - front_foot_width, bounding_c1.y, bounding_c1.z]
      leg_points << [bounding_c1.x + front_leg_from_back_origin, bounding_c1.y - inner_leg_length, bounding_c1.z]
      leg_points << [bounding_c1.x + front_leg_from_back_origin - inner_gap_width, bounding_c1.y - inner_leg_length, bounding_c1.z]

      leg_points << [bounding_c1.x + back_foot_width, bounding_c1.y, bounding_c1.z]
      leg_points
    end
    def draw!

      points = make_points


      lines = Sk.draw_all_points(points)

      face = Sk.add_face(lines)
      set_material(face)



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
    #   @top_cap.rotate(vector: [0, 0, 1], rotation: -90.degrees).move_to(point: origin).
    #       move_by(x: (@top_cap.width - thickness) * -1,
    #               y: 0,
    #               z: length - 2 * @top_cap.thickness).
    #       go!
    @front_cross_bar.draw!
    @front_cross_bar.rotate(vector: [0, 0, 1], rotation: 180.degrees).
        rotate(vector: [0, 1, 0], rotation: 90.degrees).
        move_to(point: origin).
        move_by(x: -1 * length + thickness ,
                 y: -1 * width + @front_cross_bar.side_offset ,
                 z: -1 * front_cross_bar_offset - thickness).go!
    @back_cross_bar.draw!
    @back_cross_bar.rotate(vector: [0, 0, 1], rotation: 180.degrees).
        rotate(vector: [0, 1, 0], rotation: 90.degrees).
        move_to(point: origin).
        move_by(x: -1 * length + thickness ,
                y: -1 * width + @back_cross_bar.side_offset ,
                z: -1 * depth + back_cross_bar_offset).go!

    rear_leg_offset = depth - @left_outer_leg.top_width - front_leg_offset
    
    @left_outer_leg.draw!
   
    @left_outer_leg.rotate(vector: [1, 0, 0], rotation: -90.degrees).
        rotate(vector: [0, 1, 0], rotation: 180.degrees).
         move_to(point: origin).
         move_by(x: -1 * ( depth + @left_outer_leg.back_foot_width  - rear_leg_offset) ,
                 y: length * -1 + thickness,
                 z: -1 * width + side_leg_offset).go!
    @left_inner_leg.draw!
   
    @left_inner_leg.rotate(vector: [1, 0, 0], rotation: -90.degrees).
        rotate(vector: [0, 1, 0], rotation: 180.degrees).
        move_to(point: origin).
        move_by(x: -1 * ( depth + @left_inner_leg.back_foot_width  - rear_leg_offset) ,
                y: length * -1 + thickness ,
                z: -1 * width + side_leg_offset + thickness).go!

    @right_outer_leg.draw!

    @right_outer_leg.rotate(vector: [1, 0, 0], rotation: -90.degrees).
        rotate(vector: [0, 1, 0], rotation: 180.degrees).
        move_to(point: origin).
        move_by(x: -1 * ( depth + @right_outer_leg.back_foot_width  - rear_leg_offset) ,
                y: length * -1 + thickness,
                z: -1 * ( thickness + side_leg_offset)).go!
    @right_inner_leg.draw!

    @right_inner_leg.rotate(vector: [1, 0, 0], rotation: -90.degrees).
        rotate(vector: [0, 1, 0], rotation: 180.degrees).
        move_to(point: origin).
        move_by(x: -1 * ( depth + @right_inner_leg.back_foot_width  - rear_leg_offset) ,
                y: length * -1 + thickness ,
                z:  -1 * (side_leg_offset + 2 * thickness)).go!
    
    groups = [@top.group, @front_cross_bar.group, @back_cross_bar.group,
              @left_outer_leg.group, @left_inner_leg.group, @right_outer_leg.group, @right_inner_leg.group]


    set_group(groups.compact)
  end


end