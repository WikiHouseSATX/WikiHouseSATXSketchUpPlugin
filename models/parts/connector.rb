class WikiHouse::Connector

  def self.standard_length
    5
  end
  def self.small_length
    standard_length/2.0
  end
  def self.large_length
    standard_length * 2.0
  end
  attr_reader :length, :count
  def initialize(length: nil, count: 1)
    @length = length ? length : self.class.standard_length
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