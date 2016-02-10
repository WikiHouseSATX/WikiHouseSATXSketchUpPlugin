class WikiHouse::OldRisingBarn1020
  include WikiHouse::PartHelper
  class BarnPart
    include WikiHouse::PartHelper

    include WikiHouse::AttributeHelper


    def initialize(parent_part: nil, sheet: nil, group: nil, origin: nil, label: label)
      part_init(origin: origin, sheet: sheet, label: label, parent_part: parent_part)
    end

    def shift_point(pt, x: 0, y: 0, z: 0)
      [pt.x + x, pt.y + y, pt.z + z]
    end

    def sip_offset
      parent_part.sip_offset
    end

    def scale_factor
      parent_part.scale_factor
    end

    def scale(val)
      ((val * scale_factor * 100).round * 1.0)/100
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

    def draw_interior_on_face
      top_points = interior_points.collect do |pt|

        shift_point(pt, z: thickness)
      end

      top_lines = Sk.draw_points(top_points)


      bottom_lines = Sk.draw_points(interior_points)
      [top_lines, bottom_lines]
    end

    def mirror_face_points
      fpts = face_points

      part_points = []
      mirror_x = width + 1.0
      shortest_distance = width + 1.0
      horizontal_mirror = fpts.collect do |pt|
        distance = Sk.round(mirror_x - pt.x)
        # puts "Distance from #{pt.x} to #{mirror_x} = #{distance}"
        shortest_distance = distance if distance < shortest_distance
        #  puts "Shortest distance is #{shortest_distance}"
        distance
      end

      horizontal_mirror.each_with_index do |x, index|
        #  puts "Moving #{fpts[index].x} to #{ x - shortest_distance} #{shortest_distance} "
        part_points[index] = [x - shortest_distance, fpts[index].y, fpts[index].z]
      end
      part_points
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
      marks = mark_face!

      if marks
        entities = face.all_connected
        marks.map do |mark|
          # face_mark = Sk.add_face(mark)
          #entities.concat(face_mark.all_connected)
          entities.concat(mark)
        end
        set_group(entities)

      else
        Sk.add_face(lines)
        set_group(face.all_connected)

      end
      mark_primary_face!(face)
    end

    def set_default_properties
      mark_cutable!
    end

  end
  class Spline < BarnPart

    #this is just a part with a fixed width and a variable length
    def initialize(length: nil, parent_part: nil, group: nil, origin: nil, label: label)
      part_init(origin: origin, sheet: parent_part.spline_material, label: label, parent_part: parent_part)
      @length = length
    end

    def length
      @length

    end

    def width
      parent_part.interior_material.thickness
    end

    def windows
      []
    end
  end
  class RoofSupport < BarnPart

    #this is just a part with a fixed width and a variable length
    def initialize(width: nil, length: nil, parent_part: nil, group: nil, origin: nil, label: label)
      part_init(origin: origin, sheet: parent_part.roof_support_material, label: label, parent_part: parent_part)
      @length = length ? length : 100
      @width = width ? width : 100
    end

    def length
      @length

    end

    def width
      @width
    end
  end


  class LeftWallFace < BarnPart
    def length
      scale(5.969)
    end

    def width
      scale(13.625)
    end

    def spline_lengths
      splines = [width, width, length - 2 * sip_offset]
      splines << scale(6.614)- sip_offset # bottom left of door
      splines << scale(0.71) - sip_offset # bottom right of door

      splines << scale(4.542) - 2 * sip_offset # left door - inner
      splines << scale(4.542) #left door - outer
      splines << scale(4.542) - 2 * sip_offset #right door - inner
      splines << scale(4.542) #right_door - outer
      splines << scale(6.301) #door header
      windows.each do |window|
        splines << window[:width] - 2 * sip_offset
        splines << window[:width] - 2 * sip_offset
        splines << window[:length] + 2 * sip_offset
        splines << window[:length] + 2 * sip_offset

      end


      splines
    end

    def mark_face!
      draw_interior_on_face
    end

    def make_points
      face_points
    end

    def face_points

      part_points = []
      part_points << [bounding_c1.x, bounding_c1.y, bounding_c1.z]
      part_points << [bounding_c1.x, bounding_c1.y + length, bounding_c1.z]
      part_points << [bounding_c1.x + width, bounding_c1.y + length, bounding_c1.z]
      part_points << [bounding_c1.x + width, bounding_c1.y, bounding_c1.z]
      #door
      part_points << [bounding_c1.x + scale(12.915), bounding_c1.y, bounding_c1.z]
      part_points << [bounding_c1.x + scale(12.915), bounding_c1.y + scale(4.542), bounding_c1.z]

      part_points << [bounding_c1.x + scale(6.614), bounding_c1.y + scale(4.542), bounding_c1.z]
      part_points << [bounding_c1.x + scale(6.614), bounding_c1.y, bounding_c1.z]

      part_points
    end

    def interior_points
      fpts = face_points

      part_points = []
      part_points << shift_point(fpts[0], x: sip_offset, y: sip_offset)

      part_points << shift_point(fpts[1], x: sip_offset, y: -1 * sip_offset)
      part_points << shift_point(fpts[2], x: -1 * sip_offset, y: -1 * sip_offset)
      part_points << shift_point(fpts[3], x: -1 * sip_offset, y: sip_offset)
      part_points << shift_point(fpts[4], x: sip_offset, y: sip_offset)

      part_points << shift_point(fpts[5], x: sip_offset, y: sip_offset)
      part_points << shift_point(fpts[6], x: -1 * sip_offset, y: sip_offset)
      part_points << shift_point(fpts[7], x: -1 * sip_offset, y: sip_offset)
      part_points

    end


    def windows
      [{
           origin_x: scale(2.469),
           origin_y: scale(1.064),
           width: scale(2.186),
           length: scale(3.549)

       }]
    end

    def make_pockets!

      pockets = []
      #Window
      windows.each do |window|

        c5 = [bounding_c1.x + window[:origin_x],
              bounding_c1.y + window[:origin_y],
              bounding_c1.z]

        c6 = [c5.x, c5.y + window[:length], c5.z]
        c7 = [c5.x + window[:width], c5.y + window[:length], c5.z]
        c8 = [c5.x + window[:width], c5.y, c5.z]
        points = [c5, c6, c7, c8]

        pocket_lines = Sk.draw_all_points(points)
        pocket_lines.each { |e| mark_inside_edge!(e) }
        pockets << pocket_lines

      end

      pockets

    end
  end
  class LeftWallMirrorFace < LeftWallFace
    def mark_face!

    end

    def make_points
      mirror_face_points
    end
  end
  class LeftWallInside <LeftWallFace
    def mark_face!

    end

    def make_points
      interior_points

    end

    def windows
      original_windows = super
      original_windows.collect do |window|
        {
            origin_x: window[:origin_x] - sip_offset,
            origin_y: window[:origin_y] - sip_offset,
            width: window[:width] + 2 * sip_offset,
            length: window[:length] + 2 * sip_offset
        }
      end

    end
  end

  class RightWallFace < BarnPart
    def length
      scale(4.711)
    end

    def width
      scale(13.625)
    end

    def spline_lengths
      splines = [length, width - 2 * sip_offset, length, width - 2 * sip_offset]


      splines
    end

    def mark_face!
      draw_interior_on_face
    end

    def make_points
      face_points
    end

    def face_points

      part_points = []
      part_points << [bounding_c1.x, bounding_c1.y, bounding_c1.z]
      part_points << [bounding_c1.x, bounding_c1.y + length, bounding_c1.z]
      part_points << [bounding_c1.x + width, bounding_c1.y + length, bounding_c1.z]
      part_points << [bounding_c1.x + width, bounding_c1.y, bounding_c1.z]

      part_points
    end

    def interior_points
      fpts = face_points

      part_points = []
      part_points << shift_point(fpts[0], x: sip_offset, y: sip_offset)

      part_points << shift_point(fpts[1], x: sip_offset, y: -1 * sip_offset)
      part_points << shift_point(fpts[2], x: -1 * sip_offset, y: -1 * sip_offset)
      part_points << shift_point(fpts[3], x: -1 * sip_offset, y: sip_offset)

      part_points

    end
  end
  class RightWallInside <RightWallFace
    def mark_face!

    end

    def make_points
      interior_points

    end

  end
  class RightWallMirrorFace < RightWallFace
    def mark_face!

    end

    def make_points
      mirror_face_points
    end
  end

  class BackWallFace < BarnPart
    def length
      scale(5.969)
    end

    def width
      scale(7.550)
    end

    def spline_lengths
      splines = []
      splines << scale(5.969) -2 * sip_offset #left side
      splines << scale(4.711) - 2 * sip_offset #right side
      splines << scale(7.650) #roof
      splines << scale(7.550) #bottom
      windows.each do |window|
        splines << window[:width] - 2 * sip_offset
        splines << window[:width] - 2 * sip_offset
        splines << window[:length] + 2 * sip_offset
        splines << window[:length] + 2 * sip_offset

      end

      splines
    end

    def face_points
      part_points = []
      part_points << [bounding_c1.x, bounding_c1.y, bounding_c1.z]
      part_points << [bounding_c1.x, bounding_c1.y + scale(4.711), bounding_c1.z]
      part_points << [bounding_c1.x + width, bounding_c1.y + length, bounding_c1.z]
      part_points << [bounding_c1.x + width, bounding_c1.y, bounding_c1.z]

      part_points
    end

    def make_points
      face_points
    end

    def mark_face!
      draw_interior_on_face
    end

    def interior_points
      fpts = face_points

      part_points = []
      part_points << shift_point(fpts[0], x: sip_offset, y: sip_offset)

      part_points << shift_point(fpts[1], x: sip_offset, y: -1 * sip_offset)
      part_points << shift_point(fpts[2], x: -1 * sip_offset, y: -1 * sip_offset)
      part_points << shift_point(fpts[3], x: -1 * sip_offset, y: sip_offset)

      part_points

    end

    def windows
      [{
           origin_x: scale(5.677),
           origin_y: scale(3.349),
           width: scale(1.022),
           length: scale(1.193)

       }]
    end

    def make_pockets!

      pockets = []
      #Window
      windows.each do |window|

        c5 = [bounding_c1.x + window[:origin_x],
              bounding_c1.y + window[:origin_y],
              bounding_c1.z]

        c6 = [c5.x, c5.y + window[:length], c5.z]
        c7 = [c5.x + window[:width], c5.y + window[:length], c5.z]
        c8 = [c5.x + window[:width], c5.y, c5.z]
        points = [c5, c6, c7, c8]

        pocket_lines = Sk.draw_all_points(points)
        pocket_lines.each { |e| mark_inside_edge!(e) }
        pockets << pocket_lines

      end

      pockets

    end

  end
  class BackWallInside < BackWallFace
    def mark_face!
    end


    def make_points
      interior_points
    end

    def windows
      original_windows = super
      original_windows.collect do |window|
        {
            origin_x: window[:origin_x] - sip_offset,
            origin_y: window[:origin_y] - sip_offset,
            width: window[:width] + 2 * sip_offset,
            length: window[:length] + 2 * sip_offset
        }
      end
    end
  end

  class BackWallMirrorFace < BackWallFace
    def mark_face!

    end

    def make_points
      mirror_face_points
    end
  end
  class FrontWallFace < BarnPart
    def length
      scale(5.969)
    end

    def width
      scale(7.550)
    end

    def spline_lengths
      splines = []
      splines << scale(5.969) -2 * sip_offset #left side
      splines << scale(4.711) - 2 * sip_offset #right side
      splines << scale(7.650) #roof
      splines << scale(7.550) #bottom


      splines
    end

    def face_points
      part_points = []
      part_points << [bounding_c1.x, bounding_c1.y, bounding_c1.z]
      part_points << [bounding_c1.x, bounding_c1.y + length, bounding_c1.z]
      part_points << [bounding_c1.x + width, bounding_c1.y + scale(4.711), bounding_c1.z]
      part_points << [bounding_c1.x + width, bounding_c1.y, bounding_c1.z]

      part_points
    end

    def make_points
      face_points
    end

    def mark_face!
      draw_interior_on_face
    end

    def interior_points
      fpts = face_points

      part_points = []
      part_points << shift_point(fpts[0], x: sip_offset, y: sip_offset)

      part_points << shift_point(fpts[1], x: sip_offset, y: -1 * sip_offset)
      part_points << shift_point(fpts[2], x: -1 * sip_offset, y: -1 * sip_offset)
      part_points << shift_point(fpts[3], x: -1 * sip_offset, y: sip_offset)

      part_points

    end

  end
  class FrontWallInside < FrontWallFace
    def mark_face!
    end


    def make_points
      interior_points
    end

  end
  class FrontWallMirrorFace < FrontWallFace
    def mark_face!

    end

    def make_points
      mirror_face_points
    end
  end

  class FloorFace < BarnPart
    def length
      scale(7.654)
    end

    def width
      scale(14.363)
    end

    def spline_lengths
      [length, width - 2 * sip_offset, length, width - 2 * sip_offset]
    end

    def make_points
      face_points
    end

    def face_points
      part_points = []
      part_points << [bounding_c1.x, bounding_c1.y, bounding_c1.z]
      part_points << [bounding_c1.x, bounding_c1.y + length, bounding_c1.z]
      part_points << [bounding_c1.x + width, bounding_c1.y + length, bounding_c1.z]
      part_points << [bounding_c1.x + width, bounding_c1.y, bounding_c1.z]

      part_points

    end

    def interior_points
      fpts = face_points

      part_points = []
      part_points << shift_point(fpts[0], x: sip_offset, y: sip_offset)

      part_points << shift_point(fpts[1], x: sip_offset, y: -1 * sip_offset)
      part_points << shift_point(fpts[2], x: -1 * sip_offset, y: -1 * sip_offset)
      part_points << shift_point(fpts[3], x: -1 * sip_offset, y: sip_offset)

      part_points

    end

    def mark_face!
      draw_interior_on_face
    end
  end
  class FloorInside < FloorFace

    def mark_face!
    end

    def make_points
      interior_points
    end
  end
  class FloorMirrorFace <FloorFace
    def mark_face!

    end

    def make_points
      mirror_face_points
    end
  end
  class RoofFace < BarnPart
    def length
      scale(7.654)
    end

    def width
      scale(14.363)
    end

    def spline_lengths
      [length, width - 2 * sip_offset, length, width - 2 * sip_offset]
    end

    def make_points
      face_points
    end

    def face_points
      part_points = []
      part_points << [bounding_c1.x, bounding_c1.y, bounding_c1.z]
      part_points << [bounding_c1.x, bounding_c1.y + length, bounding_c1.z]
      part_points << [bounding_c1.x + width, bounding_c1.y + length, bounding_c1.z]
      part_points << [bounding_c1.x + width, bounding_c1.y, bounding_c1.z]

      part_points

    end

    def interior_points
      fpts = face_points

      part_points = []
      part_points << shift_point(fpts[0], x: sip_offset, y: sip_offset)

      part_points << shift_point(fpts[1], x: sip_offset, y: -1 * sip_offset)
      part_points << shift_point(fpts[2], x: -1 * sip_offset, y: -1 * sip_offset)
      part_points << shift_point(fpts[3], x: -1 * sip_offset, y: sip_offset)

      part_points

    end

    def mark_face!
      draw_interior_on_face
    end
  end
  class RoofInside < RoofFace

    def mark_face!
    end

    def make_points
      interior_points
    end
  end
  class RoofMirrorFace < RoofFace
    def mark_face!

    end

    def make_points
      mirror_face_points
    end
  end

  attr_reader :floor_face, :floor_inside,
              :floor_splines, :floor_mirror_face,

              :back_wall_face, :back_wall_inside,
              :back_wall_splines, :back_wall_mirror_face,

              :front_wall_face, :front_wall_inside,
              :front_wall_splines, :front_wall_mirror_face,

              :left_wall_face, :left_wall_inside,
              :left_wall_splines, :left_wall_mirror_face,

              :right_wall_face, :right_wall_inside,
              :right_wall_bottom_spline, :right_wall_mirror_face,


              :roof_face, :roof_inside,
              :roof_splines, :wall_mirror_face,

              :roof_support


  def face_material
    WikiHouse::Meranti27mmSheet.new
  end

  def interior_material
    WikiHouse::CoroplastSheet.new
  end

  def spline_material
    face_material
  end

  def roof_support_material
    face_material
  end

  def sip_offset
    spline_material.thickness
  end

  def scale_factor

    #Use this if the materials need to change
    original_floor_length = 14.363
    new_floor_length = 14.363
    (((new_floor_length/original_floor_length) * 1000).round * 1.0)/1000
  end

  def initialize(origin: nil, sheet: nil, label: nil, parent_part: nil)
    part_init(sheet: sheet, origin: origin, parent_part: parent_part)

    #refactor idea - floor, roof, wall
    # you can add doors and windows to walls
    # roof beams are sepearate
    # The parts should handle front and back face, interior and all splines needed

    # Splines
    #Do splines need to be beveled? -
    #What about spline on outside of roof - is it wider?


    #need the cross bar for the roof support
    # need to mark the window outline
    # For window and door - need to generate both faces that are mirrored


    @floor_face = FloorFace.new(label: "FloorFace", origin: @origin, sheet: face_material,
                                parent_part: self)
    @floor_mirror_face = FloorMirrorFace.new(label: "FloorMirrorFace", origin: @origin, sheet: face_material,
                                             parent_part: self)

    @floor_inside = FloorInside.new(label: "FloorInside", origin: @origin, sheet: interior_material, parent_part: self)

    @floor_splines = @floor_face.spline_lengths.collect.with_index do |spline_length, index|
      Spline.new(length: spline_length, label: "FloorSpline-#{index + 1}", origin: @origin, parent_part: self)
    end


    @back_wall_face = BackWallFace.new(label: "BackWallFace", origin: @origin, sheet: face_material, parent_part: self)
    @back_wall_mirror_face = BackWallFace.new(label: "BackWallMirrorFace", origin: @origin, sheet: face_material, parent_part: self)

    @back_wall_inside = BackWallInside.new(label: "BackWallInside", origin: @origin, sheet: interior_material, parent_part: self)

    @back_wall_splines = @back_wall_face.spline_lengths.collect.with_index do |spline_length, index|
      Spline.new(length: spline_length, label: "BackWallSpline-#{index + 1}", origin: @origin, parent_part: self)
    end


    @front_wall_face = FrontWallFace.new(label: "FrontWallFace", origin: @origin, sheet: face_material, parent_part: self)
    @front_wall_mirror_face = FrontWallMirrorFace.new(label: "FrontWallMirrorFace", origin: @origin, sheet: face_material, parent_part: self)

    @front_wall_inside = FrontWallInside.new(label: "FrontWallInside", origin: @origin, sheet: interior_material, parent_part: self)


    @front_wall_splines = @front_wall_face.spline_lengths.collect.with_index do |spline_length, index|
      Spline.new(length: spline_length, label: "FrontWallSpline-#{index + 1}", origin: @origin, parent_part: self)
    end


    @left_wall_face = LeftWallFace.new(label: "LeftWallFace", origin: @origin, sheet: face_material, parent_part: self)
    @left_wall_mirror_face = LeftWallMirrorFace.new(label: "LeftWallMirrorFace", origin: @origin, sheet: face_material, parent_part: self)

    @left_wall_inside = LeftWallInside.new(label: "LeftWallInside", origin: @origin, sheet: interior_material, parent_part: self)

    @left_wall_splines = @left_wall_face.spline_lengths.collect.with_index do |spline_length, index|
      Spline.new(length: spline_length, label: "LeftWallSpline-#{index + 1}", origin: @origin, parent_part: self)
    end


    @right_wall_face = RightWallFace.new(label: "RightWallFace", origin: @origin, sheet: face_material, parent_part: self)
    @right_wall_mirror_face = RightWallMirrorFace.new(label: "RightWallMirrorFace", origin: @origin, sheet: face_material, parent_part: self)

    @right_wall_inside = RightWallInside.new(label: "RightWallInside", origin: @origin, sheet: interior_material, parent_part: self)

    @right_wall_splines = @right_wall_face.spline_lengths.collect.with_index do |spline_length, index|
      Spline.new(length: spline_length, label: "RightWallSpline-#{index + 1}", origin: @origin, parent_part: self)
    end


    @roof_support = RoofSupport.new(width: nil, length: @floor_face.length, label: "Roof Support", origin: @origin, parent_part: self)


    @roof_face = RoofFace.new(label: "RoofFace", origin: @origin, sheet: face_material, parent_part: self)
    @roof_mirror_face = RoofFace.new(label: "MirrorRoofFace", origin: @origin, sheet: face_material, parent_part: self)

    @roof_inside = RoofInside.new(label: "RoofInside", origin: @origin, sheet: interior_material, parent_part: self)
    @roof_splines = @roof_face.spline_lengths.collect.with_index do |spline_length, index|
      Spline.new(length: spline_length, label: "RoofSpline-#{index + 1}", origin: @origin, parent_part: self)
    end


  end

  def origin=(new_origin)
    @origin = new_origin
    @floor_face.origin = @origin
    @floor_mirror_face.origin = @origin
    @floor_inside.origin = @origin
    @floor_splines.each { |spline| spline.origin = @origin }

    @back_wall_face.origin = @origin
    @back_wall_mirror_face.origin = @origin

    @back_wall_inside.origin = @origin
    @back_wall_splines.each { |spline| spline.origin = @origin }

    @front_wall_face.origin = @origin
    @front_wall_mirror_face.origin = @origin

    @front_wall_inside.origin = @origin
    @front_wall_splines.each { |spline| spline.origin = @origin }


    @left_wall_face.origin = @origin
    @left_wall_mirror_face.origin = @origin
    @left_wall_inside.origin = @origin
    @left_wall_splines.each { |spline| spline.origin = @origin }

    @right_wall_face.origin = @origin
    @right_wall_mirror_face.origin = @origin
    @right_wall_inside.origin = @origin
    @right_wall_splines.each { |spline| spline.origin = @origin }


    @roof_face.origin = @origin
    @roof_mirror_face.origin = @origin
    @roof_inside.origin = @origin
    @roof_splines.each { |spline| spline.origin = @origin }

  end


  def draw_part!(face_part, mirror_part, inside_part, splines, placement_width)
    face_part.draw!
    face_part.move_by(x: placement_width).go!
    placement_width += face_part.width + 5
    mirror_part.draw!
    mirror_part.move_by(x: placement_width).go!
    placement_width += mirror_part.width + 5
    inside_part.draw!
    inside_part.move_by(x: placement_width).go!
    placement_width += inside_part.width + 5

    splines.each do |spline, index|
      spline.draw!
      spline.move_by(x: placement_width).go!
      placement_width += spline.width + 5 + (index == 0 ? inside_part.width : 0)
    end

    placement_width

  end

  def draw!
    Sk.find_or_create_layer(name: self.class.name)
    Sk.make_layer_active_name(name: self.class.name)
    placement_width = 0
   # placement_width = draw_part!(@floor_face, @floor_mirror_face, @floor_inside, @floor_splines, placement_width)
    #  placement_width = draw_part!(@back_wall_face, @back_wall_mirror_face,@back_wall_inside, @back_wall_splines, placement_width)
    # placement_width = draw_part!(@front_wall_face, @front_wall_mirror_face, @front_wall_inside, @front_wall_splines, placement_width)
      placement_width = draw_part!(@left_wall_face, @left_wall_mirror_face, @left_wall_inside, @left_wall_splines, placement_width)
    #   placement_width = draw_part!(@right_wall_face, @right_wall_mirror_face, @right_wall_inside, @right_wall_splines, placement_width)
    #  placement_width = draw_part!(@roof_face, @roof_mirror_face, @roof_inside, @roof_splines, placement_width)
    #    @roof_support.draw!
    #    @roof_support.move_by(x: placement_width).go!
    #    placement_width += @roof_support.width + 5

    groups = [@floor_face.group, @floor_inside.group, @floor_mirror_face.group,

              @back_wall_face.group, @back_wall_inside.group, @back_wall_mirror_face.group,
              @front_wall_face.group, @front_wall_inside.group, @front_wall_mirror_face.group,
              @left_wall_face.group, @left_wall_inside.group, @left_wall_mirror_face.group,
              @right_wall_face.group, @right_wall_inside.group, @right_wall_mirror_face.group,
              @roof_face.group, @roof_inside.group, @roof_mirror_face.group, @roof_support.group]
    @floor_splines.each { |spline| groups << spline.group }
    @back_wall_splines.each { |spline| groups << spline.group }
    @front_wall_splines.each { |spline| groups << spline.group }
    @left_wall_splines.each { |spline| groups << spline.group }
    @right_wall_splines.each { |spline| groups << spline.group }
    @roof_splines.each { |spline| groups << spline.group }


    set_group(groups.compact)
  end


end