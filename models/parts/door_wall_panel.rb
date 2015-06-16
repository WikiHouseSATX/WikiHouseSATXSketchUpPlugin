class WikiHouse::DoorWallPanel < WikiHouse::WallPanel


  def width

    dp = WikiHouse::DoorPanel.new(sheet: sheet)
    length - dp.width

  end


end