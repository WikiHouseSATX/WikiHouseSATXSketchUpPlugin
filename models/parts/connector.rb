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

  attr_reader :length, :count, :width

  def initialize(length: nil, count: 1, width: nil)
    @length = length ? length : self.class.standard_length
    @count = count
    @width = width ? width : WikiHouse::Sheet.new.thickness
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
  def rip?
    false
  end
  def name
    :connector
  end
end