class WikiHouse::PocketConnector < WikiHouse::Connector
  attr_reader :width
  def initialize(length: nil, count: 1, width: nil)

    super(length: length, count: count)
    @width = width ? width : WikiHouse::Sheet.new.thickness
  end
  def pocket?
    true
  end
end