class WikiHouse::ZPegConnector < WikiHouse::Connector
  def initialize(length: nil, count: 1, width: nil)
    super
    @count = 1

  end
  def count
    1
  end
  def zpeg?
    true
  end
  def name
    :zpeg
  end
end