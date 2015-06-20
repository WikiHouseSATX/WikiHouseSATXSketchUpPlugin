class WikiHouse::UPegLockPocketConnector < WikiHouse::PocketConnector

  attr_accessor :orientations

  def initialize(thickness: nil, orientations: [])
    raise ArgumentError, "You must set the orientations of the UPeg Lock Pockets" if orientations.empty?
    #this is set for the NORTH/SOUTH - since all parts are built north south before being rotated into place
    super(length_in_t: 3, width_in_t: 2, thickness: thickness, rows: 1, count: 1)
    @orientations = orientations
  end

  def draw!(bounding_origin: nil, part_length: nil, part_width: nil)

  
    offset = 2 * thickness
    lines = []
    if orientations.include?(WikiHouse::Orientation.east) || orientations.include?(WikiHouse::Orientation.west)


      original_length_in_t = @length_in_t
      original_width_in_t = @width_in_t
      @length_in_t = original_width_in_t
      @width_in_t = original_length_in_t
      half_length_part = part_length/2.0
      half_length_connector = length/2.0
      if orientations.include?(WikiHouse::Orientation.east)

        lines.concat(draw_pocket!(location: [bounding_origin.x + offset,
                                             bounding_origin.y - half_length_part + half_length_connector,
                                             bounding_origin.z]))

      end
      if orientations.include?(WikiHouse::Orientation.west)
        lines.concat(draw_pocket!(location: [bounding_origin.x + part_width - offset - (@width_in_t * thickness),
                                             bounding_origin.y - half_length_part + half_length_connector,
                                             bounding_origin.z]))
      end
      @length_in_t = original_length_in_t
      @width_in_t = original_width_in_t
    end
    half_width_part = part_width/2.0
    half_width_connector = width/2.0

    if orientations.include?(WikiHouse::Orientation.south)
      lines.concat(draw_pocket!(location: [bounding_origin.x + half_width_part - half_width_connector,
                                           bounding_origin.y - offset,
                                           bounding_origin.z]))
    end

    if orientations.include?(WikiHouse::Orientation.north)
      lines.concat(draw_pocket!(location: [bounding_origin.x + half_width_part - half_width_connector,
                                           bounding_origin.y - part_length + offset + (@length_in_t * thickness),
                                           bounding_origin.z]))
    end
    lines
  end

  def rows
    1
  end

  def count
    2
  end

  def upeg?
    true
  end

  def upeg_lock?
    true
  end

  def name
    :upeg_lock
  end
end