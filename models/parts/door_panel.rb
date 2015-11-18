class WikiHouse::DoorPanel


  include WikiHouse::PartHelper
  include WikiHouse::AttributeHelper
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
    value = 8
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
    face_off = false
    Sk.find_or_create_layer(name: self.class.name)
    Sk.make_layer_active_name(name: self.class.name)

    @top_cap.draw!
    @top_cap.rotate(vector: [0, 0, 1], rotation: -90.degrees).
        move_to(point: origin).
        move_by(x: 0,
                y: 0,
                z: length).go!

    @top_header.draw!
    @top_header.rotate(vector: [0, 0, 1], rotation: -90.degrees).
        move_to(point: origin).
        move_by(x: 0,
                y: 0,
                z: side_column_inner_length + thickness).
        go!


    @bottom_header.draw!
    @bottom_header.rotate(vector: [0, 0, 1], rotation: -90.degrees).
        move_to(point: origin).
        move_by(x: 0,
                y: 0,
                z: side_column_inner_length).
        go!

    first_rib = @top_ribs.first
    if first_rib
      connector = first_rib.left_connector
      connector.class.drawing_points(bounding_origin: origin,
                                     count: @top_ribs.count,
                                     rows: 1,
                                     part_length: width,
                                     part_width: depth,
                                     item_length: connector.length,
                                     item_width: connector.width) do |row, col, location|
        rib = @top_ribs[col]
        rib.draw!


        rib.rotate(vector: [0, 0, 1], rotation: 90.degrees).
            rotate(vector: [1, 0, 0], rotation: -90.degrees).
            move_to(point: origin).
            move_by(x: -1 * depth,
                    y: -1 * side_column_inner_length - top_column_length - thickness,
                    z: location.y + origin.y - rib.thickness).
            go!

      end
    end

    @left_outer_side.draw!
    @left_outer_side.rotate(vector: [0, 0, 1], rotation: 90.degrees).
        rotate(vector: [1, 0, 0], rotation: 90.degrees).
        move_to(point: origin).
        move_by(x: -1 * depth,
                y: thickness,
                z: 0).
        go!

    @left_inner_side.draw!

    @left_inner_side.rotate(vector: [0, 0, 1], rotation: 90.degrees).
        rotate(vector: [1, 0, 0], rotation: 90.degrees).
        move_to(point: origin).
        move_by(x: -1 * depth,
                y: thickness,
                z: side_column_width - thickness).
        go!
    @right_outer_side.draw!
    @right_outer_side.rotate(vector: [0, 0, 1], rotation: 90.degrees).
        rotate(vector: [1, 0, 0], rotation: 90.degrees).
        move_to(point: origin).
        move_by(x: -1 * depth,
                y: thickness,
                z: width - thickness).
        go!
    @right_inner_side.draw!
    @right_inner_side.rotate(vector: [0, 0, 1], rotation: 90.degrees).
        rotate(vector: [1, 0, 0], rotation: 90.degrees).
        move_to(point: origin).
        move_by(x: -1 * depth,
                y: thickness,
                z: width - side_column_width).
        go!


    @left_footer_bottom.draw!
    @left_footer_bottom.rotate(vector: [0, 0, 1], rotation: 0.degrees).
        move_to(point: origin).
        move_by(x: 0,
                y: -1 * depth,
                z: thickness).
        go!
    @left_footer_top.draw!
    @left_footer_top.rotate(vector: [0, 0, 1], rotation: 0.degrees).
        move_to(point: origin).
        move_by(x: 0,
                y: -1 * depth,
                z: thickness * 2).
        go!
    first_rib = @left_side_ribs.first
    if first_rib
      connector = first_rib.left_connector
      connector.class.drawing_points(bounding_origin: origin,
                                     count: @left_side_ribs.count,
                                     rows: 1,
                                     part_length: length,
                                     part_width: depth,
                                     item_length: connector.length,
                                     item_width: connector.width) do |row, col, location|
        rib = @left_side_ribs[col]
        rib.draw!


        rib.rotate(vector: [0, 0, 1], rotation: 0.degrees).
            move_to(point: origin).
            move_by(x: 0,
                    y: -1 * depth,

                    z: -1 * location.y - origin.y + rib.thickness).
            go!

      end
    end
    unless face_off
      @front_left_face.draw!
      @front_left_face.rotate(vector: [1, 0, 0], rotation: 90.degrees).
          move_to(point: origin).
          move_by(x: 0 * @front_left_face.thickness,
                  y: 1 * @front_left_face.thickness,
                  z: depth - @front_left_face.thickness).
          go!


      @back_left_face.draw!
      @back_left_face.rotate(vector: [1, 0, 0], rotation: 90.degrees).
          move_to(point: origin).
          move_by(x: 0 * @back_left_face.thickness,
                  y: 1 * @back_left_face.thickness,
                  z: 0).
          go!
    end
    @right_footer_bottom.draw!
    @right_footer_bottom.rotate(vector: [0, 0, 1], rotation: 180.degrees).
        move_to(point: origin).
        move_by(x: width * -1,
                y: 0,
                z: thickness).
        go!
    @right_footer_top.draw!
    @right_footer_top.rotate(vector: [0, 0, 1], rotation: 180.degrees).
        move_to(point: origin).
        move_by(x: width * -1,
                y: 0,
                z: thickness * 2).
        go!
    first_rib = @right_side_ribs.first
    if first_rib
      connector = first_rib.right_connector
      connector.class.drawing_points(bounding_origin: origin,
                                     count: @right_side_ribs.count,
                                     rows: 1,
                                     part_length: length,
                                     part_width: depth,
                                     item_length: connector.length,
                                     item_width: connector.width) do |row, col, location|
        rib = @right_side_ribs[col]
        rib.draw!


        rib.rotate(vector: [0, 0, 1], rotation: 180.degrees).
            move_to(point: origin).
            move_by(x: width * -1,
                    y: 0,
                    z: -1 * location.y - origin.y + rib.thickness).
            go!

      end
    end
    unless face_off
      @front_right_face.draw!
      @front_right_face.rotate(vector: [1, 0, 0], rotation: 90.degrees).
          move_to(point: origin).
          move_by(x: width - side_column_width,
                  y: 1 * @front_right_face.thickness,
                  z: depth - @front_right_face.thickness).
          go!

      @back_right_face.draw!
      @back_right_face.rotate(vector: [1, 0, 0], rotation: 90.degrees).
          move_to(point: origin).
          move_by(x: width - side_column_width,
                  y: 1 * @back_right_face.thickness,
                  z: 0).
          go!


      @front_top_face.draw!
      @front_top_face.rotate(vector: [1, 0, 0], rotation: 90.degrees).
          rotate(vector: [0, 0, 1], rotation: 90.degrees).
          move_to(point: origin).
          move_by(x: side_column_inner_length ,
                  y: -1 * width,
                  z: depth - thickness).
          go!


      @back_top_face.draw!
      @back_top_face.rotate(vector: [1, 0, 0], rotation: 90.degrees).
          rotate(vector: [0, 0, 1], rotation: 90.degrees).
          move_to(point: origin).
          move_by(x: side_column_inner_length ,
                  y: -1 * width,
                  z: 0).
          go!
    end
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