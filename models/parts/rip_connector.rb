
#this connector is used when you need to remove a constant thickness from an edge
class WikiHouse::RipConnector < WikiHouse::Connector
  def initialize(length: nil, count: 1, width: nil)
   super
    @count = 1

  end
  def count
    1
  end
  def rip?
    true
  end
  def name
    :rip
  end
end