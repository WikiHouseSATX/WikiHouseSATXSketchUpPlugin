
#this connector is used when you need to remove a constant thickness from an edge
class WikiHouse::RipConnector < WikiHouse::Connector
  attr_reader :rows
  def initialize(length_in_t: nil, count: 1, width_in_t: nil, thickness: nil)
    count = 1
    @count = 1
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