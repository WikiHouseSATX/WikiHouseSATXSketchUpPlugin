class WikiHouse::WallPanel

  include WikiHouse::PartHelper

  def initialize(origin: nil, sheet: nil, label: nil)
    part_init(sheet: sheet, origin: origin)
    #has 2 caps, 4 faces, 6 ribs, 4 sides
    @top_cap = WikiHouse::WallPanelCap.new(label: "Top", origin: @origin, sheet: sheet, panel: self)
    @bottom_cap = WikiHouse::WallPanelCap.new(label: "Bottom", origin: [@origin.x + 50, @origin.y, @origin.z], sheet: sheet, panel: self)


    @left_outer_side = WikiHouse::WallPanelOuterSide.new(label: "Left Outer", origin: @origin, sheet: sheet, panel: self)
    @left_inner_side = WikiHouse::WallPanelInnerSide.new(label: "Left Inner", origin: @origin, sheet: sheet, panel: self)
    @right_outer_side = WikiHouse::WallPanelOuterSide.new(label: "Right Outer", origin: @origin, sheet: sheet, panel: self)
    @right_inner_side = WikiHouse::WallPanelInnerSide.new(label: "Right Inner", origin: @origin, sheet: sheet, panel: self)
    @left_face_front_panel = WikiHouse::WallPanelFace.new(label: "Left Front", origin: @origin, sheet: sheet, panel: self)
    @left_face_back_panel = WikiHouse::WallPanelFace.new(label: "Left Back", origin: @origin, sheet: sheet, panel: self)
    @right_face_front_panel = WikiHouse::WallPanelFace.new(label: "Right Front", origin: @origin, sheet: sheet, panel: self)
    @right_face_back_panel = WikiHouse::WallPanelFace.new(label: "Right Back", origin: @origin, sheet: sheet, panel: self)

    @left_ribs = []
    @left_ribs << WikiHouse::WallPanelRib.new(label: "Left Rib #1", origin: @origin, sheet: sheet, panel: self)
    @left_ribs << WikiHouse::WallPanelRib.new(label: "Left Rib #2", origin: @origin, sheet: sheet, panel: self)

    @left_ribs << WikiHouse::WallPanelRib.new(label: "Left Rib #3", origin: @origin, sheet: sheet, panel: self)

    @right_ribs = []
    @right_ribs << WikiHouse::WallPanelRib.new(label: "Right Rib #1", origin: @origin, sheet: sheet, panel: self)
    @right_ribs << WikiHouse::WallPanelRib.new(label: "Right Rib #2", origin: @origin, sheet: sheet, panel: self)

    @right_ribs << WikiHouse::WallPanelRib.new(label: "Right Rib #3", origin: @origin, sheet: sheet, panel: self)


  end

  def panel_height
    80
  end

  def panel_width
    80
  end

  def panel_rib_width
    40
  end

  def panel_depth
    10
  end

  def tab_width
    5
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

    # @top_cap.draw!
    # @top_cap.move_to!(point: origin).
    #     move_by(x: origin.x, y: origin.y, z: origin.z + self.panel_height - @top_cap.thickness).
    #     rotate(vector: [0, 0, 1], rotation: -90.degrees).move_by(x: self.panel_height - @top_cap.thickness, y: 0, z: origin.z).go!
    #
    #
    # @bottom_cap.draw!
    # @bottom_cap.move_to!(point: origin).
    #     rotate(vector: [0, 0, 1], rotation: -90.degrees).move_by(x: self.panel_height - @bottom_cap.thickness, y: 0, z: origin.z).go!
    #
    # @left_outer_side.draw!
    # @left_outer_side.move_to!(point: origin).
    #     rotate(vector: [1, 0, 0], rotation: 90.degrees).rotate(vector: [0, 1, 0], rotation: 90.degrees).
    #     move_by(x: (-1 * self.panel_width) - @left_outer_side.width + (3 * @left_outer_side.thickness), y: 0, z: 0).go!
    # @left_inner_side.draw!
    # @left_inner_side.move_to!(point: origin).
    #     rotate(vector: [1, 0, 0], rotation: 90.degrees).rotate(vector: [0, 1, 0], rotation: 90.degrees).
    #     move_by(x: (-1 * self.panel_width) - @left_outer_side.width + (3 * @left_outer_side.thickness), y: 0, z: panel_rib_width - @left_inner_side.thickness).go!
    #
    # @right_inner_side.draw!
    # @right_inner_side.move_to!(point: origin).
    #     rotate(vector: [1, 0, 0], rotation: 90.degrees).rotate(vector: [0, 1, 0], rotation: 90.degrees).
    #     move_by(x: (-1 * self.panel_width) - @left_outer_side.width + (3 * @left_outer_side.thickness), y: 0, z: panel_rib_width).go!
    #
    # @right_outer_side.draw!
    # @right_outer_side.move_to!(point: origin).
    #     rotate(vector: [1, 0, 0], rotation: 90.degrees).rotate(vector: [0, 1, 0], rotation: 90.degrees).
    #     move_by(x: (-1 * self.panel_width) - @left_outer_side.width + (3 * @left_outer_side.thickness), y: 0, z: panel_width - @right_outer_side.thickness).go!
    #

    section_gap = Sk.round((@left_outer_side.length - (@left_outer_side.face_connector.count * @left_outer_side.face_connector.width))/(@left_outer_side.face_connector.count.to_f + 1.0))

    rib_count = @left_outer_side.face_connector.count
    @left_ribs.each_with_index do |rib, i|
      rib.draw!
break
      rib.move_to!(point: origin).
          move_by(x: origin.x, y: origin.y, z: origin.z + self.panel_height - rib.thickness).
          rotate(vector: [0, 0, 1], rotation: -90.degrees).move_by(x: self.panel_height - 2 * rib.thickness, y: 0, z: 0 - (((rib_count - i)) * section_gap) - ((rib_count - i - 1) * rib.thickness)).go!

    end
    # @right_ribs.each_with_index do |rib, i|
    #   rib.draw!
    #   rib.move_to!(point: origin).
    #       move_by(x: origin.x, y: origin.y, z: origin.z + self.panel_height - rib.thickness).
    #       rotate(vector: [0, 0, 1], rotation: -90.degrees).move_by(x: self.panel_height - 2 * rib.thickness, y: self.panel_rib_width, z: 0 - (((rib_count - i)) * section_gap) - ((rib_count - i - 1) * rib.thickness)).go!
    #
    # end
    # @left_face_front_panel.draw!
    # @left_face_front_panel.move_to!(point: origin).
    #     rotate(vector: [1, 0, 0], rotation: 90.degrees).
    #     move_by(x: 0, y: 0, z: panel_height + panel_depth - @left_face_front_panel.thickness  * 3).go!
    #
    # @left_face_back_panel.draw!
    # @left_face_back_panel.move_to!(point: origin).
    #     rotate(vector: [1, 0, 0], rotation: 90.degrees).
    #     move_by(x: 0, y: 0, z: panel_height - @left_face_front_panel.thickness  * 2).go!
    #
    # @right_face_back_panel.draw!
    # @right_face_back_panel.move_to!(point: origin).
    #     rotate(vector: [1, 0, 0], rotation: 90.degrees).
    #     move_by(x: panel_rib_width, y: 0, z: panel_height - @left_face_front_panel.thickness  * 2).go!
    #
    #
    #
    #
    # @right_face_front_panel.draw!
    # @right_face_front_panel.move_to!(point: origin).
    #     rotate(vector: [1, 0, 0], rotation: 90.degrees).
    #     move_by(x: panel_rib_width, y: 0, z: panel_height + panel_depth - @left_face_front_panel.thickness  * 3).go!
    #
    groups = @left_ribs.collect { |r| r.group }.concat(@right_ribs.collect { |r| r.group })
    groups.concat([@top_cap.group, @bottom_cap.group])
    groups.concat([@left_outer_side.group, @left_inner_side.group, @left_face_front_panel.group, @left_face_back_panel.group])
    groups.concat([@right_outer_side.group, @right_inner_side.group, @right_face_front_panel.group, @right_face_back_panel.group])

    set_group(groups.compact)
  end


end