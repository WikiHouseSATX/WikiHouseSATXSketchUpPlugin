class WikiHouse::RisingBarn
  include WikiHouse::PartHelper

  # class BarnPart
  #   include WikiHouse::PartHelper
  #
  #   include WikiHouse::AttributeHelper
  #
  #
  #   def initialize(parent_part: nil, sheet: nil, group: nil, origin: nil, label: label)
  #     part_init(origin: origin, sheet: sheet, label: label, parent_part: parent_part)
  #   end
  #
  #   def shift_point(pt, x: 0, y: 0, z: 0)
  #     [pt.x + x, pt.y + y, pt.z + z]
  #   end
  #
  #   def sip_offset
  #     parent_part.sip_offset
  #   end
  #
  #   def scale_factor
  #     parent_part.scale_factor
  #   end
  #
  #   def scale(val)
  #     ((val * scale_factor * 100).round * 1.0)/100
  #   end
  #
  #   def origin=(new_origin)
  #     @origin = new_origin
  #   end
  #
  #   def bounding_c1
  #     @origin.dup
  #   end
  #
  #   def make_points
  #     t = thickness
  #     part_points = []
  #     part_points << [bounding_c1.x, bounding_c1.y, bounding_c1.z]
  #     part_points << [bounding_c1.x, bounding_c1.y + length, bounding_c1.z]
  #     part_points << [bounding_c1.x + width, bounding_c1.y + length, bounding_c1.z]
  #     part_points << [bounding_c1.x + width, bounding_c1.y, bounding_c1.z]
  #     part_points
  #   end
  #
  #   def make_pockets!
  #     []
  #   end
  #
  #   def mark_face!
  #
  #   end
  #
  #   def draw_interior_on_face
  #     top_points = interior_points.collect do |pt|
  #
  #       shift_point(pt, z: thickness)
  #     end
  #
  #     top_lines = Sk.draw_points(top_points)
  #
  #
  #     bottom_lines = Sk.draw_points(interior_points)
  #     [top_lines, bottom_lines]
  #   end
  #
  #   def mirror_face_points
  #     fpts = face_points
  #
  #     part_points = []
  #     mirror_x = width + 1.0
  #     shortest_distance = width + 1.0
  #     horizontal_mirror = fpts.collect do |pt|
  #       distance = Sk.round(mirror_x - pt.x)
  #       # puts "Distance from #{pt.x} to #{mirror_x} = #{distance}"
  #       shortest_distance = distance if distance < shortest_distance
  #       #  puts "Shortest distance is #{shortest_distance}"
  #       distance
  #     end
  #
  #     horizontal_mirror.each_with_index do |x, index|
  #       #  puts "Moving #{fpts[index].x} to #{ x - shortest_distance} #{shortest_distance} "
  #       part_points[index] = [x - shortest_distance, fpts[index].y, fpts[index].z]
  #     end
  #     part_points
  #   end
  #
  #   def draw!
  #
  #     points = make_points
  #
  #
  #     lines = Sk.draw_all_points(points)
  #     pockets = make_pockets!
  #
  #     face = Sk.add_face(lines)
  #
  #     set_material(face)
  #
  #     if pockets && pockets.length > 0
  #       pockets.each do |sp|
  #         pocket_face = Sk.add_face(sp)
  #         pocket_face.erase!
  #       end
  #     end
  #
  #
  #     make_part_right_thickness(face)
  #     marks = mark_face!
  #
  #     if marks
  #       entities = face.all_connected
  #       marks.map do |mark|
  #         # face_mark = Sk.add_face(mark)
  #         #entities.concat(face_mark.all_connected)
  #         entities.concat(mark)
  #       end
  #       set_group(entities)
  #
  #     else
  #       Sk.add_face(lines)
  #       set_group(face.all_connected)
  #
  #     end
  #     mark_primary_face!(face)
  #   end
  #
  #   def set_default_properties
  #     mark_cutable!
  #   end
  #
  # end
  class Part
    include WikiHouse::PartHelper
    include WikiHouse::AttributeHelper
    attr_reader :points, :pocket_points

    def initialize(points: [],
                   pocket_points: [], parent_part: nil, sheet: nil, group: nil, origin: nil, label: label)
      part_init(origin: origin, sheet: sheet, label: label, parent_part: parent_part)
      @points = points
      @pocket_points = pocket_points
    end

    def width
      points.collect { |pt| pt.x }.max
    end

    def length
      points.collect { |pt| pt.y }.max
    end

    def bounding_c1
      @origin.dup
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

    def make_pockets!(placement_x: 0)
      pockets = []

      pocket_points.each do |ppts|
        pocket_lines = Sk.draw_all_points(ppts.map { |pt| Sk.shift_point(pt, x: placement_x, origin: origin) })
        pocket_lines.each { |e| mark_inside_edge!(e) }
        pockets << pocket_lines

      end

      pockets

    end
  end
  class RoofAngle < Part
    def draw!(placement_x =0)
      lines = Sk.draw_all_points(@points.map { |pt| Sk.shift_point(pt, x: placement_x, origin: origin) })
      face = Sk.add_face(lines)
      set_material(face)


      make_part_right_thickness(face)

      Sk.add_face(lines)
      set_group(face.all_connected)

      mark_primary_face!(face)
    end
  end
  class Face < Part
    #Responsible for drawing the face layer
    def initialize(parent_part: nil,
                   group: nil,
                   origin: nil,
                   label: label,
                   points: [],
                   pocket_points: [],
                   interior_points: [],
                   sheet: nil

    )
      part_init(origin: origin, sheet: sheet, label: label, parent_part: parent_part)
      @points = points
      @pocket_points = pocket_points
      @interior_points = interior_points
    end


    def mark_face!
      top_points = @interior_points.collect do |pt|
        Sk.shift_point(pt, z: thickness)
      end
      top_lines = Sk.draw_points(top_points)
      bottom_lines = Sk.draw_points(@interior_points)
      [top_lines, bottom_lines]
    end


    def draw!(placement_x =0)
      lines = Sk.draw_all_points(@points.map { |pt| Sk.shift_point(pt, x: placement_x, origin: origin) })
      pockets = make_pockets!(placement_x: placement_x)
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
          entities.concat(mark)
        end
        set_group(entities)

      else
        Sk.add_face(lines)
        set_group(face.all_connected)
      end
      mark_primary_face!(face)
    end
  end
  class Interior < Part
    #Responsible for drawing the  interior layer


    def draw!(placement_x =0)
      lines = Sk.draw_all_points(@points.map { |pt| Sk.shift_point(pt, x: placement_x, origin: origin) })
      pockets = make_pockets!(placement_x: placement_x)
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
  end
  class MirrorFace < Face
    def initialize(parent_part: nil,
                   group: nil,
                   origin: nil,
                   label: label,
                   points: [],
                   pocket_points: [],
                   sheet: nil

    )
      super

      @points = Sk.horizontal_mirror(points)
      @pocket_points = pocket_points.map { |ppts| Sk.horizontal_mirror(ppts, mirror_x_pt: points.collect { |pt| pt.x }.max) }
    end

    def mark_face!

    end
  end
  class Spline < Part
    #Responsible for drawing a spline

    def initialize(parent_part: nil,
                   group: nil,
                   origin: nil,
                   label: label,
                   length: length,
                   sheet: nil,
                   interior_sheet: nil

    )
      part_init(origin: origin, sheet: sheet, label: label, parent_part: parent_part)
      @length = length
      @interior_sheet = interior_sheet
    end

    def width
      @interior_sheet.thickness
    end


    def length
      @length
    end

    def draw!(placement_x =0)
      lines = Sk.draw_all_points([[0, 0, 0],
                                  [0, length, 0],
                                  [width, length, 0],
                                  [width, 0, 0]].map { |pt| Sk.shift_point(pt, x: placement_x, origin: origin) })
      #   pockets = make_pockets!
      face = Sk.add_face(lines)
      set_material(face)


      make_part_right_thickness(face)
      Sk.add_face(lines)
      set_group(face.all_connected)
      mark_primary_face!(face)
    end
  end
  class Panel
    #Responsible for setting up the layers
    #Panels have four components
    #face, mirror face, interior, splines
    attr_reader :face, :mirror_face, :interior, :splines,
                :width, :length


    def initialize(parent_part: nil,
                   group: nil,
                   origin: nil,
                   label: label,
                   face_points: [],
                   face_pocket_points: [],
                   interior_points: [],
                   interior_pocket_points: [],
                   spline_lengths: [],
                   face_sheet: nil,
                   interior_sheet: nil,
                   spline_sheet: nil
    )

      @origin = origin
      @label = label
      @parent_part = parent_part
      @group = group
      @spline_sheet = spline_sheet
      @face = Face.new(origin: origin, label: "#{label} Face",
                       sheet: face_sheet,
                       points: face_points,
                       pocket_points: face_pocket_points,
                       interior_points: interior_points)
      @interior = Interior.new(origin: origin, label: "#{label} Interior",
                               sheet: interior_sheet,
                               points: interior_points,
                               pocket_points: interior_pocket_points)
      @mirror_face = MirrorFace.new(origin: origin, label: "#{label} MirrorFace",
                                    sheet: face_sheet,
                                    points: face_points,
                                    pocket_points: face_pocket_points)
      @splines = spline_lengths.collect.with_index do |spl, index|
        Spline.new(origin: origin,
                   label: "#{label} Spline-#{index +1}",
                   sheet: spline_sheet, interior_sheet: interior_sheet,
                   length: spl)
      end
    end

    def origin=(new_origin)
      @face.origin = new_origin
      @interior.origin = new_origin
      @mirror_face.origin = new_origin
      @splines.each do |spline|
        spline.origin = new_origin
      end
    end

    def group

      g = [@face.group, @mirror_face.group, @interior.group]
      @splines.each do |spline|
        g << spline.group
      end
      g.flatten.compact
    end

    def draw!(placement_x = 0)

      @face.draw!(placement_x)
      @face.move_by(x: placement_x).go!
      placement_x += @face.width + 5

      @mirror_face.draw!(placement_x)
      @mirror_face.move_by(x: placement_x).go!
      placement_x += @mirror_face.width + 5


      @interior.draw!(placement_x)
      @interior.move_by(x: placement_x).go!
      #  @interior.move_by(x: @spline_sheet.thickness, y: @spline_sheet.thickness).go!
      placement_x += @interior.width + 5

      @splines.each do |spline|
        spline.draw!(placement_x)

        spline.move_by(x: placement_x).go!
        placement_x += spline.width + 5
      end

    end
  end
  class PanelGeometry
    def spline_offset
      parent_part.spline_offset
    end

    def negative_spline_offset
      spline_offset * -1.0
    end

    def origin=(new_origin)
      @panel.origin = new_origin
    end

    def group
      @panel.group
    end


  end
  class Floor < PanelGeometry
    #responsible for building the geometry of the panel
    attr_reader :parent_part, :label, :origin


    def initialize(origin: nil, label: nil, parent_part: nil)
      @origin = origin
      @label = label
      @parent_part = parent_part


    end

    def length
      parent_part.length
    end

    def width
      parent_part.width
    end

    def spline_lengths
      [length, length, width - spline_offset * 2, width - spline_offset * 2]
    end

    def face_points

      part_points = []
      part_points << [0, 0, 0]
      part_points << [0, length, 0]
      part_points << [width, length, 0]
      part_points << [width, 0, 0]
      part_points
    end

    def interior_points

      Sk.shift_point_array(face_points, [
                                          [spline_offset, spline_offset, 0],
                                          [spline_offset, negative_spline_offset, 0],
                                          [negative_spline_offset, negative_spline_offset, 0],
                                          [negative_spline_offset, spline_offset, 0]
                                      ])


    end

    def draw!(placement_x = 0)
      @panel = Panel.new(origin: origin,
                         label: @label,
                         face_sheet: @parent_part.face_sheet,
                         interior_sheet: @parent_part.interior_sheet,
                         spline_sheet: @parent_part.spline_sheet,
                         face_points: face_points,
                         interior_points: interior_points,
                         spline_lengths: spline_lengths,
                         parent_part: self)
      @panel.draw!(placement_x)
    end
  end
  class Wall < PanelGeometry
    attr_reader :parent_part, :label, :origin, :length, :width

    def initialize(origin: nil, label: nil, parent_part: nil,
                   length: nil, width: nil)
      @windows = []
      @roof_slant = nil
      @doors = []
      @origin = origin
      @label = label
      @parent_part = parent_part
      @length = length
      @width = width


    end

    def length
      if @roof_slant
        @length + @roof_slant[:height]
      else
        @length
      end
    end

    def add_window(at: nil, window_width: nil, window_length: nil)
      @windows << Window.new(origin: at,
                             width: window_width,
                             length: window_length,
                             spline_offset: spline_offset)
    end

    def add_door(at: nil, door_width: nil, door_length: nil)
      @doors << Door.new(origin: at,
                         width: door_width,
                         length: door_length,
                         spline_offset: spline_offset)
      @doors.sort! { |a, b| b.end_x <=> a.end_x }
    end

    def add_roof_slant(slant_height: nil, slant_right: true)
      @roof_slant = {height: slant_height,
                     slant_right?: slant_right}
    end

    def spline_lengths
      if @roof_slant

        spl = [width - spline_offset * 2]
        spl << @length #non slant side
        spl << length #slant side
        slanted_width = Sk.round(Math.sqrt(width ** 2 + @roof_slant[:height] ** 2))

        spl << slanted_width - 2 * spline_offset

      else
        spl = [width - spline_offset * 2, width - spline_offset * 2, length, length]
      end

      @windows.each do |window|
        spl.concat(window.spline_lengths)
      end
      @doors.each do |door|
        spl.concat(door.spline_lengths)
      end
      spl.flatten
    end

    def face_points

      part_points = []
      part_points << [0, 0, 0]
      if @roof_slant
        if @roof_slant[:slant_right?]

          part_points << [0, @length, 0]
          part_points << [width, length, 0]
        else
          part_points << [0, length , 0]
          part_points << [width, @length, 0]
        end
      else
        part_points << [0, length, 0]
        part_points << [width, length, 0]
      end


      part_points << [width, 0, 0]
      @doors.each do |door|
        door.face_points.reverse.each do |dpt|
          part_points << dpt
        end
      end
      part_points
    end

    def interior_points
      offsets = [
          [spline_offset, spline_offset, 0],
          [spline_offset, negative_spline_offset, 0],
          [negative_spline_offset, negative_spline_offset, 0],
          [negative_spline_offset, spline_offset, 0]
      ]
      @doors.each do |door|
        door.interior_offsets.reverse.each do |dpt|
          offsets << dpt
        end
      end
      Sk.shift_point_array(face_points, offsets)


    end

    def face_pocket_points
      @windows.collect do |window|
        window.face_points
      end
    end

    def interior_pocket_points
      @windows.collect do |window|
        window.interior_points
      end
    end

    def draw!(placement_x = 0)
      @panel = Panel.new(origin: origin,
                         label: @label,
                         face_sheet: @parent_part.face_sheet,
                         interior_sheet: @parent_part.interior_sheet,
                         spline_sheet: @parent_part.spline_sheet,
                         face_points: face_points,
                         face_pocket_points: face_pocket_points,
                         interior_points: interior_points,
                         interior_pocket_points: interior_pocket_points,
                         spline_lengths: spline_lengths,
                         parent_part: self)
      @panel.draw!(placement_x)
    end
  end
  class RoofPanel

  end
  class SplitRoof

  end

  class Door
    attr_reader :length, :width, :spline_offset

    def initialize(origin: nil,
                   length: nil,
                   width: nil,
                   spline_offset: nil)
      @origin = origin
      @length = length
      @width = width
      @spline_offset = spline_offset

    end

    def start_x
      @origin.x
    end

    def end_x
      puts " My origin is #{Sk.point_to_s(@origin)} #{width}"
      @origin.x + width
    end

    def face_points
      [
          [0, 0, 0],
          [0, @length, 0],
          [@width, @length, 0],
          [@width, 0, 0]

      ].map { |pt| Sk.shift_point(pt, origin: @origin) }
    end

    def negative_spline_offset
      spline_offset * -1.0
    end

    def interior_offsets
      [
          [negative_spline_offset, spline_offset, 0],
          [negative_spline_offset, spline_offset, 0],
          [spline_offset, spline_offset, 0],
          [spline_offset, spline_offset, 0]
      ]
    end

    def interior_points
      Sk.shift_point_array(face_points, interior_offsets)
    end

    def spline_lengths
      #doors have an inset spline and then double rails on the side
      [width, length - 2 * spline_offset,
       length - 2 * spline_offset,
       length - 1 * spline_offset,
       length - 1 * spline_offset]
    end
  end
  class Window
    attr_reader :length, :width, :spline_offset

    def initialize(origin: nil,
                   length: nil,
                   width: nil,
                   spline_offset: nil)
      @origin = origin
      @length = length
      @width = width
      @spline_offset = spline_offset

    end

    def face_points
      [
          [0, 0, 0],
          [0, @length, 0],
          [@width, @length, 0],
          [@width, 0, 0]

      ].map { |pt| Sk.shift_point(pt, origin: @origin) }
    end

    def negative_spline_offset
      spline_offset * -1.0
    end

    def interior_offsets
      [
          [negative_spline_offset, negative_spline_offset, 0],
          [negative_spline_offset, spline_offset, 0],
          [spline_offset, spline_offset, 0],
          [spline_offset, negative_spline_offset, 0]
      ]
    end

    def interior_points
      Sk.shift_point_array(face_points, interior_offsets)
    end

    def spline_lengths
      [length, length, width , width ]
    end
  end


  attr_reader :roof, :floor, :walls

  def initialize(origin: nil, label: nil, parent_part: nil)
    @origin = origin
    @label = label
    @parent_part = @parent_part
    @walls = []
    @roof = nil
    @floor = Floor.new(origin: @origin,
                       parent_part: self,
                       label: "#{@label} Floor")
  end

  def face_sheet
    WikiHouse::Meranti27mmSheet.new
  end

  def interior_sheet
    WikiHouse::CoroplastSheet.new
  end

  def spline_sheet
    face_sheet
  end

  def roof_support_sheet
    face_sheet
  end

  def spline_offset
    spline_sheet.thickness
  end

  def scale_factor

    #Use this if the materials need to change
    original_floor_length = 1
    new_floor_length = 1
    (((new_floor_length/original_floor_length) * 1000).round * 1.0)/1000
  end

  def scale(val)
    ((val * scale_factor * 100).round * 1.0)/100
  end

  def origin=(new_origin)
    @origin = new_origin
    @roof.origin = new_origin
    @floor.origin = new_origin
    @walls.each { |wall| wall.origin = new_origin }
  end

  def draw!
    Sk.find_or_create_layer(name: self.class.name)
    Sk.make_layer_active_name(name: self.class.name)
    placement_x = 0
    groups = []
    #  placement_x = @roof.draw!(placement_x)
    # groups << @roof.group
  #  placement_x = @floor.draw!(placement_x)
  #    groups << @floor.group

     #  @walls.each do |wall|
     #    placement_x = wall.draw!(placement_x)
     #    groups << wall.group
     # end


  #   roof_angle = RoofAngle.new(origin: origin, label: "Right Roof Face",
  #                              sheet: face_sheet,
  #                              points: [
  #                                  [0, 0, 0],
  #                                  [0, 10.4805, 0],
  #                                  [ 19.81, 0,0]
  # 
  #                              ])
  # roof_angle.draw!(placement_x)
  #   placement_x += 30
  #   groups << roof_angle.group
  #   roof_angle2 = RoofAngle.new(origin: origin, label: "Right Roof Mirror Face",
  #                              sheet: face_sheet,
  #                              points: [
  #                                  [0,0,0],
  #                                  [ 19.81, 10.4805,0],
  #                                  [ 19.81, 0,0]
  #                              ])
  #   roof_angle2.draw!(placement_x)
  #   groups << roof_angle2.group
  #   placement_x += 30
  #   ft = face_sheet.thickness
  #   roof_spline_1 = RoofAngle.new(origin: origin, label: "Right Roof Spline 1",
  #                              sheet: spline_sheet,
  #                              points: [
  #                                  # [0, 0, 0],
  #                                  # [0, 0,0.569],
  #                                  # [ -19.81,0,0.579],
  #                                  # [-19.81,0,0.01]
  #                                  [0, ft, 0],
  #                                  [0,0.569 - ft, 0],
  #                                  [ 19.81,0.569 -ft,0],
  #                                  [19.81,ft,0]
  # 
  #                              ])
  #   roof_spline_1.draw!(placement_x)
  #   placement_x += 25
  #   groups << roof_spline_1.group
  #   roof_spline_2 = RoofAngle.new(origin: origin, label: "Right Roof Spline 2",
  #                                 sheet: spline_sheet,
  #                                 points: [
  #                                     # [0, 0, 0],
  #                                     # [0, 0,0.569],
  #                                     # [0, -10.28, -1.471],
  #                                     # [0, -10.28,-2.04]
  #                                     [ 0, ft ,0],
  #                                     [0,0.569 - ft ,0],
  #                                     [ 10.280,2.6090 - ft ,0],
  #                                     [ 10.280,2.040 + ft ,0]
  # 
  #                                 ])
  #   roof_spline_2.draw!(placement_x)
  #   placement_x += 25
  #   groups << roof_spline_2.group
  #   roof_spline_3 = RoofAngle.new(origin: origin, label: "Right Roof Spline 3",
  #                                 sheet: spline_sheet,
  #                                 points: [
  #                                     # [0, 0, 0],
  #                                     # [0, 0,0.569],
  #                                     # [-19.81,-10.28,2.599],
  #                                     # [-19.81, -10.28,2.03]
  #                                    #  [0, ft, 0],
  #                                    #  [ 0,0.569 - ft,0],
  #                                    # [22.4106, 2.5990 - ft,0],
  #                                    #  [22.4106, 2.03 + ft,0]
  #                                      [0, ft, 0],
  #                                      [ 0,0.569 - ft ,0],
  #                                     [22.3185 , 2.5990 - ft,0],
  #                                     [22.3185, 2.03 + ft,0]
  # 
  # 
  #                                 ])
  #   roof_spline_3.draw!(placement_x)
  #   placement_x += 25
  #   groups << roof_spline_3.group
    roof_angle = RoofAngle.new(origin: origin, label: "Left Roof Face",
                               sheet: face_sheet,
                               points: [
                                   [0, 0, 0],
                                   [0, 10.28, 0],
                                   [ 19.9137, 0,0]

                               ])
    roof_angle.draw!(placement_x)
    placement_x += 30
    groups << roof_angle.group
    roof_angle2 = RoofAngle.new(origin: origin, label: "Left Roof Mirror Face",
                                sheet: face_sheet,
                                points: [
                                    [0,0,0],
                                    [ 19.9137, 10.28,0],
                                    [ 19.9137, 0,0]
                                ])
    roof_angle2.draw!(placement_x)
    groups << roof_angle2.group
    placement_x += 30
    ft = face_sheet.thickness
    roof_spline_1 = RoofAngle.new(origin: origin, label: "Left Roof Spline 1",
                                  sheet: spline_sheet,
                                  points: [
                                      # [0, 0, 0],
                                      # [0, 0,0.569],
                                      # [ -19.81,0,0.579],
                                      # [-19.81,0,0.01]
                                      [0, ft, 0],
                                      [0,0.569 - ft, 0],
                                      [ 10.280,0.569 -ft,0],
                                      [10.280,ft,0]

                                  ])
    roof_spline_1.draw!(placement_x)
    placement_x += 25
    groups << roof_spline_1.group

    roof_spline_2 = RoofAngle.new(origin: origin, label: "Left Roof Spline 2",
                                  sheet: spline_sheet,
                                  points: [
                                      # [0, 0, 0],
                                      # [0, 0,0.569],
                                      # [0, -10.28, -1.471],
                                      # [0, -10.28,-2.04]
                                      [ 0, ft ,0],
                                      [0,0.569 - ft ,0],
                                      [ 19.81,2.599 - ft ,0],
                                      [ 19.81,2.03 + ft ,0]

                                  ])
    roof_spline_2.draw!(placement_x)
    placement_x += 25
    groups << roof_spline_2.group
    roof_spline_3 = RoofAngle.new(origin: origin, label: "Left Roof Spline 3",
                                  sheet: spline_sheet,
                                  points: [
                                      # [0, 0, 0],
                                      # [0, 0,0.569],
                                      # [-19.81,-10.28,2.599],
                                      # [-19.81, -10.28,2.03]
                                      #  [0, ft, 0],
                                      #  [ 0,0.569 - ft,0],
                                      # [22.4106, 2.5990 - ft,0],
                                      #  [22.4106, 2.03 + ft,0]
                                      [0, ft, 0],
                                      [ 0,0.569 - ft ,0],
                                      [22.3185 , 2.5990 - ft,0],
                                      [22.3185, 2.03 + ft,0]


                                  ])
    roof_spline_3.draw!(placement_x)
    placement_x += 25
    groups << roof_spline_3.group
    # roof_angle2 = RoofAngle.new(origin: origin, label: "Roof Angle",
    #                            sheet: face_sheet,
    #                            points: [
    #                                [0, 0, 0],
    #                                [0, 0.5823, 0],
    #                                [5.623, 0.5823, 0],
    #                                [5.623, 0, 0]
    #                            ])
    # placement_x = roof_angle2.draw!(6)
    # groups << roof_angle2.group
    #
    # roof_angle2 = RoofAngle.new(origin: origin, label: "Roof Angle",
    #                             sheet: face_sheet,
    #                             points: [
    #                                 [0, 0, 0],
    #                                 [0, 0.157, 0],
    #                                 [5.623 - (2 * 0.106) - 0.2911, 0.157, 0],
    #                                 [5.623 - (2 * 0.106) - 0.2911, 0, 0]
    #                             ])
    # placement_x = roof_angle2.draw!(6)
    # groups << roof_angle2.group
    set_group(groups.flatten.compact)


  end


end