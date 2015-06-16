class WikiHouse::DoorPanelTopFace

  include WikiHouse::PartHelper
  include WikiHouse::BoardPartHelper


  def initialize(parent_part: nil, sheet: nil, group: nil, origin: nil, label: label)
    part_init(origin: origin, sheet: sheet, label: label, parent_part: parent_part)

    @length_method = :width
    @width_method = :top_column_length

    init_board(right_connector: WikiHouse::SlotConnector.new(count: 2, thickness: thickness),
               top_connector: WikiHouse::SlotConnector.new(count: 1, thickness: thickness),
               bottom_connector: WikiHouse::SlotConnector.new(count: 1, thickness: thickness),
               left_connector: WikiHouse::NoneConnector.new(), #WikiHouse::SlotConnector.new(count: 2, thickness: thickness),
               face_connector: [WikiHouse::PocketConnector.new(thickness: thickness, count: parent_part.number_of_top_column_supports)]
    )

  end

  def build_left_side
    super

    c1 = [@left_side_points[0].x, @left_side_points[0].y + parent_part.side_column_width, @left_side_points[0].z]
    c2 = [@left_side_points[0].x - thickness, @left_side_points[0].y + parent_part.side_column_width, @left_side_points[0].z]
    c3 = [c2.x, c1.y + parent_part.door_frame_width, @left_side_points[0].z]
    c4 = [c1.x, c1.y + parent_part.door_frame_width, @left_side_points[0].z]


    tab_points = [@left_side_points[0],c1,c2,c3,c4, @left_side_points.last]
    WikiHouse::Fillet.by_points(tab_points,2,1,0, reverse_it: true)

    WikiHouse::Fillet.by_points(tab_points,5,6,7)
    #add on some points to handle the extra header lip

    @left_side_points = tab_points


  end

  def draw_non_groove_faces
    super
    connector = WikiHouse::PocketConnector.new(length_in_t: WikiHouse::Connector.standard_width_in_t, width_in_t:1, thickness: thickness, count: 2)

    connector.draw!(bounding_origin: [bounding_c1.x, origin.y, origin.z], part_length: length, part_width: 1 * thickness)

  end
end