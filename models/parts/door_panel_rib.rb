class WikiHouse::DoorPanelRib
  include WikiHouse::PartHelper
  include WikiHouse::AttributeHelper
  include WikiHouse::BoardPartHelper

  def initialize(parent_part: nil, sheet: nil, group: nil, origin: nil, label: label)
    part_init(origin: origin, sheet: sheet, label: label, parent_part: parent_part)
    @length_method = :depth
    @width_method = :side_column_width
    init_board(right_connector: WikiHouse::TabConnector.new(count: 1, thickness: thickness),
               top_connector: WikiHouse::TabConnector.new(count: 1, thickness: thickness),
               bottom_connector: WikiHouse::TabConnector.new(count: 1, thickness: thickness),
               left_connector: WikiHouse::TabConnector.new(count: 1, thickness: thickness),
               face_connector: WikiHouse::UPegLockPocketConnector.new(thickness: thickness, orientations: [WikiHouse::Orientation.east])
    )

  end

end