class WikiHouse::WallColumnBoard < WikiHouse::ColumnBoard


  def initialize(parent_part: nil, sheet: nil, group: nil, origin: nil, label: label)

    super

    @face_connector = [
        WikiHouse::UPegPassThruConnector.new(thickness: @sheet.thickness, count: parent_part.number_of_internal_supports),
        WikiHouse::UPegEndPassThruConnector.new(thickness: @sheet.thickness),
        WikiHouse::PocketConnector.new(count: parent_part.number_of_internal_supports)
    ]

  end


end