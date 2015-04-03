#To make the math much more straight forward and since a connector is something the connects two different parts
# We have standarized on defining dimensions in terms of t (thickness)
# This makes it easier to sketch out and keep track of how the pieces fit together
# even if they are on connecting in three dimensions

class WikiHouse::Connector
include WikiHouse::AttributeHelper
  def self.standard_length_in_t
    1
  end
  def self.standard_width_in_t
    6
  end



  attr_reader :length_in_t, :count, :width_in_t,:thickness

  def initialize(length_in_t: nil, count: 1, width_in_t: nil, thickness: nil)
    @thickness = thickness ? thickness : WikiHouse::Sheet.new.thickness
    @length_in_t = length_in_t ? length_in_t : self.class.standard_length_in_t
    @count = count
    @width_in_t = width_in_t ? width_in_t : self.class.standard_width_in_t

  end

  def length
    length_in_t * thickness
  end
  def width
    width_in_t * thickness
  end
  def bounding_length
    length
  end
  def bounding_width
    width
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

  def zpeg?
    false
  end

  def zpeg_bottom?
    false
  end

  def zpeg_top?
    false
  end

  def name
    :connector
  end
end