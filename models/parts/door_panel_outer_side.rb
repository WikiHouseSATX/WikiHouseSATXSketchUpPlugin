class WikiHouse::DoorPanelOuterSide < WikiHouse::WallPanelOuterSide


  def initialize(parent_part: nil, sheet: nil, group: nil, origin: nil, label: label)
    part_init(origin: origin, sheet: sheet, label: label, parent_part: parent_part)

    @length_method = :length
    @width_method = :depth
    init_board(right_connector: WikiHouse::TabConnector.new(count: 2, thickness: thickness),
               top_connector: WikiHouse::SlotConnector.new(count: 1, thickness: thickness),
               bottom_connector: WikiHouse::SlotConnector.new(count: 1, thickness: thickness, length_in_t: 2),
               left_connector: WikiHouse::TabConnector.new(count: 2, thickness: thickness),
               face_connector: [
                   WikiHouse::UPegPassThruConnector.new(thickness: thickness, count: parent_part.number_of_side_column_supports),
                   WikiHouse::UPegEndPassThruConnector.new(thickness: thickness),
                   WikiHouse::PocketConnector.new(count: parent_part.number_of_side_column_supports)]
    )

  end

  def build_left_side
    super
    #add a tab at the top for the top section
    last_point = @left_side_points.pop

    connector = WikiHouse::TabConnector.new(count: 1, thickness: thickness)
    tab_points = connector.points(bounding_start: bounding_c4,
                                  bounding_end: nil,
                                  start_pt: [last_point.x, last_point.y - parent_part.top_column_length, last_point.z],
                                  end_pt: last_point,
                                  orientation: :left,
                                  starting_thickness: 0,
                                  total_length: parent_part.top_column_length)


    # tab_points.shift
    new_left_side = []
    new_left_side.concat(@left_side_points)
    new_left_side.concat(tab_points)
   # new_left_side << last_point
    #new_left_side.concat(tab_points)

    @left_side_points = new_left_side
    return(@left_side_points)
  end

  def build_right_side
    super

    #add a tab at the top for the top section
    first_point = @right_side_points.shift
    connector = WikiHouse::TabConnector.new(count: 1, thickness: thickness)
    tab_points = connector.points(bounding_start: bounding_c2,
                                  bounding_end: nil,
                                  start_pt: first_point,
                                  end_pt: [first_point.x, first_point.y - parent_part.top_column_length, first_point.z],
                                  orientation: :right,
                                  starting_thickness: 0,
                                  total_length: parent_part.top_column_length)


    tab_points.shift

    new_right_side = [first_point]
    new_right_side.concat(tab_points)
    new_right_side.concat(@right_side_points)
    @right_side_points = new_right_side
    return(@right_side_points)
  end

  def draw_non_groove_faces
    super
    connector = WikiHouse::PocketConnector.new(length_in_t: 2, thickness: thickness, count: 1)

    connector.draw!(bounding_origin: [origin.x, origin.y, origin.z], part_length: parent_part.top_column_length * 2, part_width: width)

  end

end