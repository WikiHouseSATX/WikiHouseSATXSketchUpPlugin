class WikiHouse::DoorPanelSideFace

  include WikiHouse::PartHelper
  include WikiHouse::BoardPartHelper


  def initialize(parent_part: nil, sheet: nil, group: nil, origin: nil, label: label)
    part_init(origin: origin, sheet: sheet, label: label, parent_part: parent_part)

    @length_method = :side_column_inner_length
    @width_method = :side_column_width

    init_board(right_connector: WikiHouse::SlotConnector.new(count: 2, thickness: thickness),
               top_connector: WikiHouse::SlotConnector.new(count: 1, thickness: thickness),
               bottom_connector: WikiHouse::SlotConnector.new(count: 1, thickness: thickness, length_in_t: 2),
               left_connector: WikiHouse::SlotConnector.new(count: 2, thickness: thickness),
               face_connector: [WikiHouse::PocketConnector.new(thickness:thickness, count: parent_part.number_of_side_column_supports)]
    )

  end
end