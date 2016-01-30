class WikiHouse::RisingBarn1414
  include WikiHouse::PartHelper
  SIP_OFFSET = 0.0938


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
    def mark_face!
      
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
      mark_face!

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
    def initialize(length: nil, parent_part: nil, group: nil, origin: nil, label: label)
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

    def spline_lengths
      [4.487, width - 8.623]
    end
    def mark_face!
      bottom_points = []
      bottom_points << [bounding_c1.x , bounding_c1.y + SIP_OFFSET , bounding_c1.z + 0 * thickness]
      bottom_points << [bounding_c1.x + width, bounding_c1.y + SIP_OFFSET , bounding_c1.z + 0 * thickness]


      lines = Sk.draw_points(bottom_points)
      top_points = bottom_points.collect do |pt|
        [pt.x , pt.y, pt.z + thickness]
      end

      lines = Sk.draw_points(top_points)
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
    def mark_face!

    end
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

    def spline_lengths
      [width]
    end
    def mark_face!
      bottom_points = []
      bottom_points << [bounding_c1.x , bounding_c1.y + SIP_OFFSET , bounding_c1.z + 0 * thickness]
      bottom_points << [bounding_c1.x + width, bounding_c1.y + SIP_OFFSET , bounding_c1.z + 0 * thickness]


      lines = Sk.draw_points(bottom_points)
      top_points = bottom_points.collect do |pt|
        [pt.x , pt.y, pt.z + thickness]
      end

      lines = Sk.draw_points(top_points)
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
    def mark_face!

    end
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

    def spline_lengths
      [width]
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
    def mark_face!
      bottom_points = []
      bottom_points << [bounding_c1.x , bounding_c1.y + SIP_OFFSET , bounding_c1.z + 0 * thickness]
      bottom_points << [bounding_c1.x + width, bounding_c1.y + SIP_OFFSET , bounding_c1.z + 0 * thickness]


      lines = Sk.draw_points(bottom_points)
      top_points = bottom_points.collect do |pt|
        [pt.x , pt.y, pt.z + thickness]
      end

      lines = Sk.draw_points(top_points)
    end
  end
  class BackWallInside < BackWallFace
    def mark_face!
    end
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

    def spline_lengths
      [0.601, width - 2.763]
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
    def mark_face!
      bottom_points = []
      bottom_points << [bounding_c1.x , bounding_c1.y + SIP_OFFSET , bounding_c1.z + 0 * thickness]
      bottom_points << [bounding_c1.x + width, bounding_c1.y + SIP_OFFSET , bounding_c1.z + 0 * thickness]


      lines = Sk.draw_points(bottom_points)
      top_points = bottom_points.collect do |pt|
        [pt.x , pt.y, pt.z + thickness]
      end

      lines = Sk.draw_points(top_points)
    end
    def mark_face!
      bottom_points = []
      bottom_points << [bounding_c1.x , bounding_c1.y + SIP_OFFSET , bounding_c1.z + 0 * thickness]
      bottom_points << [bounding_c1.x + width, bounding_c1.y + SIP_OFFSET , bounding_c1.z + 0 * thickness]


      lines = Sk.draw_points(bottom_points)
      top_points = bottom_points.collect do |pt|
        [pt.x , pt.y, pt.z + thickness]
      end

      lines = Sk.draw_points(top_points)
    end
  end
  class FrontWallInside < FrontWallFace
    def mark_face!

    end
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
    def spline_lengths
      [width, length, width]
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
    def mark_face!
      bottom_points = []
      bottom_points << [bounding_c1.x , bounding_c1.y + SIP_OFFSET , bounding_c1.z + 0 * thickness]
      bottom_points << [bounding_c1.x + width, bounding_c1.y + SIP_OFFSET , bounding_c1.z + 0 * thickness]


      lines = Sk.draw_points(bottom_points)
      top_points = bottom_points.collect do |pt|
        [pt.x , pt.y, pt.z + thickness]
      end

      lines = Sk.draw_points(top_points)
    end

  end
  class RoofInside < RoofFace
    def mark_face!

    end
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

    def spline_lengths
      [length, width, length, width]
    end
    def mark_face!
      bottom_points = []
     bottom_points << [bounding_c1.x + SIP_OFFSET, bounding_c1.y + SIP_OFFSET, bounding_c1.z + 0 * thickness]
      bottom_points << [bounding_c1.x + SIP_OFFSET, bounding_c1.y + length - SIP_OFFSET, bounding_c1.z + 0 * thickness]
      bottom_points << [bounding_c1.x + width - SIP_OFFSET, bounding_c1.y + length - SIP_OFFSET, bounding_c1.z + 0 * thickness]
      bottom_points << [bounding_c1.x + width - SIP_OFFSET, bounding_c1.y + SIP_OFFSET, bounding_c1.z + 0 * thickness]

     lines = Sk.draw_all_points(bottom_points)
      face = Sk.add_face(lines)
      top_points = bottom_points.collect do |pt|
        [pt.x , pt.y, pt.z + thickness]
      end

      lines = Sk.draw_all_points(top_points)
      face = Sk.add_face(lines)

    end
  end
  class FloorInside < FloorFace
    def length
      super - SIP_OFFSET * 2
    end

    def width
      super - SIP_OFFSET * 2

    end
    def mark_face!

    end
  end

  attr_reader :floor_face, :floor_inside,
              :floor_splines,

              :back_wall_face, :back_wall_inside,
              :back_wall_splines,

              :front_wall_face, :front_wall_inside,
              :front_wall_splines,

              :left_wall_face, :left_wall_inside,
              :left_wall_splines,

              :right_wall_face, :right_wall_inside,
              :right_wall_bottom_spline,

              :left_roof_face, :left_roof_inside,
              :left_roof_splines,
              
              :right_roof_face, :right_roof_inside,
              :right_roof_splines


  def initialize(origin: nil, sheet: nil, label: nil, parent_part: nil)
    part_init(sheet: sheet, origin: origin, parent_part: parent_part)

    #Need to make
    # Splines
    #Do splines need to be beveled? -
    #What about spline on outside of roof - is it wider?

    #Need to mark the offsets for the inside piece
    # Back Wall
    # Front Wall
    # left Wall
    # right Wall
    # Left Roof
    # Right Roof
    #Need to handle flattening and exporting to svg - keeping the parts on the right material


    @floor_face = FloorFace.new(label: "FloorFace", origin: @origin, sheet: WikiHouse::Basswood332Sheet.new,
                                parent_part: self)
    @floor_inside = FloorInside.new(label: "FloorInside", origin: @origin, sheet: WikiHouse::CoroplastSheet.new, parent_part: self)

    @floor_splines = @floor_face.spline_lengths.collect.with_index do |spline_length, index|
      Spline.new(length: spline_length, label: "FloorSpline-#{index + 1}", origin: @origin, parent_part: self)
    end


    @back_wall_face = BackWallFace.new(label: "BackWallFace", origin: @origin, sheet: WikiHouse::Basswood332Sheet.new, parent_part: self)
    @back_wall_inside = BackWallInside.new(label: "BackWallInside", origin: @origin, sheet: WikiHouse::CoroplastSheet.new, parent_part: self)

    @back_wall_splines = @back_wall_face.spline_lengths.collect.with_index do |spline_length, index|
      Spline.new(length: spline_length, label: "BackWallSpline-#{index + 1}", origin: @origin, parent_part: self)
    end


    @front_wall_face = FrontWallFace.new(label: "FrontWallFace", origin: @origin, sheet: WikiHouse::Basswood332Sheet.new, parent_part: self)
    @front_wall_inside = FrontWallInside.new(label: "FrontWallInside", origin: @origin, sheet: WikiHouse::CoroplastSheet.new, parent_part: self)


    @front_wall_splines = @front_wall_face.spline_lengths.collect.with_index do |spline_length, index|
      Spline.new(length: spline_length, label: "FrontWallSpline-#{index + 1}", origin: @origin, parent_part: self)
    end


    @left_wall_face = LeftWallFace.new(label: "LeftWallFace", origin: @origin, sheet: WikiHouse::Basswood332Sheet.new, parent_part: self)
    @left_wall_inside = LeftWallInside.new(label: "LeftWallInside", origin: @origin, sheet: WikiHouse::CoroplastSheet.new, parent_part: self)

    @left_wall_splines = @left_wall_face.spline_lengths.collect.with_index do |spline_length, index|
      Spline.new(length: spline_length, label: "LeftWallSpline-#{index + 1}", origin: @origin, parent_part: self)
    end


    @right_wall_face = RightWallFace.new(label: "RightWallFace", origin: @origin, sheet: WikiHouse::Basswood332Sheet.new, parent_part: self)
    @right_wall_inside = RightWallInside.new(label: "RightWallInside", origin: @origin, sheet: WikiHouse::CoroplastSheet.new, parent_part: self)

    @right_wall_splines = @right_wall_face.spline_lengths.collect.with_index do |spline_length, index|
      Spline.new(length: spline_length, label: "RightWallSpline-#{index + 1}", origin: @origin, parent_part: self)
    end


    @left_roof_face = RoofFace.new(label: "LeftRoofFace", origin: @origin, sheet: WikiHouse::Basswood332Sheet.new, parent_part: self)
    @left_roof_inside = RoofInside.new(label: "LeftRoofInside", origin: @origin, sheet: WikiHouse::CoroplastSheet.new, parent_part: self)

    @left_roof_splines = @left_roof_face.spline_lengths.collect.with_index do |spline_length, index|
      Spline.new(length: spline_length, label: "LeftRoofSpline-#{index + 1}", origin: @origin, parent_part: self)
    end
    
    
    @right_roof_face = RoofFace.new(label: "RightRoofFace", origin: @origin, sheet: WikiHouse::Basswood332Sheet.new, parent_part: self)
    @right_roof_inside = RoofInside.new(label: "RightRoofInside", origin: @origin, sheet: WikiHouse::CoroplastSheet.new, parent_part: self)
    @right_roof_splines = @right_roof_face.spline_lengths.collect.with_index do |spline_length, index|
      Spline.new(length: spline_length, label: "RightRoofSpline-#{index + 1}", origin: @origin, parent_part: self)
    end


  end

  def origin=(new_origin)
    @origin = new_origin
    @floor_face.origin = @origin
    @floor_inside.origin = @origin
    @floor_splines.each { |spline| spline.origin = @origin }

    @back_wall_face.origin = @origin
    @back_wall_inside.origin = @origin
    @back_wall_splines.each { |spline| spline.origin = @origin }

    @front_wall_face.origin = @origin
    @front_wall_inside.origin = @origin
    @front_wall_splines.each { |spline| spline.origin = @origin }


    @left_wall_face.origin = @origin
    @left_wall_inside.origin = @origin
    @left_wall_splines.each { |spline| spline.origin = @origin }

    @right_wall_face.origin = @origin
    @right_wall_inside.origin = @origin
    @right_wall_splines.each { |spline| spline.origin = @origin }


    @left_roof_face.origin = @origin
    @left_roof_inside.origin = @origin
    @left_roof_splines.each { |spline| spline.origin = @origin }

    
    @right_roof_face.origin = @origin
    @right_roof_inside.origin = @origin
    @right_roof_splines.each { |spline| spline.origin = @origin }

  end


  def draw_part!(face_part, inside_part, splines, placement_width)
    face_part.draw!
    face_part.move_by(x: placement_width).go!
    placement_width += face_part.width + 5
    face_part.move_by(x: placement_width).go!


    # inside_part.draw!
    # inside_part.move_by(x: placement_width).go!
    # placement_width += inside_part.width + 5
    #
    # splines.each do |spline, index|
    #   spline.draw!
    #   spline.move_by(x: placement_width).go!
    #   placement_width += spline.width + 5 + (index == 0 ? inside_part.width : 0)
    # end
    placement_width

  end

  def draw!
    Sk.find_or_create_layer(name: self.class.name)
    Sk.make_layer_active_name(name: self.class.name)
    placement_width = 0
    placement_width = draw_part!(@floor_face, @floor_inside, @floor_splines, placement_width)
   placement_width = draw_part!(@back_wall_face, @back_wall_inside, @back_wall_splines, placement_width)
    placement_width = draw_part!(@front_wall_face, @front_wall_inside, @front_wall_splines, placement_width)
    placement_width = draw_part!(@left_wall_face, @left_wall_inside, @left_wall_splines, placement_width)
    placement_width = draw_part!(@right_wall_face, @right_wall_inside, @right_wall_splines, placement_width)

    placement_width = draw_part!(@left_roof_face, @left_roof_inside, @left_roof_splines, placement_width)
    placement_width = draw_part!(@right_roof_face, @right_roof_inside, @right_roof_splines, placement_width)

    groups = [@floor_face.group, @floor_inside.group,

              @back_wall_face.group, @back_wall_inside.group,
              @front_wall_face.group, @front_wall_inside.group,
              @left_wall_face.group, @left_wall_inside.group,
              @right_wall_face.group, @right_wall_inside.group,
              @left_roof_face.group, @left_roof_inside.group,
              @right_roof_face.group, @right_roof_inside.group]
    @floor_splines.each { |spline| groups << spline.group }
    @back_wall_splines.each { |spline| groups << spline.group }
    @front_wall_splines.each { |spline| groups << spline.group }
    @left_wall_splines.each { |spline| groups << spline.group }
    @right_wall_splines.each { |spline| groups << spline.group }
    @left_roof_splines.each { |spline| groups << spline.group }
    @right_roof_splines.each { |spline| groups << spline.group }

    
    set_group(groups.compact)
  end


end