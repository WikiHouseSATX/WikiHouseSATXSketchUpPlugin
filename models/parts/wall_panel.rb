class WikiHouse::WallPanel

  include WikiHouse::PartHelper

  def initialize(origin: nil, sheet: nil, label: nil, parent_part: nil)
    part_init(sheet: sheet, origin: origin, parent_part: parent_part)

    #has 2 caps, 2 faces, 3 ribs, 2 sides
    @top_cap = WikiHouse::WallPanelCap.new(label: "Top", origin: @origin, sheet: sheet, parent_part: self)
    @bottom_cap = WikiHouse::WallPanelCap.new(label: "Bottom", origin: @origin, sheet: sheet, parent_part: self)


    @left_side = WikiHouse::WallPanelOuterSide.new(label: "Left Outer", origin: @origin, sheet: sheet, parent_part: self)
    # @left_side.activate_part!
    @right_side = WikiHouse::WallPanelOuterSide.new(label: "Right Outer", origin: @origin, sheet: sheet, parent_part: self)
    @face_front_panel = WikiHouse::WallPanelFace.new(label: "Left Front", origin: @origin, sheet: sheet, parent_part: self)
    @face_back_panel = WikiHouse::WallPanelFace.new(label: "Left Back", origin: @origin, sheet: sheet, parent_part: self)

    @ribs = []
    @ribs << WikiHouse::WallPanelRib.new(label: "Rib #1", origin: @origin, sheet: sheet, parent_part: self)
    @ribs << WikiHouse::WallPanelRib.new(label: "Rib #2", origin: @origin, sheet: sheet, parent_part: self)

    @ribs << WikiHouse::WallPanelRib.new(label: "Rib #3", origin: @origin, sheet: sheet, parent_part: self)
  end

  def origin=(new_origin)
    @origin = new_origin

    @ribs.each { |rib| rib.origin = @origin }
    @top_cap.origin = @origin
    @bottom_cap.origin = @origin
    @left_side.origin = @origin
    @right_side.origin = @origin
    @face_front_panel.origin = @origin
    @face_back_panel.origin = @origin
  end

  def length
    value = 94

    if sheet.length == 24
      value/4.0
    else
      value
    end
  end

  def width
    value = 46
    if sheet.length == 24
      value/4.0
    else
      value
    end
  end

  def panel_rib_width
    width
  end

  def depth
    value = 10
    if sheet.width == 12
      value/4.0
    else
      value
    end

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
        move_by(x: (@top_cap.width - thickness) * -1,
                y: 0,
                z: length - 2 * @top_cap.thickness).
        go!
    @bottom_cap.draw!
    @bottom_cap.rotate(vector: [0, 0, 1], rotation: -90.degrees).move_to(point: origin).
        move_by(x: (@bottom_cap.width - thickness) * -1,
                y: 0,
                z: -1 * @bottom_cap.thickness).
        go!

    @left_side.draw!
    @left_side.rotate(vector: [1, 0, 0], rotation: 90.degrees).
        rotate(vector: [0, 1, 0], rotation: 90.degrees).
        move_to(point: origin).
        move_by(x: @left_side.thickness,
                y: -1 * @left_side.thickness,
                z: 0).
        go!
    @right_side.draw!
    @right_side.rotate(vector: [1, 0, 0], rotation: 90.degrees).
        rotate(vector: [0, 1, 0], rotation: 90.degrees).
        move_to(point: origin).
        move_by(x: @right_side.thickness,
                y: -1 * @right_side.thickness,
                z: panel_rib_width  - @right_side.thickness).
        go!

    first_rib = @ribs.first
    if first_rib
      connector = first_rib.left_connector
      connector.class.drawing_points(bounding_origin: origin,
                                     count: @ribs.count,
                                     rows: 1,
                                     part_length: length,
                                     part_width: width,
                                     item_length: connector.length,
                                     item_width: connector.width) do |row, col, location|
        rib = @ribs[col]
        rib.draw!


        rib.rotate(vector: [0, 0, 1], rotation: 90.degrees).
            move_to(point: origin).
            move_by(x: 0,
                    y: panel_rib_width * -1,
                    z: -1 * location.y + origin.y - rib.thickness).
            go!

      end
    end
    @face_front_panel.draw!
    @face_front_panel.rotate(vector: [1, 0, 0], rotation: 90.degrees).
        move_to(point: origin).
        move_by(x: 0,
                y: -1 * @face_front_panel.thickness,
                z: - 1 * @face_front_panel.thickness).
        go!

    @face_back_panel.draw!
    @face_back_panel.rotate(vector: [1, 0, 0], rotation: 90.degrees).
        move_to(point: origin).
        move_by(x: 0,
                y: -1 * @face_back_panel.thickness,
                z: -1 * depth).
        go!

    groups = @ribs.collect { |r| r.group }
    groups.concat([@top_cap.group, @bottom_cap.group])
    groups.concat([@left_side.group, @right_side.group, @face_front_panel.group, @face_back_panel.group])


    set_group(groups.compact)
  end


end