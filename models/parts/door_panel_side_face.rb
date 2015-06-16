class WikiHouse::DoorPanelSideFace

  include WikiHouse::PartHelper
  include WikiHouse::BoardPartHelper


  def initialize(parent_part: nil, sheet: nil, group: nil, origin: nil, label: label)
    part_init(origin: origin, sheet: sheet, label: label, parent_part: parent_part)

    @length_method = :side_column_inner_length
    @width_method = :side_column_width

    init_board(right_connector: WikiHouse::NoneConnector.new(),
               top_connector: WikiHouse::SlotConnector.new(count: 1, thickness: thickness),
               bottom_connector: WikiHouse::SlotConnector.new(count: 1, thickness: thickness, length_in_t: 2),
               left_connector: WikiHouse::NoneConnector.new()

    )

  end
  def draw_non_groove_faces
    super
    connector = WikiHouse::PocketConnector.new(thickness: thickness,count: parent_part.number_of_side_column_supports )

    connector.draw!(bounding_origin: [origin.x , origin.y + (parent_part.length - length), origin.z], part_length: parent_part.length, part_width: width)

  end
  def build_right_side
    super

    #add tabs for the sides at unusual height

    first_point = @right_side_points.shift

    last_point = @right_side_points.shift
    connector = WikiHouse::SlotConnector.new(count: 2, thickness: thickness)
    slot_points = connector.points(bounding_start: bounding_c2,
                                  bounding_end: nil,
                                  start_pt: [first_point.x, first_point.y + parent_part.top_column_length, first_point.z],
                                  end_pt: last_point,
                                  orientation: :right,
                                  starting_thickness: 0,
                                  total_length: parent_part.length )


    slot_points.shift

    new_right_side = [first_point]
    new_right_side.concat(slot_points)
    @right_side_points = new_right_side
    return(@right_side_points)
  end
  def build_left_side
    super

    #add tabs for the sides at unusual height

    first_point = @left_side_points.first.clone
     last_point = @left_side_points.last.clone

    connector = WikiHouse::SlotConnector.new(count:2 , thickness: thickness)
    slot_points = connector.points(bounding_start: bounding_c4,
                                  bounding_end: nil,
                                  start_pt:  [first_point.x ,last_point.y + parent_part.top_column_length - parent_part.length, first_point.z] ,
                                  end_pt: nil,
                                  orientation: :left,
                                  starting_thickness: 0,
                                  total_length: parent_part.length )

    slot_points.shift


    new_left_side = [@left_side_points.first]
    new_left_side.concat(slot_points)
    @left_side_points = new_left_side
    return(@left_side_points)
  end
end