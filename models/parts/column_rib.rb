class WikiHouse::ColumnRib
  include WikiHouse::AttributeHelper
  include WikiHouse::PartHelper
  include WikiHouse::BoardPartHelper

  def initialize(parent_part: nil, sheet: nil, group: nil, origin: nil, label: label)
    part_init(origin: origin, sheet: sheet, label: label, parent_part: parent_part)
    @length_method = :width
    @width_method = :width
    init_board(right_connector:  WikiHouse::TabConnector.new(count: 1, thickness: @sheet.thickness),
               top_connector:  WikiHouse::TabConnector.new(count: 1, thickness: @sheet.thickness),
               bottom_connector:  WikiHouse::TabConnector.new(count: 1, thickness: @sheet.thickness),
               left_connector:  WikiHouse::TabConnector.new(count: 1, thickness: @sheet.thickness),
               )

  end

end