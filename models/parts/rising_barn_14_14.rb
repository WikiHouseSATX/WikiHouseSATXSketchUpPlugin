class WikiHouse::RisingBarn1414
  include WikiHouse::PartHelper
  SIP_OFFSET = 3.0/32.0


  class BarnPart
    include WikiHouse::PartHelper

    include WikiHouse::AttributeHelper


    def initialize(parent_part: nil, sheet: nil, group: nil, origin: nil, label: label)
      part_init(origin: origin, sheet: sheet, label: label, parent_part: parent_part)
    end

    def origin=(new_origin)
      @origin = new_origin
    end

    def bounding_c1
      @origin.dup
    end

    def make_points
      t = thickness
      part_points = []
      part_points << [bounding_c1.x, bounding_c1.y, bounding_c1.z]
      part_points << [bounding_c1.x, bounding_c1.y + length, bounding_c1.z]
      part_points << [bounding_c1.x + width, bounding_c1.y + length, bounding_c1.z]
      part_points << [bounding_c1.x + width, bounding_c1.y, bounding_c1.z]
      part_points
    end

    def make_pockets!
      []
    end

    def draw!

      points = make_points


      lines = Sk.draw_all_points(points)
      pockets = make_pockets!

      face = Sk.add_face(lines)
      set_material(face)

      if pockets && pockets.length > 0
        pockets.each do |sp|
          pocket_face = Sk.add_face(sp)
          pocket_face.erase!
        end
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
  class Spline < BarnPart

      #this is just a part with a fixed width and a variable length
    def initialize(length: nil, parent_part: nil,  group: nil, origin: nil, label: label)
      part_init(origin: origin, sheet: WikiHouse::Basswood332Sheet.new, label: label, parent_part: parent_part)
      @length = length
    end
    def length
      @length

    end
    def width
      WikiHouse::CoroplastSheet.new.thickness
    end
  end

  class LeftWallFace < BarnPart
    def length
      6.591
    end

    def width
      9.227
    end

    def make_points
      t = thickness
      part_points = []
      part_points << [bounding_c1.x, bounding_c1.y, bounding_c1.z]
      part_points << [bounding_c1.x, bounding_c1.y + 6.591, bounding_c1.z]
      part_points << [bounding_c1.x + width, bounding_c1.y + length, bounding_c1.z]
      part_points << [bounding_c1.x + width, bounding_c1.y, bounding_c1.z]
      part_points << [bounding_c1.x + 8.623, bounding_c1.y, bounding_c1.z]
      part_points << [bounding_c1.x + 8.623, bounding_c1.y + 4.394, bounding_c1.z]
      part_points << [bounding_c1.x + 4.487, bounding_c1.y + 4.394, bounding_c1.z]
      part_points << [bounding_c1.x + 4.487, bounding_c1.y, bounding_c1.z]

      part_points
    end

  end
  class LeftWallInside <LeftWallFace
    def make_points
      t = thickness
      part_points = []
      part_points << [bounding_c1.x, bounding_c1.y + SIP_OFFSET, bounding_c1.z]
      part_points << [bounding_c1.x, bounding_c1.y + 6.591, bounding_c1.z]
      part_points << [bounding_c1.x + width, bounding_c1.y + length, bounding_c1.z]
      part_points << [bounding_c1.x + width, bounding_c1.y + SIP_OFFSET, bounding_c1.z]
      part_points << [bounding_c1.x + 8.623, bounding_c1.y + SIP_OFFSET, bounding_c1.z]
      part_points << [bounding_c1.x + 8.623, bounding_c1.y + 4.394, bounding_c1.z]
      part_points << [bounding_c1.x + 4.487, bounding_c1.y + 4.394, bounding_c1.z]
      part_points << [bounding_c1.x + 4.487, bounding_c1.y + SIP_OFFSET, bounding_c1.z]

      part_points
    end


  end
  class RightWallFace < BarnPart
    def length
      6.591
    end

    def width
      9.227
    end

    def make_points
      t = thickness
      part_points = []
      part_points << [bounding_c1.x, bounding_c1.y, bounding_c1.z]
      part_points << [bounding_c1.x, bounding_c1.y + 6.591, bounding_c1.z]
      part_points << [bounding_c1.x + width, bounding_c1.y + length, bounding_c1.z]
      part_points << [bounding_c1.x + width, bounding_c1.y, bounding_c1.z]

      part_points
    end

    def make_pockets!

      pockets = []
      #Window

      window_width = 0.989
      window_length = 1.648
      c5 = [bounding_c1.x + 2.636,
            bounding_c1.y + 2.746,
            bounding_c1.z]

      c6 = [c5.x, c5.y + window_length, c5.z]
      c7 = [c5.x + window_width, c5.y + window_length, c5.z]
      c8 = [c5.x + window_width, c5.y, c5.z]
      points = [c5, c6, c7, c8]

      pocket_lines = Sk.draw_all_points(points)
      pocket_lines.each { |e| mark_inside_edge!(e) }
      pockets << pocket_lines

      pockets

    end


  end
  class RightWallInside <RightWallFace
    def make_points
      t = thickness
      part_points = []
      part_points << [bounding_c1.x, bounding_c1.y + SIP_OFFSET, bounding_c1.z]
      part_points << [bounding_c1.x, bounding_c1.y + 6.591, bounding_c1.z]
      part_points << [bounding_c1.x + width, bounding_c1.y + length, bounding_c1.z]
      part_points << [bounding_c1.x + width, bounding_c1.y + SIP_OFFSET, bounding_c1.z]

      part_points
    end


  end

  class BackWallFace < BarnPart
    def length
      10.463
    end

    def width
      9.227
    end

    def make_points
      t = thickness
      part_points = []
      part_points << [bounding_c1.x, bounding_c1.y, bounding_c1.z]
      part_points << [bounding_c1.x, bounding_c1.y + 6.591, bounding_c1.z]
      part_points << [bounding_c1.x + 4.517, bounding_c1.y + 10.463, bounding_c1.z]
      part_points << [bounding_c1.x + 4.517, bounding_c1.y + 9.969, bounding_c1.z]
      part_points << [bounding_c1.x + 4.710, bounding_c1.y + 9.969, bounding_c1.z]
      part_points << [bounding_c1.x + 4.710, bounding_c1.y + 10.463, bounding_c1.z]
      part_points << [bounding_c1.x + width, bounding_c1.y + 6.591, bounding_c1.z]
      part_points << [bounding_c1.x + width, bounding_c1.y, bounding_c1.z]

      part_points
    end
  end
  class BackWallInside < BackWallFace
    def make_points
      t = thickness
      part_points = []
      part_points << [bounding_c1.x, bounding_c1.y + SIP_OFFSET, bounding_c1.z]
      part_points << [bounding_c1.x, bounding_c1.y + 6.591, bounding_c1.z]
      part_points << [bounding_c1.x + 4.517, bounding_c1.y + 10.463, bounding_c1.z]
      part_points << [bounding_c1.x + 4.517, bounding_c1.y + 9.969, bounding_c1.z]
      part_points << [bounding_c1.x + 4.710, bounding_c1.y + 9.969, bounding_c1.z]
      part_points << [bounding_c1.x + 4.710, bounding_c1.y + 10.463, bounding_c1.z]
      part_points << [bounding_c1.x + width, bounding_c1.y + 6.591, bounding_c1.z]
      part_points << [bounding_c1.x + width, bounding_c1.y + SIP_OFFSET, bounding_c1.z]


      part_points
    end
  end
  class FrontWallFace < BarnPart
    def length
      10.463
    end

    def width
      9.227
    end

    def make_points
      t = thickness
      part_points = []
      part_points << [bounding_c1.x, bounding_c1.y, bounding_c1.z]
      part_points << [bounding_c1.x, bounding_c1.y + 6.591, bounding_c1.z]
      part_points << [bounding_c1.x + 4.517, bounding_c1.y + 10.463, bounding_c1.z]
      part_points << [bounding_c1.x + 4.517, bounding_c1.y + 9.969, bounding_c1.z]
      part_points << [bounding_c1.x + 4.710, bounding_c1.y + 9.969, bounding_c1.z]
      part_points << [bounding_c1.x + 4.710, bounding_c1.y + 10.463, bounding_c1.z]
      part_points << [bounding_c1.x + width, bounding_c1.y + 6.591, bounding_c1.z]
      part_points << [bounding_c1.x + width, bounding_c1.y, bounding_c1.z]

      part_points << [bounding_c1.x + 2.763, bounding_c1.y, bounding_c1.z]
      part_points << [bounding_c1.x + 2.763, bounding_c1.y + 4.394, bounding_c1.z]
      part_points << [bounding_c1.x + 0.601, bounding_c1.y + 4.394, bounding_c1.z]
      part_points << [bounding_c1.x + 0.601, bounding_c1.y, bounding_c1.z]


      part_points
    end
  end
  class FrontWallInside < FrontWallFace
    def make_points
      t = thickness
      part_points = []
      part_points << [bounding_c1.x, bounding_c1.y + SIP_OFFSET, bounding_c1.z]
      part_points << [bounding_c1.x, bounding_c1.y + 6.591, bounding_c1.z]
      part_points << [bounding_c1.x + 4.517, bounding_c1.y + 10.463, bounding_c1.z]
      part_points << [bounding_c1.x + 4.517, bounding_c1.y + 9.969, bounding_c1.z]
      part_points << [bounding_c1.x + 4.710, bounding_c1.y + 9.969, bounding_c1.z]
      part_points << [bounding_c1.x + 4.710, bounding_c1.y + 10.463, bounding_c1.z]
      part_points << [bounding_c1.x + width, bounding_c1.y + 6.591, bounding_c1.z]
      part_points << [bounding_c1.x + width, bounding_c1.y + SIP_OFFSET, bounding_c1.z]

      part_points << [bounding_c1.x + 2.763, bounding_c1.y + SIP_OFFSET, bounding_c1.z]
      part_points << [bounding_c1.x + 2.763, bounding_c1.y + 4.394, bounding_c1.z]
      part_points << [bounding_c1.x + 0.601, bounding_c1.y + 4.394, bounding_c1.z]
      part_points << [bounding_c1.x + 0.601, bounding_c1.y + SIP_OFFSET, bounding_c1.z]


      part_points
    end
  end
  class RoofFace < BarnPart
    #This isn't parametric yet

    def length
      6.382
    end

    def width
      9.227
    end


    def make_points
      t = thickness
      part_points = []
      part_points << [bounding_c1.x, bounding_c1.y, bounding_c1.z]
      part_points << [bounding_c1.x, bounding_c1.y + length, bounding_c1.z]
      part_points << [bounding_c1.x + width, bounding_c1.y + length, bounding_c1.z]
      part_points << [bounding_c1.x + width, bounding_c1.y, bounding_c1.z]
      part_points
    end

  end
  class RoofInside < RoofFace
    def make_points
      t = thickness
      part_points = []
      part_points << [bounding_c1.x, bounding_c1.y, bounding_c1.z]
      part_points << [bounding_c1.x, bounding_c1.y + length - SIP_OFFSET, bounding_c1.z]
      part_points << [bounding_c1.x + width - SIP_OFFSET, bounding_c1.y + length - SIP_OFFSET, bounding_c1.z]
      part_points << [bounding_c1.x + width - SIP_OFFSET, bounding_c1.y, bounding_c1.z]
      part_points
    end
  end
  class FloorFace < BarnPart
    def length
      9.227
    end

    def width
      9.227
    end

  end
  class FloorInside < FloorFace
    def length
      super - SIP_OFFSET
    end

    def width
      super - SIP_OFFSET

    end
  end

  attr_reader :floor_face, :floor_inside,
              :left_roof_face, :left_roof_inside,
              :right_roof_face, :right_roof_inside,
              :back_wall_face, :back_wall_inside,
              :left_wall_face, :left_wall_inside,
              :right_wall_face, :right_wall_inside,
              :front_wall_face, :front_wall_inside


  def initialize(origin: nil, sheet: nil, label: nil, parent_part: nil)
    part_init(sheet: sheet, origin: origin, parent_part: parent_part)

    #Need to make
    # Splines
  #Do splines need to be beveled?

    # Bottom of Left Wall
    # Bottom of Right Wall
    # Bottom of Front Wall (two parts)
    # Bottom of Left wall (two parts)
    # Bottom of Back Wall
    # Left Roof side , front & back
    # Right Roof Side, front & back

    #Need to mark the offsets for the inside piece



    @floor_face = FloorFace.new(label: "FloorFace", origin: @origin, sheet: WikiHouse::Basswood332Sheet.new,
                                parent_part: self)
    @floor_inside = FloorInside.new(label: "FloorInside", origin: @origin, sheet: WikiHouse::CoroplastSheet.new, parent_part: self)

    @floor_top_spline = Spline.new(length: @floor_face.length,label: "FloorTopSpline", origin: @origin, parent_part: self)
    @floor_bottom_spline = Spline.new(length: @floor_face.length,label: "FloorBottomSpline", origin: @origin, parent_part: self)

    @floor_left_spline = Spline.new(length: @floor_face.width,label: "FloorLeftSpline", origin: @origin, parent_part: self)
    @floor_right_spline = Spline.new(length: @floor_face.width,label: "FloorRightSpline", origin: @origin, parent_part: self)


    @back_wall_face = BackWallFace.new(label: "BackWallFace", origin: @origin, sheet: WikiHouse::Basswood332Sheet.new, parent_part: self)
    @back_wall_inside = BackWallInside.new(label: "BackWallInside", origin: @origin, sheet: WikiHouse::CoroplastSheet.new, parent_part: self)

    @front_wall_face = FrontWallFace.new(label: "FrontWallFace", origin: @origin, sheet: WikiHouse::Basswood332Sheet.new, parent_part: self)
    @front_wall_inside = FrontWallInside.new(label: "FrontWallInside", origin: @origin, sheet: WikiHouse::CoroplastSheet.new, parent_part: self)

    @left_wall_face = LeftWallFace.new(label: "LeftWallFace", origin: @origin, sheet: WikiHouse::Basswood332Sheet.new, parent_part: self)
    @left_wall_inside = LeftWallInside.new(label: "LeftWallInside", origin: @origin, sheet: WikiHouse::CoroplastSheet.new, parent_part: self)

    @right_wall_face = RightWallFace.new(label: "RightWallFace", origin: @origin, sheet: WikiHouse::Basswood332Sheet.new, parent_part: self)
    @right_wall_inside = RightWallInside.new(label: "RightWallInside", origin: @origin, sheet: WikiHouse::CoroplastSheet.new, parent_part: self)


    @left_roof_face = RoofFace.new(label: "LeftRoofFace", origin: @origin, sheet: WikiHouse::Basswood332Sheet.new, parent_part: self)
    @left_roof_inside = RoofInside.new(label: "LeftRoofInside", origin: @origin, sheet: WikiHouse::CoroplastSheet.new, parent_part: self)

    @right_roof_face = RoofFace.new(label: "RightRoofFace", origin: @origin, sheet: WikiHouse::Basswood332Sheet.new, parent_part: self)
    @right_roof_inside = RoofInside.new(label: "RightRoofInside", origin: @origin, sheet: WikiHouse::CoroplastSheet.new, parent_part: self)


  end

  def origin=(new_origin)
    @origin = new_origin
    @floor_face.origin = @origin
    @floor_inside.origin = @origin

    @floor_top_spline.origin = @origin
    @floor_bottom_spline.origin = @origin
    @floor_left_spline.origin = @origin
    @floor_right_spline.origin = @origin


    @back_wall_face.origin = @origin
    @back_wall_inside.origin = @origin

    @front_wall_face.origin = @origin
    @front_wall_inside.origin = @origin

    @left_wall_face.origin = @origin
    @left_wall_inside.origin = @origin

    @right_wall_face.origin = @origin
    @right_wall_inside.origin = @origin


    @left_roof_face.origin = @origin
    @left_roof_inside.origin = @origin

    @right_roof_face.origin = @origin
    @right_roof_inside.origin = @origin
  end


  def draw!
    Sk.find_or_create_layer(name: self.class.name)
    Sk.make_layer_active_name(name: self.class.name)
    placement_width = @floor_face.width + 5
    @floor_face.draw!
    @floor_face.move_by(x: placement_width).go!


    @floor_inside.draw!
    placement_width += @floor_inside.width + 5
    @floor_inside.move_by(x: placement_width).go!


    @floor_top_spline.draw!
    placement_width += @floor_top_spline.width + 5 + @floor_inside.width
    @floor_top_spline.move_by(x: placement_width).go!

    @floor_bottom_spline.draw!
    placement_width += @floor_bottom_spline.width + 5
    @floor_bottom_spline.move_by(x: placement_width).go!

    @floor_left_spline.draw!
    placement_width += @floor_left_spline.width + 5
    @floor_left_spline.move_by(x: placement_width).go!

    @floor_right_spline.draw!
    placement_width += @floor_right_spline.width + 5
    @floor_right_spline.move_by(x: placement_width).go!

    placement_width += @back_wall_face.width + 5
    @back_wall_face.draw!
    @back_wall_face.move_by(x: placement_width).go!


    @back_wall_inside.draw!
    placement_width += @back_wall_inside.width + 5
    @back_wall_inside.move_by(x: placement_width).go!

    placement_width += @front_wall_face.width + 5
    @front_wall_face.draw!
    @front_wall_face.move_by(x: placement_width).go!


    @front_wall_inside.draw!
    placement_width += @front_wall_inside.width + 5
    @front_wall_inside.move_by(x: placement_width).go!

    placement_width += @left_wall_face.width + 5
    @left_wall_face.draw!
    @left_wall_face.move_by(x: placement_width).go!


    @left_wall_inside.draw!
    placement_width += @left_wall_inside.width + 5
    @left_wall_inside.move_by(x: placement_width).go!


    placement_width += @right_wall_face.width + 5
    @right_wall_face.draw!
    @right_wall_face.move_by(x: placement_width).go!


    @right_wall_inside.draw!
    placement_width += @right_wall_inside.width + 5
    @right_wall_inside.move_by(x: placement_width).go!


    @left_roof_face.draw!
    placement_width += @left_roof_face.width + 5
    @left_roof_face.move_by(x: placement_width).go!

    @left_roof_inside.draw!
    placement_width += @left_roof_inside.width + 5
    @left_roof_inside.move_by(x: placement_width).go!

    @right_roof_face.draw!
    placement_width += @right_roof_face.width + 5
    @right_roof_face.move_by(x: placement_width).go!

    @right_roof_inside.draw!
    placement_width += @right_roof_inside.width + 5
    @right_roof_inside.move_by(x: placement_width).go!


    
    
    groups = [@floor_face.group, @floor_inside.group,
              @floor_top_spline.group, @floor_bottom_spline.group,
              @floor_left_spline.group, @floor_right_spline.group,
              @back_wall_face.group, @back_wall_inside.group,
              @front_wall_face.group, @front_wall_inside.group,
              @left_wall_face.group, @left_wall_inside.group,
              @right_wall_face.group, @right_wall_inside.group,
              @left_roof_face.group, @left_roof_inside.group,
              @right_roof_face.group, @right_roof_inside.group]
    set_group(groups.compact)
  end


end