class WikiHouse::DoorPanelInnerSide

  include WikiHouse::PartHelper
  include WikiHouse::BoardPartHelper


  def initialize(parent_part: nil, sheet: nil, group: nil, origin: nil, label: label)
    part_init(origin: origin, sheet: sheet, label: label, parent_part: parent_part)

    @length_method = :side_column_inner_length
    @width_method = :side_column_depth

    init_board(right_connector: WikiHouse::NoneConnector.new(),
               top_connector: WikiHouse::TabConnector.new(count: 1, thickness: thickness),
               bottom_connector: WikiHouse::SlotConnector.new(count: 1, thickness: thickness, length_in_t: 2),
               left_connector: WikiHouse::NoneConnector.new()
    )

  end

  def draw_non_groove_faces
    super
    connector = WikiHouse::PocketConnector.new(thickness: thickness, count: parent_part.number_of_side_column_supports)

    connector.draw!(bounding_origin: [origin.x, origin.y + (parent_part.length - length), origin.z], part_length: parent_part.length, part_width: width)

  end

  def build_right_side
    super

    #add a tab at the top for the top section
    first_point = @right_side_points.shift
    last_point = @right_side_points.shift
    connector = WikiHouse::TabConnector.new(count: 2, thickness: thickness)
    tab_points = connector.points(bounding_start: bounding_c2,
                                  bounding_end: nil,
                                  start_pt: [first_point.x, first_point.y + parent_part.top_column_length + thickness, first_point.z],
                                  end_pt: last_point,
                                  orientation: :right,
                                  starting_thickness: 0,
                                  total_length: parent_part.length)


    tab_points.shift

    new_right_side = [[first_point.x - thickness, first_point.y, first_point.z]]
    new_right_side.concat(tab_points)
    @right_side_points = new_right_side
    return(@right_side_points)
  end

  def build_left_side
    super
    #
    #   #add a tab at the top for the top section
    first_point = @left_side_points.first.clone
    last_point = @left_side_points.last.clone

    connector = WikiHouse::TabConnector.new(count: 2, thickness: thickness)

    tab_points = connector.points(bounding_start: bounding_c4,
                                  bounding_end: nil,
                                  start_pt: [first_point.x, last_point.y + parent_part.top_column_length - parent_part.length + thickness, first_point.z],
                                  end_pt: last_point,
                                  orientation: :left,
                                  starting_thickness: 0,
                                  total_length: parent_part.length)

    tab_points.shift


    new_left_side = [[@left_side_points.first.x + thickness,
                      @left_side_points.first.y,
                      @left_side_points.first.z]]
    new_left_side.concat(tab_points)
   # new_left_side << last_point

    @left_side_points = new_left_side
    return(@left_side_points)
  end
  def calculate_starting_thickness(connector: connector)
    starting_thickness = 0

    if top?(connector)
      starting_thickness = thickness
    elsif bottom?(connector)
      starting_thickness = thickness
    elsif right?(connector)
      starting_thickness = 0
    elsif left?(connector)
      starting_thickness = 0

    end

    starting_thickness
  end
end