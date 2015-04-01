class WikiHouse::PocketConnector < WikiHouse::Connector
  attr_reader :rows
  def initialize(length: nil, count: 1, width: nil, rows: 1)

    super(length: length, count: count, width: width)
    @rows = rows
  end

  def pocket?
    true
  end
  def name
    :pocket
  end
end