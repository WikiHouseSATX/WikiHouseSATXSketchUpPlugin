class WikiHouse::ChrisDesk

#this connector is used when you need to remove a constant thickness from an edge
  class WikiHouse::HookConnector < WikiHouse::Connector
    attr_reader :rows

    def initialize(length_in_t: nil, count: 2, width_in_t: nil, thickness: nil)
      count = 2
      @count = 2
      super
      @count = 2
    end

    def count
      2
    end

    def hook?
      true
    end

    def name
      :hook
    end

    def points(bounding_start: nil,
               bounding_end: nil,
               start_pt: nil,
               end_pt: nil,
               orientation: nil,
               starting_thickness: nil,
               total_length: nil)
      c5 = start_pt
      c6 = end_pt
      if orientation == :right


        #First Hook

        h1p1 = [c5.x, c5.y, c5.z]
        h1p2 = [c5.x, c5.y - width, c5.z]
        h1p3 = [c5.x - length, c5.y - width, c5.z]


        #seond hook

        h2p1 = [c6.x - length, c6.y + width, c6.z]
        h2p2 = [c6.x, c6.y + width, c6.z]
        h2p3 = [c6.x, c6.y, c6.z]
        h2p4 = [c6.x - length, c6.y, c6.z]
        points = [h1p1, h1p2, h1p3, h2p1, h2p2, h2p3]
        WikiHouse::DogBoneFillet.by_points(points, 1, 2, 3, reverse_it: false)

        WikiHouse::DogBoneFillet.by_points(points, 6, 5, 4, reverse_it: true)


      else
        raise ArgumentError, "#{orientation} is not supported by this connector"
      end
      return(points)
    end

  end
  class BackCrossBarPocketConnector < WikiHouse::PocketConnector

    #this is serious cheating
    def initialize(cross_bar: nil, desk: nil, thickness: nil)

      super(length_in_t: 1, count: 1, width_in_t: 1, thickness: thickness)

      @cross_bar = cross_bar
      @desk = desk

    end

    def draw!(bounding_origin: nil, part_length: nil, part_width: nil)
      pockets = []
      #Front Cross Bar Pockets

   
      @width_in_t = 2
      @length_in_t = 1
      offset_top = (@desk.middle_left_cross_bar.width - 2 * @desk.thickness * @desk.tab_depth_percent)/2.0
      # Left Leg Pockets
      puts @desk.middle_left_cross_bar_offset
      puts @desk.middle_right_cross_bar_offset
      pockets << draw_pocket!(location: [@cross_bar.origin.x + offset_top ,
                                         @cross_bar.origin.y - @desk.middle_left_cross_bar_offset  ,
                                         @cross_bar.origin.z])


      pockets << draw_pocket!(location: [@cross_bar.origin.x + offset_top,
                                         @cross_bar.origin.y  - @desk.middle_right_cross_bar_offset,
                                         @cross_bar.origin.z])


      pockets
    end


  end
  class TopPocketConnector < WikiHouse::PocketConnector

    #this is serious cheating
    def initialize(desktop: nil, desk: nil, thickness: nil)

      super(length_in_t: 1, count: 1, width_in_t: 1, thickness: thickness)

      @desktop = desktop
      @desk = desk

    end

    def draw!(bounding_origin: nil, part_length: nil, part_width: nil)
      pockets = []
      #Front Cross Bar Pockets

      @width_in_t = 1
      @length_in_t = 3

      self.class.drawing_points(bounding_origin: [@desktop.origin.x + @desk.front_cross_bar_offset,
                                                  @desktop.origin.y - @desk.side_leg_offset - thickness * (1 - @desk.tab_depth_percent),
                                                  @desktop.origin.z],
                                count: @desk.front_cross_bar.number_of_tabs,
                                rows: 1,
                                part_length: @desk.front_cross_bar.length,
                                part_width: @desk.front_cross_bar.width,
                                item_length: length,
                                item_width: 0) do |row, col, location|
        pockets << draw_pocket!(location: [@desktop.origin.x + @desk.front_cross_bar_offset,
                                           location.y,
                                           location.z])
      end
      #Back Cross Bar Pockets

      self.class.drawing_points(bounding_origin: [@desktop.origin.x + @desktop.width - @desk.back_cross_bar_offset - thickness,
                                                  @desktop.origin.y - @desk.side_leg_offset - thickness * (1 - @desk.tab_depth_percent),
                                                  @desktop.origin.z],
                                count: @desk.front_cross_bar.number_of_tabs,
                                rows: 1,
                                part_length: @desk.front_cross_bar.length,
                                part_width: @desk.front_cross_bar.width,
                                item_length: length,
                                item_width: 0) do |row, col, location|
        pockets << draw_pocket!(location: [@desktop.origin.x + @desktop.width - @desk.back_cross_bar_offset - thickness,
                                           location.y,
                                           location.z])
      end


      @width_in_t = @desk.right_outer_leg.top_tab_width_in_t
      @length_in_t = 2
      # Left Leg Pockets
      pockets << draw_pocket!(location: [@desktop.origin.x + @desk.front_leg_offset + @desk.right_outer_leg.top_tab_offset,
                                         @desktop.origin.y - @desk.side_leg_offset,
                                         @desktop.origin.z])


      # Right Leg Pockets

      pockets << draw_pocket!(location: [@desktop.origin.x + @desk.front_leg_offset + @desk.right_outer_leg.top_tab_offset,
                                         @desktop.origin.y - @desktop.length + 2 * thickness + @desk.side_leg_offset,
                                         @desktop.origin.z])

      @width_in_t = 3
      @length_in_t = 1

      pockets << draw_pocket!(location: [@desktop.origin.x + @desk.front_cross_bar_offset + @desk.middle_right_cross_bar.length/2.0 - (@width_in_t * thickness)/2.0,
                                         @desktop.origin.y - @desktop.length +  thickness + @desk.side_leg_offset + @desk.middle_right_cross_bar_offset,
                                         @desktop.origin.z])
      pockets << draw_pocket!(location: [@desktop.origin.x + @desk.front_cross_bar_offset +   @desk.middle_left_cross_bar.length/2.0 - (@width_in_t * thickness)/2.0,
                                         @desktop.origin.y - @desktop.length +  thickness + @desk.side_leg_offset + @desk.middle_left_cross_bar_offset,
                                         @desktop.origin.z])
      # half_width_part = part_width/2.0
      # half_width_connector = width/2.0
      #
      # offset = 2 * thickness
      #
      # return draw_pocket!(location: [bounding_origin.x + half_width_part - half_width_connector,
      #                                bounding_origin.y - part_length + offset,
      #                                bounding_origin.z])
      pockets
    end


  end
  class Desktop
    include WikiHouse::PartHelper
    include WikiHouse::BoardPartHelper
    include WikiHouse::AttributeHelper

    def initialize(parent_part: nil, sheet: nil, group: nil, origin: nil, label: label)
      part_init(origin: origin, sheet: sheet, label: label, parent_part: parent_part)

      @length_method = :width
      @width_method = :depth
      init_board(right_connector: WikiHouse::NoneConnector.new(),
                 top_connector: WikiHouse::NoneConnector.new(),
                 bottom_connector: WikiHouse::NoneConnector.new(),
                 left_connector: WikiHouse::NoneConnector.new(),
                 face_connector: TopPocketConnector.new(desktop: self, desk: parent_part))
    end

    def corner_radius
      value = 0.5
      sheet.length == 24 ? value/4.0 : value
    end

    def draw_edges!
      build_points


      pts = points

      top_left_corner = pts[0]
      top_right_corner = pts[1]
      bottom_right_corner = pts[2]
      bottom_left_corner = pts[3]
      corners = []

      pre_point = [top_left_corner.x, top_left_corner.y - corner_radius, top_left_corner.z]
      post_point = [top_left_corner.x + corner_radius, top_left_corner.y, top_left_corner.z]
      center_point = [post_point.x, pre_point.y, top_left_corner.z]
     

      corners[0] = Sk.draw_arc(center_point: center_point,
                        zero_vector: [0, 1, 0],
                        normal: [0, 0, 1],
                        radius: corner_radius,
                        start_angle: 0,
                        end_angle: 90.degrees)

      pre_point = [top_right_corner.x - corner_radius, top_right_corner.y , top_right_corner.z]
      post_point = [top_right_corner.x, top_right_corner.y - corner_radius, top_right_corner.z]
      center_point = [pre_point.x, post_point.y, top_right_corner.z]
    

      corners[1] = Sk.draw_arc(center_point: center_point,
                               zero_vector: [0, 1, 0],
                               normal: [0, 0, 1],
                               radius: corner_radius,
                               start_angle:0,
                               end_angle: -90.degrees)



      pre_point = [bottom_right_corner.x , bottom_right_corner.y + corner_radius , bottom_right_corner.z]
      post_point = [bottom_right_corner.x - corner_radius, bottom_right_corner.y , bottom_right_corner.z]
      center_point = [post_point.x, pre_point.y, bottom_right_corner.z]
    

      corners[2] = Sk.draw_arc(center_point: center_point,
                               zero_vector: [0, 1, 0],
                               normal: [0, 0, 1],
                               radius: corner_radius,
                               start_angle:180.degrees,
                               end_angle: 270.degrees)

      pre_point = [bottom_left_corner.x + corner_radius , bottom_left_corner.y  , bottom_left_corner.z]
      post_point = [bottom_left_corner.x , bottom_left_corner.y + corner_radius , bottom_left_corner.z]
      center_point = [pre_point.x, post_point.y, bottom_left_corner.z]
   

      corners[3] = Sk.draw_arc(center_point: center_point,
                               zero_vector: [0, 1, 0],
                               normal: [0, 0, 1],
                               radius: corner_radius,
                               start_angle:90.degrees,
                               end_angle: 180.degrees)
      lines = []
      corners[0].each { |c| lines << c}
      lines << Sk.draw_line(corners[0].first.start.position, corners[1].first.start.position)

      corners[1].each { |c| lines << c}
      lines << Sk.draw_line(corners[1].last.end.position, corners[2].last.end.position)
      corners[2].each { |c| lines << c}
     lines << Sk.draw_line(corners[2].first.start.position, corners[3].last.end.position)
     corners[3].each { |c| lines << c}
     lines << Sk.draw_line(corners[3].first.start.position, corners[0].last.end.position)

     lines

    end

  end
  class FrontCrossBar
    #This isn't parametric yet
    include WikiHouse::PartHelper
    include WikiHouse::BoardPartHelper
    include WikiHouse::AttributeHelper

    attr_reader :number_of_tabs

    def initialize(parent_part: nil, sheet: nil, group: nil, origin: nil, label: label)
      part_init(origin: origin, sheet: sheet, label: label, parent_part: parent_part)

      @number_of_tabs = 3
      init_board(left_connector: WikiHouse::TabConnector.new(count: @number_of_tabs, thickness: thickness, width_in_t: 3, length_in_t: 1 * parent_part.tab_depth_percent),
                 top_connector: WikiHouse::NoneConnector.new(),
                 bottom_connector: WikiHouse::NoneConnector.new(),
                 right_connector: WikiHouse::HookConnector.new(thickness: thickness, width_in_t: 1 * parent_part.tab_depth_percent, length_in_t: 1),
                 face_connector:  BackCrossBarPocketConnector.new(cross_bar: self, desk: parent_part))


    end

    def length
      parent_part.width - 2 * parent_part.side_leg_offset - 2 * thickness * (1 - parent_part.tab_depth_percent)
    end


    def width
      if sheet.length == 24
        value = parent_part.front_cross_bar_nominal_width/4.0 + thickness * parent_part.tab_depth_percent + thickness
      else
        value = parent_part.front_cross_bar_nominal_width + thickness * parent_part.tab_depth_percent + thickness
      end

    end
  end
  class BackCrossBar
    #This isn't parametric yet
    include WikiHouse::PartHelper
    include WikiHouse::BoardPartHelper
    include WikiHouse::AttributeHelper
    attr_reader :number_of_tabs, :tab_size

    def initialize(parent_part: nil, sheet: nil, group: nil, origin: nil, label: label)
      part_init(origin: origin, sheet: sheet, label: label, parent_part: parent_part)


      @length_method = :width
      @number_of_tabs = 3
      init_board(left_connector: WikiHouse::TabConnector.new(count: @number_of_tabs, thickness: thickness, width_in_t: 3, length_in_t: 1 * parent_part.tab_depth_percent),
                 top_connector: WikiHouse::TabConnector.new(count: 1, length_in_t: 1 + 1 * parent_part.tab_depth_percent, thickness: thickness, width_in_t: 3),
                 bottom_connector: WikiHouse::TabConnector.new(count: 1, length_in_t: 1 + 1 * parent_part.tab_depth_percent, thickness: thickness, width_in_t: 3),
                 right_connector: WikiHouse::NoneConnector.new,
                 face_connector: BackCrossBarPocketConnector.new(cross_bar: self, desk: parent_part))

    end


    def length
      parent_part.width - 2 * parent_part.side_leg_offset  - 2 *  thickness * (1 - parent_part.tab_depth_percent)

    end

    def width
      if sheet.length == 24
        value = parent_part.back_cross_bar_nominal_width/4.0 + thickness * parent_part.tab_depth_percent
      else
        value = parent_part.back_cross_bar_nominal_width + thickness * parent_part.tab_depth_percent
      end
    end
  end
  class MiddleCrossBar
    #This isn't parametric yet
    include WikiHouse::PartHelper
    include WikiHouse::BoardPartHelper
    include WikiHouse::AttributeHelper
    attr_reader :number_of_tabs

    def initialize(parent_part: nil, sheet: nil, group: nil, origin: nil, label: label)
      part_init(origin: origin, sheet: sheet, label: label, parent_part: parent_part)


      @length_method = :width
      @number_of_tabs = 1
      init_board(left_connector: WikiHouse::TabConnector.new(count: @number_of_tabs, thickness: thickness, width_in_t: 3, length_in_t: 1 * parent_part.tab_depth_percent),
                 top_connector: WikiHouse::TabConnector.new(count: 1, length_in_t:  1 * parent_part.tab_depth_percent, thickness: thickness, width_in_t: 2),
                 bottom_connector: WikiHouse::TabConnector.new(count: 1, length_in_t:  1 * parent_part.tab_depth_percent, thickness: thickness, width_in_t:2),
                 right_connector: WikiHouse::NoneConnector.new,
                 face_connector: WikiHouse::NoneConnector.new())

    end


    def length
      parent_part.leg_top_width - parent_part.leg_front_cross_bar_front_offset - parent_part.leg_back_cross_bar_back_offset

    end

    def width
      if sheet.length == 24
        value = parent_part.front_cross_bar_nominal_width/4.0 + thickness * parent_part.tab_depth_percent
      else
        value = parent_part.front_cross_bar_nominal_width + thickness * parent_part.tab_depth_percent
      end
    end
  end
  class Leg
    #This isn't parametric yet
    include WikiHouse::PartHelper

    include WikiHouse::AttributeHelper
    attr_reader :parent_part

    def initialize(parent_part: nil, sheet: nil, group: nil, origin: nil, label: label)
      part_init(origin: origin, sheet: sheet, label: label, parent_part: parent_part)

      @parent_part = parent_part
      @origin = origin
    end


    def origin=(new_origin)
      @origin = new_origin
    end

    def length
      value = 30 + thickness * (1 - parent_part.tab_depth_percent)
      sheet.length == 24 ? value/4.0 : value
    end

    def width
      value = 26
      sheet.length == 24 ? value/4.0 : value
    end

    def bounding_c1
      @origin.dup
    end

    def back_foot_width
      value = 3.0
      sheet.length == 24 ? value/4.0 : value
    end

    def front_foot_width
      value = 2.5
      sheet.length == 24 ? value/4.0 : value
    end

    def top_width
      parent_part.leg_top_width
    end

    def inner_gap_width
      value = 6.0
      sheet.length == 24 ? value/4.0 : value
    end

    def inner_leg_length
      value = 24
      sheet.length == 24 ? value/4.0 : value
    end

    def front_leg_from_back_origin
      value = 14
      sheet.length == 24 ? value/4.0 : value
    end

    def top_tab_width
      top_width/1.7
    end

    def top_tab_width_in_t
      top_tab_width / thickness
    end

    def top_tab_offset
      (top_width - top_tab_width)/2.0
    end

    def front_cross_bar_front_offset
     parent_part.leg_front_cross_bar_front_offset
    end

    def back_cross_bar_back_offset
      parent_part.leg_back_cross_bar_back_offset
    end

    def front_cross_bar_top_offset
      if sheet.length == 24
        bottom_half = (parent_part.front_cross_bar_nominal_width/4.0 + sheet.thickness * parent_part.tab_depth_percent)/2.0 - sheet.thickness/2.0
        value = parent_part.front_cross_bar_nominal_width/4.0 - bottom_half - sheet.thickness
      else
        bottom_half = (parent_part.front_cross_bar_nominal_width + sheet.thickness * parent_part.tab_depth_percent)/2.0 - sheet.thickness/2.0
        value = parent_part.front_cross_bar_nominal_width - bottom_half - sheet.thickness
      end

      value
    end

    def back_cross_bar_top_offset
      if sheet.length == 24
        value = (parent_part.back_cross_bar_nominal_width/4.0 - 3 * sheet.thickness)/2.0 - sheet.thickness
      else
        bottom_half = (parent_part.back_cross_bar_nominal_width + sheet.thickness * parent_part.tab_depth_percent - 3 * sheet.thickness)/2.0
        value = parent_part.back_cross_bar_nominal_width - bottom_half - 3 * sheet.thickness
      end

      value

    end

    def make_points
      t = thickness
      leg_points = []
      leg_points << [bounding_c1.x, bounding_c1.y, bounding_c1.z]
      leg_points << [bounding_c1.x + back_foot_width, bounding_c1.y - length + thickness, bounding_c1.z]


      #Top Tab
      leg_points << [bounding_c1.x + back_foot_width + top_tab_offset, bounding_c1.y - length + thickness, bounding_c1.z]
      leg_points << [bounding_c1.x + back_foot_width + top_tab_offset, bounding_c1.y - length + thickness * (1 - parent_part.tab_depth_percent), bounding_c1.z]
      leg_points << [bounding_c1.x + back_foot_width + top_tab_offset + top_tab_width_in_t * t, bounding_c1.y - length + thickness * (1 - parent_part.tab_depth_percent), bounding_c1.z]
      leg_points << [bounding_c1.x + back_foot_width + top_tab_offset+ top_tab_width_in_t * t, bounding_c1.y - length + thickness, bounding_c1.z]

      # Front Cross Bar Slot
      leg_points << [bounding_c1.x + back_foot_width + top_width - front_cross_bar_front_offset - t,
                     bounding_c1.y - length + thickness,
                     bounding_c1.z]
      leg_points << [bounding_c1.x + back_foot_width + top_width - front_cross_bar_front_offset - t,
                     bounding_c1.y - length + thickness + parent_part.front_cross_bar_nominal_width,
                     bounding_c1.z]
      leg_points << [bounding_c1.x + back_foot_width + top_width - front_cross_bar_front_offset,
                     bounding_c1.y - length + thickness + parent_part.front_cross_bar_nominal_width,
                     bounding_c1.z]

      leg_points << [bounding_c1.x + back_foot_width + top_width - front_cross_bar_front_offset,
                     bounding_c1.y - length + thickness,
                     bounding_c1.z]

      #Rest of leg
      leg_points << [bounding_c1.x + back_foot_width + top_width, bounding_c1.y - length + thickness, bounding_c1.z]
      leg_points << [bounding_c1.x + width, bounding_c1.y, bounding_c1.z]
      leg_points << [bounding_c1.x + width - front_foot_width, bounding_c1.y, bounding_c1.z]
      leg_points << [bounding_c1.x + front_leg_from_back_origin, bounding_c1.y - inner_leg_length, bounding_c1.z]
      leg_points << [bounding_c1.x + front_leg_from_back_origin - inner_gap_width, bounding_c1.y - inner_leg_length, bounding_c1.z]


      leg_points << [bounding_c1.x + back_foot_width, bounding_c1.y, bounding_c1.z]
      #Fillet top tab
      WikiHouse::DogBoneFillet.by_points(leg_points, 3, 2, 1, reverse_it: true)
      WikiHouse::DogBoneFillet.by_points(leg_points, 6, 7, 8)
      #Fillet Front Cross Slot
      WikiHouse::DogBoneFillet.by_points(leg_points, 12, 11, 10, reverse_it: true)

      WikiHouse::DogBoneFillet.by_points(leg_points, 13, 14, 15)
      #  WikiHouse::DogBoneFillet.by_points(leg_points,11,12,13)

      #Need to fillet the top tab and the cross bar slot
      leg_points
    end

    def make_pockets!


      t = thickness


      pockets = []


      #back cross bar pocket
      #
      c5 = [bounding_c1.x + back_foot_width + back_cross_bar_back_offset,
            bounding_c1.y - length + t + back_cross_bar_top_offset + 3 * t,
            bounding_c1.z]
      c6 = [c5.x + t, c5.y, c5.z]
      c7 = [c6.x, c5.y - 3 * t, c5.z]
      c8 = [c5.x, c7.y, c5.z]
      points = [c5, c6, c7, c8]

      WikiHouse::Fillet.pocket_by_points(points)

      pocket_lines = Sk.draw_all_points(points)
      pocket_lines.each { |e| mark_inside_edge!(e) }
      pockets << pocket_lines

      pockets

    end

    def make_dowels!

      return [] if WikiHouse.machine.bit_radius == 0
      t = thickness

      dowel_points = []
      #Back Leg Dowels
      dowel_x_gap = 0.6
      dowel_y_gap = 4.0
      d1 = [bounding_c1.x + 1.5, bounding_c1.y - 1, bounding_c1.z]
      dowel_points << d1
      6.times do |i|
        dowel_points << [d1.x + (i + 1) * dowel_x_gap, d1.y - (i + 1) * dowel_y_gap, d1.z]
      end


      #ftont leg dowels
      dowel_x_gap = 1.25
      dowel_y_gap = 4.0
      d1 = [bounding_c1.x + 24.25, bounding_c1.y - 1, bounding_c1.z]
      dowel_points << d1
      6.times do |i|
        dowel_points << [d1.x - (i + 1) * dowel_x_gap, d1.y - (i + 1) * dowel_y_gap, d1.z]
      end

      # Mid
      dowel_points << [bounding_c1.x + 10, bounding_c1.y - 25.5, bounding_c1.z]
      dowel_points << [bounding_c1.x + 10, bounding_c1.y - 28, bounding_c1.z]

      dowels = []
      dowel_points.each { |d| dowels << Sk.draw_circle(center_point: d, radius: WikiHouse.machine.bit_radius) }
      dowels.each { |d| d.each { |e| mark_inside_edge!(e) } }

      dowels
    end

    def draw!

      points = make_points


      lines = Sk.draw_all_points(points)
      if WikiHouse.machine.bit_radius != 0
        dowels = make_dowels!
      else
        dowels = []
      end

      pockets = make_pockets!

      face = Sk.add_face(lines)
      set_material(face)

      dowels.each do |sp|
        dowel_face = Sk.add_face(sp)
        dowel_face.erase!
      end
      pockets.each do |sp|
        pocket_face = Sk.add_face(sp)
        pocket_face.erase!
      end

      make_part_right_thickness(face)
      Sk.add_face(lines)

      set_group(face.all_connected)
      mark_primary_face!(face)
    end

    def set_default_properties
      mark_cutable!
    end
  end
  class OuterLeg < Leg
    def make_points
      t = thickness
      leg_points = []
      leg_points << [bounding_c1.x, bounding_c1.y, bounding_c1.z]
      leg_points << [bounding_c1.x + back_foot_width, bounding_c1.y - length + thickness, bounding_c1.z]


      #Top Tab
      leg_points << [bounding_c1.x + back_foot_width + top_tab_offset, bounding_c1.y - length + thickness, bounding_c1.z]
      leg_points << [bounding_c1.x + back_foot_width + top_tab_offset, bounding_c1.y - length + thickness * (1 - parent_part.tab_depth_percent), bounding_c1.z]
      leg_points << [bounding_c1.x + back_foot_width + top_tab_offset + top_tab_width_in_t * t, bounding_c1.y - length + thickness * (1 - parent_part.tab_depth_percent), bounding_c1.z]
      leg_points << [bounding_c1.x + back_foot_width + top_tab_offset+ top_tab_width_in_t * t, bounding_c1.y - length + thickness, bounding_c1.z]


      # Front Cross Bar Slot
      leg_points << [bounding_c1.x + back_foot_width + top_width - front_cross_bar_front_offset - t,
                     bounding_c1.y - length + thickness,
                     bounding_c1.z]
      leg_points << [bounding_c1.x + back_foot_width + top_width - front_cross_bar_front_offset - t,
                     bounding_c1.y - length + thickness + parent_part.front_cross_bar_nominal_width + t,
                     bounding_c1.z]
      leg_points << [bounding_c1.x + back_foot_width + top_width - front_cross_bar_front_offset,
                     bounding_c1.y - length + thickness + parent_part.front_cross_bar_nominal_width + t,
                     bounding_c1.z]

      leg_points << [bounding_c1.x + back_foot_width + top_width - front_cross_bar_front_offset,
                     bounding_c1.y - length + thickness,
                     bounding_c1.z]
      #Rest of leg
      leg_points << [bounding_c1.x + back_foot_width + top_width, bounding_c1.y - length + thickness, bounding_c1.z]
      leg_points << [bounding_c1.x + width, bounding_c1.y, bounding_c1.z]
      leg_points << [bounding_c1.x + width - front_foot_width, bounding_c1.y, bounding_c1.z]
      leg_points << [bounding_c1.x + front_leg_from_back_origin, bounding_c1.y - inner_leg_length, bounding_c1.z]
      leg_points << [bounding_c1.x + front_leg_from_back_origin - inner_gap_width, bounding_c1.y - inner_leg_length, bounding_c1.z]


      leg_points << [bounding_c1.x + back_foot_width, bounding_c1.y, bounding_c1.z]
      #Fillet top tab
      WikiHouse::DogBoneFillet.by_points(leg_points, 3, 2, 1, reverse_it: true)
      WikiHouse::DogBoneFillet.by_points(leg_points, 6, 7, 8)
      #Fillet Front Cross Slot
      WikiHouse::DogBoneFillet.by_points(leg_points, 12, 11, 10, reverse_it: true)

      WikiHouse::DogBoneFillet.by_points(leg_points, 13, 14, 15)
      #  WikiHouse::DogBoneFillet.by_points(leg_points,11,12,13)

      #Need to fillet the top tab and the cross bar slot
      leg_points
    end


  end
  include WikiHouse::PartHelper

  attr_reader :top, :front_cross_bar, :back_cross_bar, :left_outer_leg, :left_inner_leg, :right_inner_leg, :right_outer_leg,
              :middle_left_cross_bar, :middle_right_cross_bar

  def initialize(origin: nil, sheet: nil, label: nil, parent_part: nil)
    part_init(sheet: sheet, origin: origin, parent_part: parent_part)

    @top = Desktop.new(label: "Top", origin: @origin, sheet: sheet, parent_part: self)
    @front_cross_bar = FrontCrossBar.new(label: "Front Cross bar", origin: @origin, sheet: sheet, parent_part: self)
    @back_cross_bar = BackCrossBar.new(label: "Back Cross bar", origin: @origin, sheet: sheet, parent_part: self)

    @middle_left_cross_bar = MiddleCrossBar.new(label: "Middle Left Cross bar", origin: @origin, sheet: sheet, parent_part: self)
    @middle_right_cross_bar = MiddleCrossBar.new(label: "Middle Right Cross bar", origin: @origin, sheet: sheet, parent_part: self)

    @left_outer_leg = OuterLeg.new(label: "Left Outer Leg", origin: @origin, sheet: sheet, parent_part: self)
    @left_inner_leg = Leg.new(label: "Left Inner Leg", origin: @origin, sheet: sheet, parent_part: self)


    @right_outer_leg = OuterLeg.new(label: "Right Outer Leg", origin: @origin, sheet: sheet, parent_part: self)
    @right_inner_leg = Leg.new(label: "Right Inner Leg", origin: @origin, sheet: sheet, parent_part: self)


  end

  def origin=(new_origin)
    @origin = new_origin
    @top.origin = @origin
    @front_cross_bar.origin = @origin
    @back_cross_bar.origin = @origin
    @middle_left_cross_bar.origin = @origin
    @middle_right_cross_bar.origin = @origin
    @left_outer_leg.origin = @origin
    @left_inner_leg.origin = @origin
    @right_outer_leg.origin = @origin
    @right_inner_leg.origin = @origin
  end

  def tab_depth_percent
    0.80
    #0.50
      1.0
  end

  def length
    value = 30.775
    sheet.length == 24 ? value/4.0 : value
  end


  def width
    value = 48
    sheet.length == 24 ? value/4.0 : value
  end


  def depth
    value = 26
    sheet.length == 24 ? value/4.0 : value
  end

  def front_cross_bar_nominal_width #This is measuered without tabs
   3.0
  end

  def back_cross_bar_nominal_width #this is measured without tabs
    5.0
  end
  def leg_top_width
    value = 15.0
    sheet.length == 24 ? value/4.0 : value
  end
  def leg_front_cross_bar_front_offset
    value = 2
    sheet.length == 24 ? value/4.0 : value
  end

  def leg_back_cross_bar_back_offset
    value = 1.25
    sheet.length == 24 ? value/4.0 : value
  end

  def side_leg_offset # Gap between edge of top and the outer leg
    value = 1.25
    sheet.length == 24 ? value/4.0 : value
  end

  def front_leg_offset
    value = 6.0
    sheet.length == 24 ? value/4.0 : value
  end

  def front_cross_bar_offset #Gap between edge of top and the front cross bar
    value = 8.0
    sheet.length == 24 ? value/4.0 : value
  end

  def back_cross_bar_offset # Gap between edge of top and the back cross bar
    value = 6.25
    sheet.length == 24 ? value/4.0 : value
  end
  def middle_left_cross_bar_offset

    (@front_cross_bar.length * 0.33).to_f.round(2)


  end
  def middle_right_cross_bar_offset
    (@front_cross_bar.length * 0.66).to_f.round(2)

  end
  def draw!
    Sk.find_or_create_layer(name: self.class.name)
    Sk.make_layer_active_name(name: self.class.name)

    @top.draw!
     @top.move_by(x: 0,
                  y: 0,
                  z: length - thickness * tab_depth_percent).go!

       @front_cross_bar.draw!

     @front_cross_bar.rotate(vector: [0, 0, 1], rotation: 180.degrees).
         rotate(vector: [0, 1, 0], rotation: 90.degrees).
         move_to(point: origin).
         move_by(x: -1 * length,
                 y: -1 * width + side_leg_offset + thickness * (1 - tab_depth_percent),
                 z: -1 * front_cross_bar_offset - thickness).go!
    @back_cross_bar.draw!
     @back_cross_bar.rotate(vector: [0, 0, 1], rotation: 180.degrees).
         rotate(vector: [0, 1, 0], rotation: 90.degrees).
         move_to(point: origin).
         move_by(x: -1 * length,
                 y: -1 * width + side_leg_offset +  thickness * (1 - tab_depth_percent),
                 z: -1 * depth + back_cross_bar_offset).go!

    @middle_left_cross_bar.draw!

    @middle_left_cross_bar.rotate(vector: [1, 0, 0], rotation: -90.degrees).
        rotate(vector: [0, 1, 0], rotation: 180.degrees).
        rotate(vector: [0, 0, 1], rotation: 90.degrees).
        move_to(point: origin).
        move_by(x: -1 * length,
                y: @middle_left_cross_bar.length - front_cross_bar_nominal_width - thickness * tab_depth_percent,
                z:-1 * width + side_leg_offset +  thickness * (1 - tab_depth_percent)  + middle_left_cross_bar_offset + thickness).go!
    puts "Moving it to #{width} + #{side_leg_offset} + #{thickness * (1 - tab_depth_percent)}+ #{middle_left_cross_bar_offset} = #{-1 * width + side_leg_offset +  thickness * (1 - tab_depth_percent)  + middle_left_cross_bar_offset}"
    @middle_right_cross_bar.draw!
    @middle_right_cross_bar.rotate(vector: [1, 0, 0], rotation: -90.degrees).
        rotate(vector: [0, 1, 0], rotation: 180.degrees).
        rotate(vector: [0, 0, 1], rotation: 90.degrees).
        move_to(point: origin).
        move_by(x: -1 * length,
                y: @middle_right_cross_bar.length  - front_cross_bar_nominal_width  - thickness * tab_depth_percent,
                z: -1 * width + side_leg_offset +  thickness * (1 - tab_depth_percent)  + middle_right_cross_bar_offset + thickness ).go!


    rear_leg_offset = depth - @left_outer_leg.top_width - front_leg_offset

     @left_outer_leg.draw!

     @left_outer_leg.rotate(vector: [1, 0, 0], rotation: -90.degrees).
         rotate(vector: [0, 1, 0], rotation: 180.degrees).
         move_to(point: origin).
         move_by(x: -1 * (depth + @left_outer_leg.back_foot_width - rear_leg_offset),
                 y: -1 * length,
                 z: -1 * width + side_leg_offset).go!
     @left_inner_leg.draw!

     @left_inner_leg.rotate(vector: [1, 0, 0], rotation: -90.degrees).
         rotate(vector: [0, 1, 0], rotation: 180.degrees).
         move_to(point: origin).
         move_by(x: -1 * (depth + @left_inner_leg.back_foot_width - rear_leg_offset),
                 y: -1 * length,
                 z: -1 * width + side_leg_offset + thickness).go!

     @right_outer_leg.draw!

     @right_outer_leg.rotate(vector: [1, 0, 0], rotation: -90.degrees).
         rotate(vector: [0, 1, 0], rotation: 180.degrees).
         move_to(point: origin).
         move_by(x: -1 * (depth + @right_outer_leg.back_foot_width - rear_leg_offset),
                 y:-1 * length,
                 z: -1 * (thickness + side_leg_offset ) ).go!
     @right_inner_leg.draw!

     @right_inner_leg.rotate(vector: [1, 0, 0], rotation: -90.degrees).
         rotate(vector: [0, 1, 0], rotation: 180.degrees).
         move_to(point: origin).
         move_by(x: -1 * (depth + @right_inner_leg.back_foot_width - rear_leg_offset),
                 y: -1 * length,
                 z: -1 * (side_leg_offset + 2 * thickness  )).go!

    groups = [@top.group, @front_cross_bar.group, @back_cross_bar.group,
              @left_outer_leg.group, @left_inner_leg.group, @right_outer_leg.group, @right_inner_leg.group, @middle_left_cross_bar.group, @middle_right_cross_bar.group]


    set_group(groups.compact)
  end


end