class WikiHouse::UPegLockPocketConnector < WikiHouse::PocketConnector

  attr_accessor :orientation

  def initialize(thickness: nil, orientation: [])
    raise ArgumentError, "You must set the orientation of the UPeg Lock Pockets" if orientation.empty?
    #this is set in the east/west orientation
    super(length_in_t: 3, width_in_t: 2, thickness: thickness, rows: 1, count: 1)
    @orientation = orientation
  end

  def draw!(bounding_origin: nil, part_length: nil, part_width: nil)

    half_width_part = part_width/2.0
    half_width_connector = width/2.0

    offset = 2 * thickness
    lines = []
    if orientation.include?(Sk::EAST_FACE) || orientation.include?(Sk::WEST_FACE)
      original_length_in_t = @length_in_t
      original_width_in_t = @width_in_t
      @length_in_t = original_width_in_t
      @width_in_t = original_length_in_t
      if orientation.include?(Sk::EAST_FACE)

        lines.concat(draw_pocket!(location: [bounding_origin.x + offset,
                                             bounding_origin.y - half_width_part + half_width_connector,
                                             bounding_origin.z]))

      end
      if orientation.include?(Sk::WEST_FACE)
        lines.concat(draw_pocket!(location: [bounding_origin.x + part_length - offset - (@width_in_t * thickness),
                                             bounding_origin.y - half_width_part + half_width_connector,
                                             bounding_origin.z]))
      end
      @length_in_t = original_length_in_t
      @width_in_t = original_width_in_t
    end
    if orientation.include?(Sk::SOUTH_FACE)
      lines.concat(draw_pocket!(location: [bounding_origin.x + half_width_part - half_width_connector,
                                           bounding_origin.y - offset,
                                           bounding_origin.z]))
    end

    if orientation.include?(Sk::NORTH_FACE)
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