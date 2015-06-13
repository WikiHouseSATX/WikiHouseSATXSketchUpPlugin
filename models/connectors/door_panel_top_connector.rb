class WikiHouse::DoorPanelTopConnector < WikiHouse::PocketConnector

attr_accessor :offset
  def initialize(thickness: nil, offset: nil)
    super(length_in_t: 2, width_in_t: 6, thickness: thickness, rows: 1, count: 1)
    @offset = offset
  end

  def draw!(bounding_origin: nil, part_length: nil, part_width: nil)

    half_width_part = part_width/2.0
    half_width_connector = width/2.0



  draw_pocket!(location: [bounding_origin.x + half_width_part - half_width_connector ,
                                    bounding_origin.y - offset,
                                    bounding_origin.z])
   end

  def rows
    1
  end

  def count
    2
  end

  def door_panel_top?
    true
  end


  def name
    :door_panel_top
  end
end