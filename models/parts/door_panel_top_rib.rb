class WikiHouse::DoorPanelTopRib
  include WikiHouse::PartHelper
  include WikiHouse::BoardPartHelper

  def initialize(parent_part: nil, sheet: nil, group: nil, origin: nil, label: label)
    part_init(origin: origin, sheet: sheet, label: label, parent_part: parent_part)
    @length_method = :top_column_length
    @width_method = :depth
    init_board(right_connector: WikiHouse::TabConnector.new(count: 1, thickness: thickness),
               top_connector: WikiHouse::TabConnector.new(count: 1, thickness: thickness),
               bottom_connector: WikiHouse::TabConnector.new(count: 1, thickness: thickness),
               left_connector: WikiHouse::TabConnector.new(count: 1, thickness: thickness)

    )

  end

end