class WikiHouse::ColumnRib

  include WikiHouse::PartHelper
  include WikiHouse::BoardPartHelper

  def initialize(column: nil, sheet: nil, group: nil, origin: nil, label: label)
    part_init(origin: origin, sheet: sheet, label: label)
    @column = column ? column : raise(ArgumentError, "You must provide a Column")
    @length_method = :width
    @width_method = :width
    init_board(right_connector:  WikiHouse::TabConnector.new(count: 1, width: @sheet.thickness),
               top_connector:  WikiHouse::TabConnector.new(count: 1, width: @sheet.thickness),
               bottom_connector:  WikiHouse::TabConnector.new(count: 1, width: @sheet.thickness),
               left_connector:  WikiHouse::TabConnector.new(count: 1, width: @sheet.thickness),
               )

  end


  def parent_part
    @column
  end


end