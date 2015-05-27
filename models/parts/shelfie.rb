class WikiHouse::Shelfie

  include WikiHouse::PartHelper
  include WikiHouse::BoardPartHelper


  def initialize(parent_part: nil, sheet: nil,
                 group: nil, origin: nil, label: label)
    part_init(origin: origin, sheet: sheet, label: label, parent_part: parent_part)
    @origin.z = thickness

    @length_method = :length
    @width_method = :width

    init_board(right_connector: WikiHouse::NoneConnector.new,
               top_connector: WikiHouse::ShelfieHookConnector.new(thickness: thickness),
               bottom_connector: WikiHouse::NoneConnector.new,
               left_connector: WikiHouse::NoneConnector.new,
               face_connector: [WikiHouse::ShelfiePocketConnector.new(thickness: thickness, width_in_t: (width/2.0)/thickness),
                                WikiHouse::ShelfieGrooveConnector.new(sheet: @sheet, width_in_t: (width/thickness/2.0))])

  end

  def length
    value = 18

    if sheet.width == 12
      return(value/4)
    else
      value
    end

  end

  def width
    value = 16

    if sheet.width == 12
      return(value/4)
    else
      value
    end

  end
end