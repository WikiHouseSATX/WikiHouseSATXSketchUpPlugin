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
                 top_connector: WikiHouse::NoneConnector.new(),
                 bottom_connector: WikiHouse::NoneConnector.new(),
                 left_connector: WikiHouse::NoneConnector.new(),
                 face_connector: WikiHouse::NoneConnector.new())
    end

  end
  include WikiHouse::AttributeHelper
  include WikiHouse::PartHelper

  def initialize(origin: nil, sheet: nil, label: nil, parent_part: nil)
    part_init(sheet: sheet, origin: origin, parent_part: parent_part)
    @front_board =  Board.new(label: "Front", origin: @origin, sheet: sheet, parent_part: self)
    @back_board =  Board.new(label: "Back", origin: @origin, sheet: sheet, parent_part: self)
    @top_board =  Board.new(label: "Top", origin: @origin, sheet: sheet, parent_part: self)
    @bottom_board =  Board.new(label: "Bottom", origin: @origin, sheet: sheet, parent_part: self)
    @left_board =  Board.new(label: "Left", origin: @origin, sheet: sheet, parent_part: self)
    @right_board =  Board.new(label: "Right", origin: @origin, sheet: sheet, parent_part: self)

  end
  def board_length
    36
  end
  def board_width
    12
  end
  def origin=(new_origin)
    @origin = new_origin
    @front_board.origin = new_origin
    @back_board.origin = new_origin
    @top_board.origin = new_origin
    @bottom_board.origin = new_origin
    @left_board.origin = new_origin
    @right_board.origin = new_origin

  end

  def draw!
    #Draw all of the parts with the correct orientation
    #Make the primary face a different color
    #modify the method to make it easy to rotate to that orientation
    #make something that can detect the orientation
    face_off = false
    Sk.find_or_create_layer(name: self.class.name)
    Sk.make_layer_active_name(name: self.class.name)

    @front_board.draw!

    @back_board.draw!

    @top_board.draw!

    @bottom_board.draw!

    @left_board.draw!

    @right_board.draw!

    groups = [@front_board.group, @back_board.group,
    @top_board.group, @bottom_board.group,
    @left_board.group, @right_board.group]


    set_group(groups.compact)
  end

end

