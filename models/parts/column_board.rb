class WikiHouse::ColumnBoard

  include WikiHouse::PartHelper
  include WikiHouse::BoardPartHelper

  def initialize(column: nil, sheet: nil, group: nil, origin: nil, label: label)
    part_init(origin: origin, sheet: sheet, label: label)
    @column = column ? column : raise(ArgumentError, "You must provide a Column")
    @length_method = :length
    @width_method = :width
    init_board(right_connector:  WikiHouse::TabConnector.new(count: 3, width: @sheet.thickness),
               top_connector:  WikiHouse::SlotConnector.new(count: 1, width: @sheet.thickness),
               bottom_connector:  WikiHouse::SlotConnector.new(count: 1, width: @sheet.thickness),
               left_connector:  WikiHouse::SlotConnector.new(count: 3, width: @sheet.thickness),
                face_connector: WikiHouse::PocketConnector.new(count: @column.number_of_internal_supports, width: @sheet.thickness))

  end


  def parent_part
    @column
  end


end