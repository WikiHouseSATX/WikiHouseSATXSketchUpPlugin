class WikiHouse::RotationLab
  class Board
    include WikiHouse::PartHelper
    include WikiHouse::BoardPartHelper
    include WikiHouse::AttributeHelper

    def initialize(parent_part: nil, sheet: nil, group: nil, origin: nil, label: label)
      part_init(origin: origin, sheet: sheet, label: label, parent_part: parent_part)

      @length_method = :board_length
      @width_method = :board_width
      init_board(right_connector: WikiHouse::NoneConnector.new(),
                 top_connector: WikiHouse::NotchConnector.new(),
                 bottom_connector: WikiHouse::NoneConnector.new(),
                 left_connector: WikiHouse::NoneConnector.new(),
                 face_connector: WikiHouse::NoneConnector.new())
    end

    def draw_primary_face(lines)
      face = Sk.add_face(lines)
      draw_non_groove_faces

      set_material(face)
      make_part_right_thickness(face)

      face.material = sheet.active_material
      face
    end

  end
  include WikiHouse::AttributeHelper
  include WikiHouse::PartHelper

  def initialize(origin: nil, sheet: nil, label: nil, parent_part: nil)
    part_init(sheet: sheet, origin: origin, parent_part: parent_part)
    @lfront_board = Board.new(label: "Length Front", origin: @origin, sheet: sheet, parent_part: self)
    @lback_board = Board.new(label: "Length Back", origin: @origin, sheet: sheet, parent_part: self)
    @ltop_board = Board.new(label: "Length Top", origin: @origin, sheet: sheet, parent_part: self)
    @lbottom_board = Board.new(label: "Length Bottom", origin: @origin, sheet: sheet, parent_part: self)
    @lleft_board = Board.new(label: "Length Left", origin: @origin, sheet: sheet, parent_part: self)
    @lright_board = Board.new(label: "Length Right", origin: @origin, sheet: sheet, parent_part: self)

    @wfront_board = Board.new(label: "Width Front", origin: @origin, sheet: sheet, parent_part: self)
    @wback_board = Board.new(label: "Width Back", origin: @origin, sheet: sheet, parent_part: self)
    @wtop_board = Board.new(label: "Width Top", origin: @origin, sheet: sheet, parent_part: self)
    @wbottom_board = Board.new(label: "Width Bottom", origin: @origin, sheet: sheet, parent_part: self)
    @wleft_board = Board.new(label: "Width Left", origin: @origin, sheet: sheet, parent_part: self)
    @wright_board = Board.new(label: "Width Right", origin: @origin, sheet: sheet, parent_part: self)


  end

  def board_length
    36
  end

  def board_width
    12
  end

  def origin=(new_origin)
    @origin = new_origin
    @lfront_board.origin = new_origin
    @lback_board.origin = new_origin
    @lbottom_board.origin = new_origin
    @lleft_board.origin = new_origin
    @lright_board.origin = new_origin

    @wfront_board.origin = new_origin
    @wback_board.origin = new_origin
    @wtop_board.origin = new_origin
    @wbottom_board.origin = new_origin
    @wleft_board.origin = new_origin
    @wright_board.origin = new_origin


  end

  def draw!

    #make something that can detect the orientation
    #Fix it so that you can rotate it to face front and then face top and have it draw it correctly.
    face_off = false
    Sk.find_or_create_layer(name: self.class.name)
    Sk.make_layer_active_name(name: self.class.name)


    @lfront_board.draw!

    @lfront_board.face_front_long!

    bottom_plane = Geom.fit_plane_to_points( [0,0,0], [10,10,0], [0,10,0] )

    loop = @lfront_board.primary_face.outer_loop
    gloop1= Sk.convert_to_global_position(loop)
    part_plane = Geom.fit_plane_to_points(*gloop1)
    line = Geom.intersect_plane_plane(bottom_plane, part_plane)
    puts line
    @lleft_board.draw!

    @lleft_board.face_left_long!

    bottom_plane = Geom.fit_plane_to_points( [0,0,0], [10,10,0], [0,10,0] )

    loop = @lleft_board.primary_face.outer_loop
    gloop1= Sk.convert_to_global_position(loop)
    part_plane = Geom.fit_plane_to_points(*gloop1)
    line = Geom.intersect_plane_plane(bottom_plane, part_plane)
    puts line
    #
    # @wfront_board.draw!
    # @wfront_board.face_front_wide!
    #
    # @lback_board.draw!
    # @lback_board.face_back_long!
    # @wback_board.draw!
    # @wback_board.face_back_wide!
    #
    # @ltop_board.draw!
    # @ltop_board.face_top_long!
    # @wtop_board.draw!
    # @wtop_board.face_top_wide!
    #
    # @lbottom_board.draw!
    # @lbottom_board.face_bottom_long!
    # @wbottom_board.draw!
    # @wbottom_board.face_bottom_wide!
    #
    # @lleft_board.draw!
    # @lleft_board.face_left_long!
    # @wleft_board.draw!
    # @wleft_board.face_left_wide!
    #
    # @lright_board.draw!
    # @lright_board.face_right_long!
    # @wright_board.draw!
    # @wright_board.face_right_wide!

    groups = [@lfront_board.group, @lback_board.group,
              @ltop_board.group, @lbottom_board.group,
              @lleft_board.group, @lright_board.group,
              @wfront_board.group, @wback_board.group,
              @wtop_board.group, @wbottom_board.group,
              @wleft_board.group, @wright_board.group]


    set_group(groups.compact)
  end

end

