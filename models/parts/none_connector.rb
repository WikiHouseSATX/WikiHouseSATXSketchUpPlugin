class WikiHouse::NoneConnector < WikiHouse::Connector
  def initialize(length: nil, count: 0)
    super
    @length = 0
    @count = 0
  end
  def length
    0
  end
  def count
    0
  end
  def none?
    true
  end
end