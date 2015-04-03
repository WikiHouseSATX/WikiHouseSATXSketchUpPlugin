class WikiHouse::PocketConnector < WikiHouse::Connector
  attr_reader :rows
  def initialize(length_in_t: nil, count: 1, width_in_t: nil, thickness: nil, rows: 1)
    super(length_in_t: length_in_t, count:count, width_in_t: width_in_t , thickness: thickness)
    @rows = rows
  end

  def pocket?
    true
  end
  def name
    :pocket
  end
end