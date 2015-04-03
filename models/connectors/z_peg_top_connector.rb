class WikiHouse::ZPegTopConnector < WikiHouse::PocketConnector


  def initialize(thickness: nil, rows: 1)
    super(length_in_t: 2, width_in_t: 4, thickness: thickness, rows: 1, count: 1)

  end


  def rows
    1
  end

  def count
    1
  end

  def zpeg?
    true
  end

  def zpeg_top?
    true
  end

  def name
    :zpeg_top
  end
end