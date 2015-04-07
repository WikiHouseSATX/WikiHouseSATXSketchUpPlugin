class WikiHouse::WallPanel

  include WikiHouse::PartHelper

  def initialize(origin: nil, sheet: nil, label: nil, parent_part: nil)
    part_init(sheet: sheet, origin: origin, parent_part: parent_part)
    @origin = [@origin.x + 20, @origin.y + 60, @origin.z + 0]
    #@origin = [0,0,0]

    #has 2 caps, 4 faces, 6 ribs, 4 sides
    @top_cap = WikiHouse::WallPanelCap.new(label: "Top", origin: @origin, sheet: sheet, parent_part: self)
    @bottom_cap = WikiHouse::WallPanelCap.new(label: "Bottom", origin: @origin, sheet: sheet, parent_part: self)


    @left_outer_side = WikiHouse::WallPanelOuterSide.new(label: "Left Outer", origin: @origin, sheet: sheet, parent_part: self)
    @left_inner_side = WikiHouse::WallPanelInnerSide.new(label: "Left Inner", origin: @origin, sheet: sheet, parent_part: self)
    @right_outer_side = WikiHouse::WallPanelOuterSide.new(label: "Right Outer", origin: @origin, sheet: sheet, parent_part: self)
    @right_inner_side = WikiHouse::WallPanelInnerSide.new(label: "Right Inner", origin: @origin, sheet: sheet, parent_part: self)
    @left_face_front_panel = WikiHouse::WallPanelFace.new(label: "Left Front", origin: @origin, sheet: sheet, parent_part: self)
    @left_face_back_panel = WikiHouse::WallPanelFace.new(label: "Left Back", origin: @origin, sheet: sheet, parent_part: self)
    @right_face_front_panel = WikiHouse::WallPanelFace.new(label: "Right Front", origin: @origin, sheet: sheet, parent_part: self)
    @right_face_back_panel = WikiHouse::WallPanelFace.new(label: "Right Back", origin: @origin, sheet: sheet, parent_part: self)

    @left_ribs = []
    @left_ribs << WikiHouse::WallPanelRib.new(label: "Left Rib #1", origin: @origin, sheet: sheet, parent_part: self)
    @left_ribs << WikiHouse::WallPanelRib.new(label: "Left Rib #2", origin: @origin, sheet: sheet, parent_part: self)

    @left_ribs << WikiHouse::WallPanelRib.new(label: "Left Rib #3", origin: @origin, sheet: sheet, parent_part: self)

    @right_ribs = []
    @right_ribs << WikiHouse::WallPanelRib.new(label: "Right Rib #1", origin: @origin, sheet: sheet, parent_part: self)
    @right_ribs << WikiHouse::WallPanelRib.new(label: "Right Rib #2", origin: @origin, sheet: sheet, parent_part: self)

    @right_ribs << WikiHouse::WallPanelRib.new(label: "Right Rib #3", origin: @origin, sheet: sheet, parent_part: self)


  end

  def length
    80
  end

  def width
    80
  end

  def panel_rib_width
    40
  end

  def depth
    10
  end

  def number_of_internal_supports
    3
  end

  def number_of_face_tabs
    2
  end

  def draw!
    Sk.find_or_create_layer(name: self.class.name)
    Sk.make_layer_active_name(name: self.class.name)

    @top_cap.draw!
    @top_cap.rotate(vector: [0, 0, 1], rotation: -90.degrees).move_to(point: origin).
        move_by(x: (@top_cap.width - 2 * thickness) * -1,
                y: 0,
                z: length - @top_cap.thickness).
        go!
    @bottom_cap.draw!
    @bottom_cap.rotate(vector: [0, 0, 1], rotation: -90.degrees).move_to(point: origin).
        move_by(x: (@bottom_cap.width - 2 * thickness) * -1, y: 0, z: 0).
        go!

    @left_outer_side.draw!
    @left_outer_side.rotate(vector: [1, 0, 0], rotation: 90.degrees).
        rotate(vector: [0, 1, 0], rotation: 90.degrees).
        move_to(point: origin).
        move_by(x:0,
                y: 0,
                z: 0).
        go!
    @left_inner_side.draw!
    @left_inner_side.rotate(vector: [1, 0, 0], rotation: 90.degrees).
        rotate(vector: [0, 1, 0], rotation: 90.degrees).
        move_to(point: origin).
        move_by(x: 0,
                y: 0,
                z:  panel_rib_width - @left_inner_side.thickness).
        go!
    @right_inner_side.draw!
    @right_inner_side.rotate(vector: [1, 0, 0], rotation: 90.degrees).
        rotate(vector: [0, 1, 0], rotation: 90.degrees).
        move_to(point: origin).
        move_by(x: 0,
                y: 0,
                z:  panel_rib_width ).
        go!
    @right_outer_side.draw!
    @right_outer_side.rotate(vector: [1, 0, 0], rotation: 90.degrees).
        rotate(vector: [0, 1, 0], rotation: 90.degrees).
        move_to(point: origin).
        move_by(x: 0,
                y: 0,
                z:  panel_rib_width * 2 - @right_outer_side.thickness ).
        go!

    first_left_rib = @left_ribs.first
    if first_left_rib
      connector = first_left_rib.left_connector
      connector.class.drawing_points(bounding_origin: origin,
                                     count: @left_ribs.count,
                                     rows: 1,
                                     part_length: length,
                                     part_width: width,
                                     item_length: connector.length,
                                     item_width: connector.width) do |row, col, location|
        rib = @left_ribs[col]
        rib.draw!


        rib.rotate(vector: [0, 0, 1], rotation: 90.degrees).
            move_to(point: origin).
            move_by(x: rib.thickness * -1 ,
                    y:  panel_rib_width * -1,
                    z: -1 * location.y + Sk.abs(origin.y)).
            go!

      end
    end
    # first_right_rib = @right_ribs.first
    # if first_right_rib
    #   connector = first_right_rib.right_connector
    #   connector.class.drawing_points(bounding_origin: origin,
    #                                  count: @right_ribs.count,
    #                                  rows: 1,
    #                                  part_length: length,
    #                                  part_width: width,
    #                                  item_length: connector.length,
    #                                  item_width: connector.width) do |row, col, location|
    #     rib = @right_ribs[col]
    #     rib.draw!
    #     rib.rotate(vector: [0, 0, 1], rotation: 90.degrees).
    #         move_to(point: origin).
    #         rotate(vector: [1, 0, 0], rotation: 180.degrees).
    #         move_to(point: origin).
    #         move_by(x:  -1 * rib.thickness ,
    #                 y:  panel_rib_width,
    #                 z:  location.y + -1 * Sk.abs(origin.y) - rib.thickness).
    #         go!
    #
    #
    #
    #   end
    # end
    #@left_face_front_panel.draw!
    #
    # @left_face_front_panel.move_to!(point: origin).
    #     rotate(vector: [1, 0, 0], rotation: 90.degrees).
    #     move_by(x: -1 * @left_face_front_panel.width, y: 0, z: length + depth - @left_face_front_panel.thickness * 4).go!
    #
    # @left_face_back_panel.draw!
    # @left_face_back_panel.move_to!(point: origin).
    #     rotate(vector: [1, 0, 0], rotation: 90.degrees).
    #     move_by(x: -1 * @left_face_front_panel.width, y: 0, z: length - @left_face_front_panel.thickness * 3).go!
    #
    # @right_face_front_panel.draw!
    #
    # @right_face_front_panel.move_to!(point: origin).
    #     rotate(vector: [1, 0, 0], rotation: 90.degrees).
    #     move_by(x: 0, y: 0, z: length + depth - @right_face_front_panel.thickness * 4).go!
    #
    # @right_face_back_panel.draw!
    # @right_face_back_panel.move_to!(point: origin).
    #     rotate(vector: [1, 0, 0], rotation: 90.degrees).
    #     move_by(x: 0, y: 0, z: length - @right_face_front_panel.thickness * 3).go!
    #

    groups = @left_ribs.collect { |r| r.group }.concat(@right_ribs.collect { |r| r.group })
    groups.concat([@top_cap.group, @bottom_cap.group])
    groups.concat([@left_outer_side.group, @left_inner_side.group, @left_face_front_panel.group, @left_face_back_panel.group])
    groups.concat([@right_outer_side.group, @right_inner_side.group, @right_face_front_panel.group, @right_face_back_panel.group])

    set_group(groups.compact)
  end


end