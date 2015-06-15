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
      @top_ribs << WikiHouse::DoorPanelTopRib.new(label: "Top Rib ##{i + 1}", origin: @origin, sheet: self.sheet, parent_part: self)
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
    @front_left_face = WikiHouse::DoorPanelSideFace.new(

        label: "Front Left Face",
        origin: @origin,
        sheet: self.sheet,
        parent_part: self
    )
    @back_left_face = WikiHouse::DoorPanelSideFace.new(

        label: "Back Left Face",
        origin: @origin,
        sheet: self.sheet,
        parent_part: self
    )
    @front_right_face = WikiHouse::DoorPanelSideFace.new(

        label: "Front Right Face",
        origin: @origin,
        sheet: self.sheet,
        parent_part: self
    )
    @back_right_face = WikiHouse::DoorPanelSideFace.new(

        label: "Back Right Face",
        origin: @origin,
        sheet: self.sheet,
        parent_part: self
    )
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

  def origin=(new_origin)
    @origin = new_origin

    @left_side_ribs.each { |rib| rib.origin = @origin }
    @right_side_ribs.each { |rib| rib.origin = @origin }
    @top_ribs.each { |rib| rib.origin = @origin }
    @left_footer_bottom.origin = @origin
    @left_footer_top.origin = @origin
    @left_outer_side.origin = @origin
    @left_inner_side.origin = @origin
    @front_left_face.origin = @origin
    @back_left_face.origin = @origin

    @right_footer_bottom.origin = @origin
    @right_footer_top.origin = @origin
    @right_outer_side.origin = @origin
    @right_inner_side.origin = @origin
    @front_right_face.origin = @origin
    @back_right_face.origin = @origin

    @top_cap.origin = @origin
    @top_header.origin = @origin
    @bottom_header.origin = @origin
    @front_top_face.origin = @origin
    @back_top_face.origin = @origin


  end


  def draw!
    Sk.find_or_create_layer(name: self.class.name)
    Sk.make_layer_active_name(name: self.class.name)

    @top_cap.draw!
    @top_cap.move_by(z:  240).go!

   @top_header.draw!
   @top_header.move_by(z:  250).go!


   @bottom_header.draw!
   @bottom_header.move_by(z:  260).go!

    @front_top_face.draw!
    @front_top_face.move_by(z:  270).go!

    @back_top_face.draw!
    @back_top_face.move_by(z: 280).go!

    @top_ribs.each_with_index { |rib, i| rib.draw!; rib.move_by(z: 90 + 10 * i).go! }


    @left_side_ribs.each_with_index { |rib, i| rib.draw!; rib.move_by(z: 20 + 10 * i).go! }
    @right_side_ribs.each_with_index { |rib, i| rib.draw!; rib.move_by(z: 60 + 10 * i).go! }
    @left_footer_bottom.draw!
    @left_footer_bottom.move_by(z:  120).go!

    @left_footer_top.draw!
    @left_footer_top.move_by(z:  130).go!

   @left_outer_side.draw!
   @left_outer_side.move_by(z:  140).go!

    @left_inner_side.draw!
    @left_inner_side.move_by(z:  150).go!

    @front_left_face.draw!
    @front_left_face.move_by(z:  160).go!


    @back_left_face.draw!
    @back_left_face.move_by(z:  170).go!


    @right_footer_bottom.draw!
    @right_footer_bottom.move_by(z:  180).go!

    @right_footer_top.draw!
    @right_footer_top.move_by(z:  190).go!

    @right_outer_side.draw!
    @right_outer_side.move_by(z:  200).go!

    @right_inner_side.draw!
    @right_inner_side.move_by(z:  210).go!

    @front_right_face.draw!
    @front_right_face.move_by(z:  220).go!

    @back_right_face.draw!
    @back_right_face.move_by(z:  230).go!



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

    groups = []

    @left_side_ribs.each { |rib| groups << rib.group }
    @right_side_ribs.each { |rib| groups << rib.group }
    @top_ribs.each { |rib| groups << rib.group }
    groups.concat([@left_footer_bottom.group,
                    @left_footer_top.group,
                    @left_outer_side.group,
                    @left_inner_side.group,
                    @front_left_face.group,
                    @back_left_face.group,

                    @right_footer_bottom.group,
                    @right_footer_top.group,
                    @right_outer_side.group,
                    @right_inner_side.group,
                    @front_right_face.group,
                    @back_right_face.group,

                    @top_cap.group,
                    @top_header.group,
                    @bottom_header.group,
                    @front_top_face.group,
                    @back_top_face.group])

    set_group(groups.compact)
  end


end