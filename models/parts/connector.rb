class WikiHouse::Connector

  def self.standard_size
    5
  end
  def self.small_size
    standard_size/2.0
  end
  def self.large_size
    standard_size * 2.0
  end
  attr_reader :size, :count
  def initialize(size: nil, count: 1)
    @size = size ? size : self.class.standard_size
    @count = count
  end
  def slot?
    false
  end
  def tab?
    false
  end
  def none?
    false
  end
  def pocket?
    false
  end
end