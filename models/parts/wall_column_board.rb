class WikiHouse::WallColumnBoard < WikiHouse::ColumnBoard


  def initialize(parent_part: nil, sheet: nil, group: nil, origin: nil, label: label)
    super
    add_face_connector(WikiHouse::ZPegBottomConnector.new(count:parent_part.wall_panel_zpegs, thickness: thickness))

  end


end