class WikiHouse::UPegPassThruConnector < WikiHouse::PocketConnector


  def initialize(thickness: nil, count: 1)
    super(length_in_t: 10, width_in_t: 2, thickness: thickness, rows: 1, count: count)

  end

  def draw!(bounding_origin: nil, part_length: nil, part_width: nil)
    pockets_list = []
    self.class.drawing_points(bounding_origin: bounding_origin,
                              count: count,
                              rows: self.respond_to?(:rows) ? rows : 1,
                              part_length: part_length,
                              part_width: part_width,
                              item_length: thickness,
                              item_width: width) { |row, col, location|
      pockets_list << draw_pocket!(location: [location.x ,
                                              location.y - (3 * thickness),
                                              location.z])
    }
    pockets_list
  end

  def rows
    1
  end

  def upeg?
    true
  end

  def upeg_pass_thru?
    true
  end

  def name
    :upeg_pass_thru
  end
end