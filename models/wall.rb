class WikiHouse::Wall
  include WikiHouse::DrawingHelper

  class ColumnBoard
    include WikiHouse::DrawingHelper

    def initialize(origin: nil, sheet: nil)
      #origin should be the upper left corner
      @origin = origin

      @sheet = sheet ? sheet : WikiHouse::Sheet.new

    end

    def number_of_side_tabs
      3
    end

    def c1
      @origin.dup
    end

    def c2
      [c1.x + bottom_side_length, c1.y, c1.z]
    end

    def c3
      [c1.x + bottom_side_length, c1.y - left_side_length, c1.z]
    end

    def c4
      [c1.x, c1.y - left_side_length, c1.z]
    end

    def right_pockets
      lines = []
      c5 = c2
      c5.y -= thickness

      c6 = c3
      c6.y += thickness

      total_length = c5.y - c6.y
      puts total_length
      section_width = total_length/number_of_side_tabs.to_f
      number_of_side_tabs.times do |i|
        start_y = c5.y - (i * section_width)

        mid_point = start_y - section_width/2.0

        start_pocket = mid_point + tab_width/2.0
        end_pocket = mid_point - tab_width/2.0
        end_y = (i + 1) * section_width

        pc1 = [c5.x - thickness, start_pocket, c5.z]
        pc2 = [c5.x, start_pocket, c5.z]
        pc3 = [c5.x, end_pocket, c5.z]
        pc4 = [c5.x - thickness, end_pocket, c5.z]

        lines << draw_line(pc1, pc2)
        erase_line(pc2, pc3)

        lines << draw_line(pc3, pc4)

        lines << draw_line(pc4, pc1)
      end
      lines
    end

    def left_tabs

      c1_5 = [c1.x + thickness, c1.y, c1.z]
      c4_5 = [c4.x + thickness, c4.y, c4.z]
      lines = []
      c5 = c1
      c5.y -= thickness
      c6 = [c5.x + thickness, c5.y, c5.z]

      c7 = [c6.x, c6.y - left_side_length + (2 * thickness), c6.z]
      c8 = [c5.x, c7.y, c5.z]

      erase_line(c1, c4)
      erase_line(c1, c1_5)
      erase_line(c4, c4_5)

      draw_line(c1_5, c6)
      draw_line(c7, c4_5)
      total_length = c5.y - c8.y
      puts total_length
      section_width = total_length/number_of_side_tabs.to_f
      last_point_1 = nil
      last_point_2 = c6
      last_point_4 = nil
      number_of_side_tabs.times do |i|
        start_y = c5.y - (i * section_width)

        mid_point = start_y - section_width/2.0

        start_pocket = mid_point + tab_width/2.0
        end_pocket = mid_point - tab_width/2.0
        pc1 = [c5.x, start_pocket, c5.z]
        pc2 = [c5.x + thickness, start_pocket, c5.z]
        pc3 = [c5.x + thickness, end_pocket, c5.z]
        pc4 = [c5.x, end_pocket, c5.z]
        lines << draw_line(last_point_4, last_point_1) if last_point_4
        lines << draw_line(last_point_1, last_point_2) if last_point_1 && last_point_2
        lines << draw_line(last_point_2, pc2) if last_point_2
        lines << draw_line(pc2, pc1)

        last_point_1 = pc4
        last_point_2 = pc3
        last_point_4 = pc1


      end
      lines << draw_line(last_point_4, last_point_1) if last_point_4
      lines << draw_line(last_point_1, last_point_2)
      lines << draw_line(last_point_2, c7 )

      lines
    end

    def top_bottom_pockets

      #Top Indent
      c5 = [c1.x + bottom_tab_start, c1.y, c1.z]
      c6 = [c1.x + bottom_tab_end, c1.y, c1.z]
      c7 = [c1.x + bottom_tab_end, c1.y - thickness, c1.z]
      c8 = [c1.x + bottom_tab_start, c1.y - thickness, c1.z]

      c9 = [c1.x + bottom_tab_start, c1.y - left_side_length + thickness, c1.z]
      c10 = [c1.x + bottom_tab_end, c1.y - left_side_length + thickness, c1.z]
      c11 = [c1.x + bottom_tab_end, c1.y - left_side_length, c1.z]
      c12 = [c1.x + bottom_tab_start, c1.y - left_side_length, c1.z]


     pts = [c1,c5,c8,c7,c6,c2, c3, c11, c10,c9, c12,c4]


      connect_all_points(pts)
    end

    def draw!
      top_bottom_lines = top_bottom_pockets
      right_pockets
      left_tabs

      lines = top_bottom_lines.select {|l| !l.deleted?}.first.all_connected
      face = Sketchup.active_model.active_entities.add_face(lines)
      face.reverse!
      face.pushpull thickness
      face2 = Sketchup.active_model.active_entities.add_face(lines)
      column_board = Sketchup.active_model.active_entities.add_group face.all_connected
      point = Geom::Point3d.new 10, 0, 0
      t = Geom::Transformation.new point
      column_board.move! t
      column_board
    end

    def bottom_side_length
      10
    end

    def left_side_length
      80

    end

    def tab_width
      5
    end

    def bottom_tab_start
      bottom_side_length/2.0 - tab_width/2.0
    end

    def bottom_tab_end
      bottom_side_length/2.0 + tab_width/2.0
    end

    def thickness
      @sheet.thickness
    end
  end
  class ColumnCap
    include WikiHouse::DrawingHelper

    def initialize(column, origin: [0, 0, 0], sheet: nil)
      #origin should be the upper left corner
      @origin = origin
      @column = column
      @sheet = sheet ? sheet : WikiHouse::Sheet.new

     @bottom_face = nil
    end
    def thickness
      @sheet.thickness
    end
    def side_length
      @column.bottom_side_length

    end

    def tab_width
      @column.tab_width
    end

   

     def create_face(line_points)

      lines = connect_all_points(line_points)
      face = Sketchup.active_model.active_entities.add_face(lines.first.all_connected)
      #group = Sketchup.active_model.active_entities.add_group center_piece_face.all_connected
      face
    end

    def bottom_face_line_pts
      c0 = @origin.dup
      c1 = [c0.x + thickness, c0.y - thickness, c0.z]
      c2 = [ c0.x + side_length - ( thickness) , c1.y, c1.z]
      c3 = [ c2.x, c0.y - side_length + (thickness), c2.z]
      c4 = [c1.x, c3.y, c3.z]

      points = [c1]
       x_midpoint = c1.x + (c2.x - c1.x)/2.0
       y_midpoint = c2.y - (c2.y - c3.y)/2.0
       half_tab = tab_width/2.0

      points << [x_midpoint - half_tab, c1.y, c1.z]
      points << [x_midpoint - half_tab, c1.y + thickness, c1.z]
      points << [x_midpoint + half_tab, c1.y + thickness, c1.z]
      points << [x_midpoint + half_tab, c1.y, c1.z]
      points << c2

      points << [c2.x , y_midpoint + half_tab, c2.z]
      points << [c2.x + thickness,  y_midpoint + half_tab , c2.z]
      points << [c2.x + thickness, y_midpoint - half_tab, c2.z]
      points << [c2.x ,  y_midpoint - half_tab, c2.z]
      points << c3

      points << [x_midpoint + half_tab, c3.y, c3.z]
      points << [x_midpoint + half_tab, c3.y - thickness, c3.z]
      points << [x_midpoint - half_tab, c3.y - thickness, c3.z]
      points << [ x_midpoint - half_tab, c3.y, c3.z]
      points << c4

      points << [c4.x ,  y_midpoint - half_tab, c4.z]
      points << [c4.x - thickness,  y_midpoint - half_tab , c4.z]
      points << [c4.x - thickness, y_midpoint + half_tab, c4.z]
      points << [c4.x , y_midpoint + half_tab, c4.z]

      
      points
    end


    def draw!


      @bottom_face = create_face(bottom_face_line_pts)

      @bottom_face.reverse!
      @bottom_face.pushpull @sheet.thickness


      center_piece_group = Sketchup.active_model.active_entities.add_group @bottom_face.all_connected
    end
  end

  def initialize
    @sheet = WikiHouse::Sheet.new
    @column = ColumnBoard.new(origin: [0, 0, 0], sheet: @sheet)
  end

  def wall_height
    80
  end
  def thickness
    @sheet.thickness
  end
  def draw!

    column_board = @column.draw!

    @bottom_column_cap = ColumnCap.new(@column, origin: [0, 0, 0])
    @bottom_column_cap.draw!

    @lower_mid_column_cap = ColumnCap.new(@column, origin: [0, 0, 20])
    @lower_mid_column_cap.draw!

    @upper_mid_column_cap = ColumnCap.new(@column, origin: [0, 0, 40])
    @upper_mid_column_cap.draw!

    @top_column_cap = ColumnCap.new(@column, origin: [0, 0, 80 - thickness])
    @top_column_cap.draw!

    column_board2 = column_board.copy

    point = Geom::Point3d.new  0,0,0

    #tm = Geom::Transformation.new( Geom::Point3d.new(@sheet.thickness,0, 0))

    tr2 = Geom::Transformation.rotation point, [1,0, 0], 90.degrees

    column_board.move!  tr2

   # tr = Geom::Transformation.rotation point, [1, 0, 0], -90.degrees
    #column_board.move! tr

   # column_board3 = column_board.copy
  #  column_board4 = column_board.copy

    #
     point = Geom::Point3d.new  0,0,0
    tr = Geom::Transformation.rotation point, [0, 0, 1], 90.degrees
    tm = Geom::Transformation.new( Geom::Point3d.new(-1 * @column.bottom_side_length,0, 0))

    tr2 = Geom::Transformation.rotation point, [1,0, 0], 90.degrees

    column_board2.move! tr * tm * tr2





    #    @top_column_cap = ColumnCap.new(@column, origin: [0, 0, @column.left_side_length])
    #  @top_column_cap.draw!
  end
end