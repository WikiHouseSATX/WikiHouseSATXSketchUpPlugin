class WikiHouse::DoorPanel


  include WikiHouse::PartHelper

  def initialize(origin: nil, sheet: nil, label: nil, parent_part: nil)
    part_init(sheet: sheet, origin: origin, parent_part: parent_part)
    #parts

    @left_footer_bottom = WikiHouse::DoorPanelRib.new(
        label: "Left Bottom Footer",
        origin: @origin,
        sheet: self.sheet,
        parent_part: self
    )
    @left_footer_top = WikiHouse::DoorPanelRib.new(
        label: "Left Top Footer",
        origin: @origin,
        sheet: self.sheet,
        parent_part: self
    )
    @left_outer_side = WikiHouse::DoorPanelOuterSide.new(
        label: "Left Outer Side",
        origin: @origin,
        sheet: self.sheet,
        parent_part: self
    )
    @left_inner_side = WikiHouse::DoorPanelInnerSide.new(
        label: "Left Inner Side",
        origin: @origin,
        sheet: self.sheet,
        parent_part: self
    )
    @right_footer_bottom = WikiHouse::DoorPanelRib.new(
        label: "Right Bottom Footer",
        origin: @origin,
        sheet: self.sheet,
        parent_part: self
    )
    @right_footer_top = WikiHouse::DoorPanelRib.new(
        label: "Right Top Footer",
        origin: @origin,
        sheet: self.sheet,
        parent_part: self
    )
    @right_outer_side = WikiHouse::DoorPanelOuterSide.new(
        label: "Right Outer Side",
        origin: @origin,
        sheet: self.sheet,
        parent_part: self
    )
    @right_inner_side = WikiHouse::DoorPanelInnerSide.new(
        label: "Right Inner Side",
        origin: @origin,
        sheet: self.sheet,
        parent_part: self
    )
    @left_side_ribs = []
    @right_side_ribs = []
    number_of_side_column_supports.times do |i|
      @left_side_ribs << WikiHouse::DoorPanelRib.new(label: "Left Side Rib ##{i + 1}", origin: @origin, sheet: self.sheet, parent_part: self)
      @right_side_ribs << WikiHouse::DoorPanelRib.new(label: "Right Side Rib ##{i + 1}", origin: @origin, sheet: self.sheet, parent_part: self)

    end
    @top_ribs = []
    number_of_top_column_supports.times do |i|
      @right_side_ribs << WikiHouse::DoorPanelTopRib.new(label: "Top Rib ##{i + 1}", origin: @origin, sheet: self.sheet, parent_part: self)
    end

    @top_cap = WikiHouse::DoorPanelTopCap.new(

        label: "Top Cap",
        origin: @origin,
        sheet: self.sheet,
        parent_part: self

    )
    @top_header = WikiHouse::DoorPanelTopHeader.new(

        label: "Header - Top",
        origin: @origin,
        sheet: self.sheet,
        parent_part: self
    )
    @bottom_header = WikiHouse::DoorPanelBottomHeader.new(

        label: "Header - Bottom",
        origin: @origin,
        sheet: self.sheet,
        parent_part: self
    )
    @front_top_face = WikiHouse::DoorPanelTopFace.new(

        label: "Front Top Face",
        origin: @origin,
        sheet: self.sheet,
        parent_part: self
    )
    @back_top_face = WikiHouse::DoorPanelTopFace.new(

        label: "Back Top Face",
        origin: @origin,
        sheet: self.sheet,
        parent_part: self
    )
    @front_left_side_face = WikiHouse::DoorPanel
  end

  def door_frame_width
    value = 34 #This can't be bigger than 40

    if sheet.length == 24
      value/4.0
    else
      value
    end
  end

  def door_frame_height
    value = 82

    if sheet.length == 24
      value/4.0
    else
      value
    end
  end

  def depth
    value = 10
    if sheet.length == 24
      value/4.0
    else
      value
    end

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

    value = 60 #gices you at least 10 even if door way if 40!
    if sheet.length == 24
      value/4.0
    else
      value
    end
  end

  def side_column_width
    (width - door_frame_width)/2.0
  end

  def side_column_depth
    depth
  end

  def side_column_inner_length
    door_frame_height + thickness
  end

  def top_column_length
    length - side_column_inner_length
  end


  def number_of_side_column_supports
    3
  end

  def number_of_top_column_supports
    3
  end
  #
  # def origin=(new_origin)
  #   @origin = new_origin
  #
  #   @ribs.each { |rib| rib.origin = @origin }
  #   @top_cap.origin = @origin
  #   @bottom_cap.origin = @origin
  #   @left_side.origin = @origin
  #   @right_side.origin = @origin
  #   @face_front_panel.origin = @origin
  #   @face_back_panel.origin = @origin
  # end
  #

  #
  # def width
  #   length/2.0
  #   # value = 94/2.0
  #   # if sheet.length == 24
  #   #   value/4.0
  #   # else
  #   #   value
  #   # end
  # end
  #
  # def panel_rib_width
  #   width
  # end
  #

  #
  # def number_of_internal_supports
  #   3
  # end
  #
  # def number_of_face_tabs
  #   2
  # end
  #
  # def draw!
  #   Sk.find_or_create_layer(name: self.class.name)
  #   Sk.make_layer_active_name(name: self.class.name)
  #
  #   @top_cap.draw!
  #   @top_cap.rotate(vector: [0, 0, 1], rotation: -90.degrees).move_to(point: origin).
  #       move_by(x: (@top_cap.width - thickness) * -1,
  #               y: 0,
  #               z: length - 2 * @top_cap.thickness).
  #       go!
  #   @bottom_cap.draw!
  #   @bottom_cap.rotate(vector: [0, 0, 1], rotation: -90.degrees).move_to(point: origin).
  #       move_by(x: (@bottom_cap.width - thickness) * -1,
  #               y: 0,
  #               z: -1 * @bottom_cap.thickness).
  #       go!
  #
  #   @left_side.draw!
  #   @left_side.rotate(vector: [1, 0, 0], rotation: 90.degrees).
  #       rotate(vector: [0, 1, 0], rotation: 90.degrees).
  #       move_to(point: origin).
  #       move_by(x: -1 * @left_side.thickness,
  #               y: -1 * @left_side.thickness,
  #               z: 0).
  #       go!
  #   @right_side.draw!
  #   @right_side.rotate(vector: [1, 0, 0], rotation: 90.degrees).
  #       rotate(vector: [0, 1, 0], rotation: 90.degrees).
  #       move_to(point: origin).
  #       move_by(x: -1 * @right_side.thickness,
  #               y: -1 * @right_side.thickness,
  #               z: panel_rib_width - @right_side.thickness).
  #       go!
  #
  #   first_rib = @ribs.first
  #   if first_rib
  #     connector = first_rib.left_connector
  #     connector.class.drawing_points(bounding_origin: origin,
  #                                    count: @ribs.count,
  #                                    rows: 1,
  #                                    part_length: length,
  #                                    part_width: width,
  #                                    item_length: connector.length,
  #                                    item_width: connector.width) do |row, col, location|
  #       rib = @ribs[col]
  #       rib.draw!
  #
  #
  #       rib.rotate(vector: [0, 0, 1], rotation: 90.degrees).
  #           move_to(point: origin).
  #           move_by(x: -1 * thickness,
  #                   y: panel_rib_width * -1,
  #                   z: -1 * location.y + origin.y - rib.thickness).
  #           go!
  #
  #     end
  #   end
  #   @face_front_panel.draw!
  #   @face_front_panel.rotate(vector: [1, 0, 0], rotation: 90.degrees).
  #       move_to(point: origin).
  #       move_by(x: 0,
  #               y: -1 * @face_front_panel.thickness,
  #               z: 0 * @face_front_panel.thickness).
  #       go!
  #
  #   @face_back_panel.draw!
  #   @face_back_panel.rotate(vector: [1, 0, 0], rotation: 90.degrees).
  #       move_to(point: origin).
  #       move_by(x: 0 * @face_back_panel.thickness,
  #               y: -1 * @face_back_panel.thickness,
  #               z: -1 * depth + @face_back_panel.thickness).
  #       go!
  #
  #   groups = @ribs.collect { |r| r.group }
  #   groups.concat([@top_cap.group, @bottom_cap.group])
  #   groups.concat([@left_side.group, @right_side.group, @face_front_panel.group, @face_back_panel.group])
  #
  #
  #   set_group(groups.compact)
  # end


end