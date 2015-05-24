class WikiHouse::ShelfieHookConnector < WikiHouse::Connector
  attr_reader :rows

  def initialize(length_in_t: nil, count: 1, width_in_t: nil, thickness: nil)
    count = 1
    @count = 1
    super
    @count = 1
    @length_in_t = 2
  end

  def count
    1
  end

  def shelfie_hook?
    true
  end

  def name
    :shelfie_hook
  end

  def points(bounding_start: nil,
             bounding_end: nil,
             start_pt: nil,
             end_pt: nil,
             orientation: nil,
             starting_thickness: nil,
             total_length: nil)
   if orientation == :top


      c1 = start_pt
      if start_pt.y  > (bounding_start.y - length/2.0)
        c1.y = bounding_start.y - length/2.0
      end
      c8 = [end_pt.x, c1.y - length/2.0, c1.z]
      bp1 = Geom::Point3d.new c1
      bp2 = Geom::Point3d.new c8
      edge_length = bp1.distance bp2


      c2 = [c1.x + edge_length/4.0, c1.y, c1.z]
      c3 = [c2.x, c2.y + 1 * thickness, c2.z]
      c4 = [c3.x + edge_length/2.0, c3.y, c3.z]
      c5 = [c4.x, c4.y - 1 * thickness, c4.z]
      c6 = [c5.x - edge_length/4.0, c5.y, c5.z]
      c7 = [c6.x , c6.y - 1 * thickness, c6.z]



      pt_list = [c1,c2,c3,c4,c5,c6,c7,c8]
      WikiHouse::Fillet.by_points(pt_list,
                                  6,
                                  5,
                                  4,reverse_it: true)
      WikiHouse::Fillet.by_points(pt_list,
                                  7,
                                  8,
                                  9)

    else
      raise ArgumentError, "#{orientation} is not supported by this connector"
    end
    pt_list
  end
end