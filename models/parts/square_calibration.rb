#This part is here to help validate the OpenSBP implentation

#Steps - Draw a square with a hole in the middle and fillets. Mark  inside edges
#Flatten
#nest
#save as opensbp file

#Todo
#dowels
#pockets
#curves

class WikiHouse::SquareCalibration

  class Square
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
    def length
      internal_unit * 5
    end

    def width
      internal_unit * 5
    end


    def internal_unit
      parent_part.internal_unit/5.0
    end

    def make_points
      t = thickness
      outer_points = []
      outer_points << [bounding_c1.x, bounding_c1.y, bounding_c1.z]
      outer_points << [bounding_c1.x + width, bounding_c1.y, bounding_c1.z]
      outer_points << [bounding_c1.x + width, bounding_c1.y - length , bounding_c1.z]
      outer_points << [bounding_c1.x, bounding_c1.y - length, bounding_c1.z]


      outer_points
    end

    def make_pockets!


      t = thickness


      pockets = []
      #Top pocket

      c5 = [bounding_c1.x + 2 * internal_unit,
            bounding_c1.y - internal_unit,
            bounding_c1.z]

      c6 = [c5.x + internal_unit, c5.y, c5.z]
      c7 = [c6.x, c5.y - internal_unit, c5.z]
      c8 = [c5.x, c7.y, c5.z]
      points = [c5, c6, c7, c8]

      WikiHouse::Fillet.pocket_by_points(points)

      pocket_lines = Sk.draw_all_points(points)
      pocket_lines.each { |e| mark_inside_edge!(e) }
      pockets << pocket_lines

      #Left bottom pocket
      c5 = [bounding_c1.x +  internal_unit,
            bounding_c1.y - 3 * internal_unit,
            bounding_c1.z]

      c6 = [c5.x + internal_unit, c5.y, c5.z]
      c7 = [c6.x, c5.y - internal_unit, c5.z]
      c8 = [c5.x, c7.y, c5.z]
      points = [c5, c6, c7, c8]

      WikiHouse::Fillet.pocket_by_points(points)

      pocket_lines = Sk.draw_all_points(points)
      pocket_lines.each { |e| mark_inside_edge!(e) }
      pockets << pocket_lines
      #right bottom pocket
      c5 = [bounding_c1.x +  3 * internal_unit,
            bounding_c1.y - 3 * internal_unit,
            bounding_c1.z]

      c6 = [c5.x + internal_unit, c5.y, c5.z]
      c7 = [c6.x, c5.y - internal_unit, c5.z]
      c8 = [c5.x, c7.y, c5.z]
      points = [c5, c6, c7, c8]

      WikiHouse::Fillet.pocket_by_points(points)

      pocket_lines = Sk.draw_all_points(points)
      pocket_lines.each { |e| mark_inside_edge!(e) }
      pockets << pocket_lines
      pockets

    end

    def make_dowels!

      # return [] if WikiHouse.machine.bit_radius == 0
      # t = thickness
      #
      # dowel_points = []
      # #Back Leg Dowels
      # dowel_points << [bounding_c1.x + 1.5, bounding_c1.y - 1, bounding_c1.z]
      # dowel_points << [bounding_c1.x + 2.1, bounding_c1.y - 4, bounding_c1.z]
      # dowel_points << [bounding_c1.x + 2.7, bounding_c1.y - 8, bounding_c1.z]
      # dowel_points << [bounding_c1.x + 3.3, bounding_c1.y - 12, bounding_c1.z]
      # dowel_points << [bounding_c1.x + 3.9, bounding_c1.y - 16, bounding_c1.z]
      # dowel_points << [bounding_c1.x + 4.5, bounding_c1.y - 20, bounding_c1.z]
      # dowel_points << [bounding_c1.x + 5.1, bounding_c1.y - 24, bounding_c1.z]
      # dowel_points << [bounding_c1.x + 5.7, bounding_c1.y - 28, bounding_c1.z]
      #
      # #ftont leg dowels
      # dowel_points << [bounding_c1.x + 24.25, bounding_c1.y - 1, bounding_c1.z]
      # dowel_points << [bounding_c1.x + 23, bounding_c1.y - 4, bounding_c1.z]
      # dowel_points << [bounding_c1.x + 21.8, bounding_c1.y - 8, bounding_c1.z]
      # dowel_points << [bounding_c1.x + 20.6, bounding_c1.y - 12, bounding_c1.z]
      # dowel_points << [bounding_c1.x + 19.4, bounding_c1.y - 16, bounding_c1.z]
      # dowel_points << [bounding_c1.x + 18.2, bounding_c1.y - 20, bounding_c1.z]
      # dowel_points << [bounding_c1.x + 17, bounding_c1.y - 24, bounding_c1.z]
      # dowel_points << [bounding_c1.x + 15.8, bounding_c1.y - 28, bounding_c1.z]
      #
      # # Mid
      # dowel_points << [bounding_c1.x + 10, bounding_c1.y - 25.5, bounding_c1.z]
      # dowel_points << [bounding_c1.x + 10, bounding_c1.y - 28, bounding_c1.z]
      #
      # dowels = []
      # dowel_points.each { |d| dowels << Sk.draw_circle(center_point: d, radius: WikiHouse.machine.bit_radius) }
      # dowels.each { |d| d.each { |e| mark_inside_edge!(e) } }
      #
      # dowels
    end

    def draw!

      points = make_points


      lines = Sk.draw_all_points(points)
      # if WikiHouse.machine.bit_radius != 0
      #   dowels = make_dowels!
      # else
      #   dowels = []
      # end

      pockets = make_pockets!

      face = Sk.add_face(lines)
      set_material(face)

      # dowels.each do |sp|
      #   dowel_face = Sk.add_face(sp)
      #   dowel_face.erase!
      # end
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

  attr_reader :upper_left, :upper_right, :lower_left, :lower_right

  def initialize(origin: nil, sheet: nil, label: nil, parent_part: nil)
    part_init(sheet: sheet, origin: origin, parent_part: parent_part)


    @upper_left = Square.new(label: "Upper Left", origin: @origin, sheet: sheet, parent_part: self)
    @upper_right = Square.new(label: "Upper Right", origin: @origin, sheet: sheet, parent_part: self)
    @lower_left = Square.new(label: "Lower Left", origin: @origin, sheet: sheet, parent_part: self)
    @lower_right = Square.new(label: "Lower Right", origin: @origin, sheet: sheet, parent_part: self)



  end

  def origin=(new_origin)
    @origin = new_origin
    @upper_left.origin = @origin
    @upper_right.origin = @origin
    @lower_left.origin = @origin
    @lower_right.origin = @origin

  end
  def internal_unit
    value = 10
    sheet.length == 24 ? value/4.0 : value
  end
  def length
    internal_unit * 3
  end


  def width
    internal_unit * 3
  end



  def draw!
    Sk.find_or_create_layer(name: self.class.name)
    Sk.make_layer_active_name(name: self.class.name)

    @upper_left.draw!
    @upper_left.move_by(x: 0,
                 y: internal_unit * 2,
                 z: 0).go!
    @upper_right.draw!
    @upper_right.move_by(x: internal_unit * 2,
                        y: internal_unit * 2,
                        z: 0).go!
    @lower_left.draw!
     @lower_left.move_by(x: 0,
                         y: 0,
                         z: 0).go!
    @lower_right.draw!
    @lower_right.move_by(x: internal_unit * 2,
                         y: 0,
                         z: 0).go!


    groups = [@upper_left.group, @upper_right.group, @lower_left.group,
              @lower_right.group]


    set_group(groups.compact)
  end


end
