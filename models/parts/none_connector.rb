class WikiHouse::NoneConnector < WikiHouse::Connector
  def initialize(size: nil, count: 0)
    super
    @count = 0
  end
  def count
    0
  end
  def none?
    true
  end
end