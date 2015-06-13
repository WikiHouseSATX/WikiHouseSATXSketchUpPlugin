class WikiHouse::DoorPanelOuterSide

  include WikiHouse::PartHelper

  class TopPart
    include WikiHouse::PartHelper
    include WikiHouse::BoardPartHelper

    def initialize(parent_part: nil, sheet: nil, group: nil, origin: nil, label: label)
      part_init(origin: origin, sheet: sheet, label: label, parent_part: parent_part)

      @length_method = :top_length
      @width_method = :top_width
      init_board(right_connector: WikiHouse::TabConnector.new(count: 1, thickness: thickness),
                 top_connector: WikiHouse::SlotConnector.new(count: 1, thickness: thickness),
                 bottom_connector:WikiHouse::SlotConnector.new(count: 1, thickness: thickness),
                 left_connector: WikiHouse::TabConnector.new(count: 1, thickness: thickness),
                 face_connector: [WikiHouse::UPegEndPassThruConnector.new(thickness: thickness, bottom_on: false)]
      )

    end
  end
  class BottomPart
    include WikiHouse::PartHelper
    include WikiHouse::BoardPartHelper

    def initialize(parent_part: nil, sheet: nil, group: nil, origin: nil, label: label)
      part_init(origin: origin, sheet: sheet, label: label, parent_part: parent_part)

      @length_method = :bottom_length
      @width_method = :bottom_width
       init_board(right_connector: WikiHouse::TabConnector.new(count: 2, thickness: thickness),
                  top_connector: WikiHouse::SlotConnector.new(count: 1, thickness: thickness),
                  bottom_connector: WikiHouse::SlotConnector.new(count: 1, thickness: thickness, length_in_t: 2),
                  left_connector: WikiHouse::TabConnector.new(count: 2, thickness: thickness),
                  face_connector: [WikiHouse::PocketConnector.new(count: parent_part.number_of_internal_supports),
                                   WikiHouse::UPegEndPassThruConnector.new(thickness: thickness),
                                   WikiHouse::UPegPassThruConnector.new(thickness: thickness, count: parent_part.number_of_internal_supports)]

      )
      # init_board(right_connector: WikiHouse::TabConnector.new(count: 2, thickness: thickness),
      #            top_connector: WikiHouse::SlotConnector.new(count: 1, thickness: thickness),
      #            bottom_connector: WikiHouse::SlotConnector.new(count: 1, thickness: thickness, length_in_t: 2),
      #            left_connector: WikiHouse::TabConnector.new(count: 2, thickness: thickness),
      #            face_connector: [
      #                WikiHouse::UPegPassThruConnector.new(thickness: thickness, count: parent_part.number_of_internal_supports),
      #                WikiHouse::UPegEndPassThruConnector.new(thickness: thickness),
      #
      #                WikiHouse::DoorPanelTopConnector.new(thickness: thickness, offset: parent_part.top_column_length - thickness)]
      # )

    end
  end

  def initialize(parent_part: nil, sheet: nil, group: nil, origin: nil, label: label)
    part_init(origin: origin, sheet: sheet, label: label, parent_part: parent_part)

    @top_part = TopPart.new(parent_part: self, sheet: self.sheet,
                            origin: self.origin,
                            label: "top")
    @bottom_part = BottomPart.new(parent_part: self, sheet: self.sheet,
                                  origin: [self.origin.x,
                                           self.origin.y - top_length,
                                           self.origin.z],
                                  label: "bottom")
  end

  def origin=(new_origin)
    @top_part.origin = new_origin
    @bottom_part.origin = new_origin
  end

  def top_width
    parent_part.depth
  end

  def top_length
    parent_part.top_column_length
  end

  def bottom_width
    parent_part.depth
  end

  def bottom_length
    parent_part.length - top_length
  end

  def number_of_internal_supports
    3
  end

  def draw!
    Sk.find_or_create_layer(name: self.class.name)
    Sk.make_layer_active_name(name: self.class.name)

    @top_part.draw!
    # @top_cap.rotate(vector: [0, 0, 1], rotation: -90.degrees).move_to(point: origin).
    #     move_by(x: (@top_cap.width - thickness) * -1,
    #             y: 0,
    #             z: length - 2 * @top_cap.thickness).
    #     go!
    @bottom_part.draw!
    # @bottom_cap.rotate(vector: [0, 0, 1], rotation: -90.degrees).move_to(point: origin).
    #     move_by(x: (@bottom_cap.width - thickness) * -1,
    #             y: 0,
    #             z: -1 * @bottom_cap.thickness).
    #     go!

    groups = []
    groups.concat([@top_part.group, @bottom_part.group])
    set_group(groups.compact)
  end

end