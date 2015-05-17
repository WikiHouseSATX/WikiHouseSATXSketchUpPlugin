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
               top_connector: WikiHouse::ShelfieHookConnector.new( thickness: thickness),
               bottom_connector: WikiHouse::NoneConnector.new,
               left_connector: WikiHouse::NoneConnector.new,
               face_connector: WikiHouse::ShelfiePocketConnector.new(thickness: thickness))

  end

  def length

    if sheet.width == 12
      3.75
    else
      15
    end
  end

  def width

    if sheet.width == 12
      4
    else
      12
    end
  end
end