#This is a particularlly complex piece.  There is a top part that is really one section
#the bottom part is part of a different column
#to simpliest solution I could come up with was to design two parts and fuse them
#together into a single rendered part. This let me use all the math that already existed
#The down side is that I had to run the draw method by hand which means if the
#board part helper evolves this part is the most fragile in the system
class WikiHouse::DoorPanelBottomHeader

  include WikiHouse::PartHelper
  include WikiHouse::AttributeHelper
  class TopPart
    include WikiHouse::AttributeHelper
    include WikiHouse::PartHelper
    include WikiHouse::BoardPartHelper

    def initialize(parent_part: nil, sheet: nil, group: nil, origin: nil, label: label)
      part_init(origin: origin, sheet: sheet, label: label, parent_part: parent_part)

      @length_method = :top_length
      @width_method = :top_width
      init_board(right_connector: WikiHouse::TabConnector.new(count: 1, thickness: thickness),
                 top_connector: WikiHouse::TabConnector.new(count: 1, thickness: thickness),
                 bottom_connector: WikiHouse::SlotConnector.new(thickness: thickness, fillet_off: true),
                 left_connector: WikiHouse::TabConnector.new(count: 1, thickness: thickness)

      )

    end

  end
  class MiddlePart
    include WikiHouse::AttributeHelper
    include WikiHouse::PartHelper
    include WikiHouse::BoardPartHelper

    def initialize(parent_part: nil, sheet: nil, group: nil, origin: nil, label: label)
      part_init(origin: origin, sheet: sheet, label: label, parent_part: parent_part)

      @length_method = :middle_length
      @width_method = :middle_width
      init_board(right_connector: WikiHouse::RipConnector.new(count: 1, thickness: thickness),
                 top_connector: WikiHouse::NoneConnector.new(),
                 bottom_connector: WikiHouse::NoneConnector.new(),
                 left_connector: WikiHouse::RipConnector.new(count: 1, thickness: thickness),
      )

    end
  end
  class BottomPart
    include WikiHouse::AttributeHelper
    include WikiHouse::PartHelper
    include WikiHouse::BoardPartHelper

    def initialize(parent_part: nil, sheet: nil, group: nil, origin: nil, label: label)
      part_init(origin: origin, sheet: sheet, label: label, parent_part: parent_part)

      @length_method = :bottom_length
      @width_method = :bottom_width
      init_board(right_connector: WikiHouse::TabConnector.new(count: 1, thickness: thickness),
                 top_connector: WikiHouse::SlotConnector.new(thickness: thickness, fillet_off: true),
                 bottom_connector: WikiHouse::TabConnector.new(count: 1, thickness: thickness),
                 left_connector: WikiHouse::TabConnector.new(count: 1, thickness: thickness)

      )


    end
  end

  def initialize(parent_part: nil, sheet: nil, group: nil, origin: nil, label: label)
    part_init(origin: origin, sheet: sheet, label: label, parent_part: parent_part)

    @top_part = TopPart.new(parent_part: self, sheet: self.sheet,
                            origin: self.origin,
                            label: "top")
    @middle_part = MiddlePart.new(parent_part: self, sheet: self.sheet,
                                  origin: [self.origin.x,
                                           self.origin.y - top_length,
                                           self.origin.z],
                                  label: "middle")
    @bottom_part = BottomPart.new(parent_part: self, sheet: self.sheet,
                                  origin: [self.origin.x,
                                           self.origin.y - top_length - middle_length,
                                           self.origin.z],
                                  label: "bottom")
  end

  def origin=(new_origin)
    @origin = new_origing
    @top_part.origin = @origin
    @top_part.origin = [@origin.x,
                        @origin.y - top_length,
                        @origin.z]
    @bottom_part.origin = [@origin.x,
                           @origin.y - top_length - middle_length,
                           @origin.z]
  end

  def top_width
    parent_part.depth
  end

  def top_length
    parent_part.side_column_width
  end

  def middle_width
    parent_part.depth
  end

  def middle_length
    parent_part.width - 2 * top_length
  end

  def bottom_width
    parent_part.depth
  end

  def bottom_length
    top_length
  end

  def draw!
    Sk.find_or_create_layer(name: self.class.name)
    Sk.make_layer_active_name(name: self.class.name)


    @top_part.build_points
    @middle_part.build_points

    @bottom_part.build_points


    top_pocket = @top_part.fuse(onto: :bottom, from: :top, other_part: @middle_part)
    bottom_pocket = @top_part.fuse(onto: :bottom, from: :top, other_part: @bottom_part)

    lines = Sk.draw_all_points(@top_part.points)
    face = Sk.add_face(lines)
    @top_part.draw_non_groove_faces
    @middle_part.draw_non_groove_faces
    @bottom_part.draw_non_groove_faces

    top_pocket = [top_pocket[2], top_pocket[1], top_pocket[0], top_pocket[3]]
    WikiHouse::DogBoneFillet.pocket_by_points(top_pocket)

    pocket_lines = Sk.draw_all_points(top_pocket)
    pocket_lines.each { |e| mark_inside_edge!(e) }
    pocket_face = Sk.add_face(pocket_lines)
    pocket_face.erase!

    bottom_pocket = [bottom_pocket[0], bottom_pocket[3], bottom_pocket[2], bottom_pocket[1]]
    WikiHouse::DogBoneFillet.pocket_by_points(bottom_pocket)
    pocket_lines = Sk.draw_all_points(bottom_pocket)
    pocket_lines.each { |e| mark_inside_edge!(e) }
    pocket_face = Sk.add_face(pocket_lines)
    pocket_face.erase!


    set_material(face)
    make_part_right_thickness(face)
    face2 = Sk.add_face(lines)

    @top_part.mark_primary_face!(face)
    set_group(face.all_connected)


  end

  def set_default_properties
    mark_cutable!
  end
end