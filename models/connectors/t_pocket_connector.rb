#This is a t shape pocket
#The dimentions of the top of the t anre the length_t and width_in_t
#The dimesions of the stem of the T are the stem_length_in_t and stem_width_in_t



class WikiHouse::TPocketConnector < WikiHouse::PocketConnector

  attr_reader :stem_width_in_t, :stem_length_in_t
  def initialize(length_in_t: nil, count: 1, width_in_t: nil, thickness: nil, rows: 1, stem_width_in_t: nil, stem_length_in_t: nil)
    super(length_in_t: length_in_t, count:count, width_in_t: width_in_t , thickness: thickness, rows: rows)
    @stem_length_in_t = stem_length_in_t ? stem_length_in_t : 8
    @stem_width_in_t = stem_width_in_t ? stem_width_in_t : 2
  end
  def bounding_length
    length_in_t > stem_length_in_t ? length_in_t * thickness : stem_length_in_t * thickness
  end
  def bounding_width
    width_in_t > stem_width_in_t ? width_in_t * thickness : stem_width_in_t * thickness
  end
  
  def initialize(length: nil, count: 1, width: nil, rows: 1)

    super(length: length, count: count, width: width)
    @rows = rows
  end

  def pocket?
    true
  end
  def name
    :t_pocket
  end
end