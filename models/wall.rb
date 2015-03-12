class WikiHouse::Wall
  include WikiHouse::DrawingHelper

  class ColumnBoard
    include WikiHouse::DrawingHelper
    def initialize( origin: nil, sheet: nil)
      #origin should be the upper left corner
      @origin = origin

      @sheet = sheet ? sheet : WikiHouse::Sheet.new

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
  end
  class ColumnCap
    include WikiHouse::DrawingHelper
    def initialize(column, origin: [0, 0, 0], sheet: nil)
      #origin should be the upper left corner
      @origin = origin
      @column = column
      @sheet = sheet ? sheet : WikiHouse::Sheet.new
      @left_side = @right_side = @top_side = @bottom_side = nil
      @top_face = @bottom_face = nil
    end

    def side_length
      @column.bottom_side_length

    end

    def tab_width
      @column.tab_width
    end

    def tab_start
      @column.bottom_tab_start
    end

    def tab_end
      @column.bottom_tab_end
    end

    def left_side
      unless @left_side
        @left_side = calculate_side( orientation: :left)
      end
      @left_side
    end

    def right_side
      unless @right_side
        @right_side = calculate_side( orientation: :right)
      end
      @right_side
    end

    def top_side
      unless @top_side
        @top_side = calculate_side( orientation: :top)
      end
      @top_side
    end

    def bottom_side
      unless @bottom_side
        @bottom_side = calculate_side( orientation: :bottom)
      end
      @bottom_side
    end

    def calculate_side(orientation: :left)

      c1 = @origin.dup
      if orientation == :left

        c2 = [c1.x + @sheet.thickness, c1.y, c1.z]
        c3 = [c1.x + @sheet.thickness, c1.y - side_length, c1.z]
        c4 = [c1.x, c1.y - side_length, c1.z]
      elsif orientation == :right
        c1.x += side_length
        c1.y -= @sheet.thickness
        c2 = [c1.x + @sheet.thickness, c1.y, c1.z]
        c3 = [c1.x + @sheet.thickness, c1.y - side_length, c1.z]
        c4 = [c1.x, c1.y - side_length, c1.z]
      elsif orientation == :top
        c1.x += @sheet.thickness
        c2 = [c1.x + side_length, c1.y, c1.z]
        c3 = [c1.x + side_length, c1.y - @sheet.thickness, c1.z]
        c4 = [c1.x, c1.y - @sheet.thickness, c1.z]
      elsif orientation == :bottom
        c1.y -= side_length
        c2 = [c1.x + side_length, c1.y, c1.z]
        c3 = [c1.x + side_length, c1.y - @sheet.thickness, c1.z]
        c4 = [c1.x, c1.y - @sheet.thickness, c1.z]
      end

      if orientation == :left || orientation == :right
        c5 = [c1.x, c1.y - tab_start, c1.z]
        c6 = [c1.x + @sheet.thickness, c1.y - tab_start, c1.z]
        c7 = [c1.x, c1.y - tab_end, c1.z]
        c8 = [c1.x + @sheet.thickness, c1.y - tab_end, c1.z]
        if orientation == :left
          c9 = c6
          c10 = c8
        else
          c9 = c5
          c10 = c7
        end
      else
        c5 = [c1.x + tab_start, c1.y, c1.z]
        c6 = [c1.x + tab_start, c1.y - @sheet.thickness, c1.z]
        c7 = [c1.x + tab_end, c1.y, c1.z]
        c8 = [c1.x + tab_end, c1.y - @sheet.thickness, c1.z]
        if orientation == :bottom
          c9 = c5
          c10 = c7
        else
          c9 = c6
          c10 = c8
        end
      end

      [c1, c2, c3, c4, c5, c6, c7, c8]
    end

    def create_face(line_points)
      lines = []
      line_points.each do |line_points|
        lines << draw_line(line_points[0], line_points[1])
      end

      face = Sketchup.active_model.active_entities.add_face(lines)
      #group = Sketchup.active_model.active_entities.add_group center_piece_face.all_connected
      face
    end

    def bottom_face_line_pts
      [
          [left_side[4], left_side[6]],
          [left_side[4], left_side[5]],
          [left_side[6], left_side[7]],
          [left_side[7], left_side[2]],
          [top_side[4], top_side[6]],
          [top_side[4], top_side[5]],
          [top_side[6], top_side[7]],
          [top_side[3], top_side[5]],
          [top_side[3], left_side[5]],
          [top_side[7], right_side[0]],
          [right_side[0], right_side[4]],
          [right_side[4], right_side[5]],
          [right_side[5], right_side[7]],
          [right_side[7], right_side[6]],
          [right_side[6], bottom_side[1]],
          [bottom_side[6], bottom_side[1]],
          [bottom_side[6], bottom_side[7]],
          [bottom_side[7], bottom_side[5]],
          [bottom_side[5], bottom_side[4]],
          [bottom_side[4], left_side[2]],
      ]

    end

    def top_face_line_pts
      line_pts = []
      bottom_face_line_pts.each do |line_points|
        first_point = line_points[0].dup
        last_point = line_points[1].dup
        first_point.z = @sheet.thickness
        last_point.z = @sheet.thickness
        line_pts << [first_point, last_point]

      end
      line_pts
    end

    def draw!


      @bottom_face = create_face(bottom_face_line_pts)
      @top_face = create_face(top_face_line_pts)
      @bottom_face.reverse!
      @bottom_face.pushpull @sheet.thickness


      center_piece_group = Sketchup.active_model.active_entities.add_group @bottom_face.all_connected
    end
  end

  def initialize
    @sheet = WikiHouse::Sheet.new
    @column = ColumnBoard.new(origin: [0,0,0], sheet: @sheet)
  end

  def wall_height
    80
  end

  def draw!
    @bottom_column_cap = ColumnCap.new(@column, origin: [0, 0, 0])
    @bottom_column_cap.draw!
    @top_column_cap = ColumnCap.new(@column, origin: [0, 0, @column.left_side_length])
    @top_column_cap.draw!
  end
end