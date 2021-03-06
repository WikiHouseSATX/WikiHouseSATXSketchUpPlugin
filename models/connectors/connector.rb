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


  attr_reader :length_in_t, :count, :width_in_t, :thickness, :sections

  def initialize(length_in_t: nil, count: 1, width_in_t: nil, thickness: nil, sections: nil)
    @thickness = thickness ? thickness : WikiHouse.sheet.new.thickness
    @length_in_t = length_in_t ? length_in_t : self.class.standard_length_in_t
    @count = count
    @width_in_t = width_in_t ? width_in_t : self.class.standard_width_in_t
    @sections = sections
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

  def shelfie_hook?
    false
  end

  def shelfie_pocket?
    false
  end
  def shelfie_groove?
    false
  end
  def groove?
    false
  end
  def name
    :connector
  end

#This can be used to make it easier to place items

  def self.drawing_points(bounding_origin: nil, count: 1, rows: 1, part_length: nil, part_width: nil, item_length: nil, item_width: nil)
    #this doesn't support sections :(
    length_gap = Sk.round((part_length - (count * item_length))/(count.to_f + 1.0))

    width_gap = Sk.round((part_width - (rows * item_width))/(rows.to_f + 1.0))


    rows.times do |row|
      base_x = ((row + 1) * width_gap) + (row * item_width)

      count.times do |i|
        base_y = ((i + 1) * length_gap) + (i * item_length)
        location = [bounding_origin.x + base_x, bounding_origin.y - base_y, bounding_origin.z]
        yield row, i, location
      end
    end
  end
  def points(bounding_start: nil,
             bounding_end: nil,
             start_pt: nil,
             end_pt: nil,
             orientation: nil)
    []
  end
end