class WikiHouse::DoorPanelTopCap

  include WikiHouse::PartHelper
  include WikiHouse::BoardPartHelper
  include WikiHouse::AttributeHelper

  def initialize(parent_part: nil, sheet: nil, group: nil, origin: nil, label: label)
    part_init(origin: origin, sheet: sheet, label: label, parent_part: parent_part)

    @length_method = :width
    @width_method = :depth

    init_board(right_connector: WikiHouse::TabConnector.new(count: 2, thickness: thickness),
               top_connector: WikiHouse::TabConnector.new(count: 1, thickness: thickness),
               bottom_connector: WikiHouse::TabConnector.new(count: 1, thickness: thickness),
               left_connector: WikiHouse::TabConnector.new(count: 2, thickness: thickness),
               face_connector: [WikiHouse::UPegLockPocketConnector.new(thickness: thickness, orientations: [WikiHouse::Orientation.north, WikiHouse::Orientation.south]),
                                WikiHouse::PocketConnector.new(thickness:thickness, count: parent_part.number_of_top_column_supports)]
    )

  end
end