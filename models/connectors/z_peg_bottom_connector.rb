class WikiHouse::ZPegBottomConnector < WikiHouse::PocketConnector


  def initialize( count: 1, thickness: nil, rows: 1)
    super(length_in_t: 4, count:count, width_in_t: 8 , thickness: thickness, rows: rows)

  end


  def zpeg?
    true
  end
  def zpeg_bottom?
    true
  end
  def name
    :zpeg_bottom
  end
end