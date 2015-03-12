class WikiHouse::Wall
  include WikiHouse::DrawingHelper

  class Column
    def side_length
      10
    end
    def tab_width
      5
    end
    def tab_start
      side_length/2.0 - tab_width/2.0
    end

    def tab_end
      side_length/2.0 + tab_width/2.0
    end
  end
  class ColumnCap
    def initialize(column, origin: [0,0,0], sheet: nil)
      @column = column
      @sheet = sheet ? sheet : WikiHouse::Sheet.new
      @left_side = @right_side = @top_side = @bottom_side = @top_face = @bottom_face = nil
    end
    def side_length
      @column.side_length

    end
    def tab_width
      @column.tab_width
    end
    def tab_start
      @column.tab_start
    end
    def tab_end
      @column.tab_end
    end
    def left_side
      unless @left_side
        @left_side = calculate_side(:left)
      end
      @left_side
    end
    def right_side
      unless @right_side
        @right_side = calculate_side(:right)
      end
      @right_side
    end
    def top_side
      unless @top_side
        @top_side = calculate_side(:top)
      end
      @top_side
    end
    def bottom_side
      unless @bottom_side
        @bottom_side = calculate_side(:bottom)
      end
      @bottom_side
    end
    def calculate_side(orientation: :left)
      #this needs to embed the origin calc here and use c1 instead of origin to calculate the other dimesnation
      if orientation == :left
        c1 = @origin.dup
        c2 = [@origin.x + @sheet.thickness, @origin.y, @origin.z]
        c3 = [@origin.x + @sheet.thickness, @origin.y - side_length, @origin.z]
        c4 = [@origin.x, @origin.y - side_length, @origin.z]
      elsif orientation == :right
        c1 = @origin
        c2 = [@origin.x + @sheet.thickness, @origin.y, @origin.z]
        c3 = [@origin.x + @sheet.thickness, @origin.y - side_length, @origin.z]
        c4 = [@origin.x, @origin.y - side_length, @origin.z]
      elsif orientation == :top
        [0 + @sheet.thickness, 0, 0]
        c1 = @origin.dup
        c2 = [@origin.x + side_length, @origin.y, @origin.z]
        c3 = [@origin.x + side_length, @origin.y - @sheet.thickness, @origin.z]
        c4 = [@origin.x, @origin.y - @sheet.thickness, @origin.z]
      elsif orientation == :bottom
        c1 = @origin
        c2 = [@origin.x + side_length, @origin.y, @origin.z]
        c3 = [@origin.x + side_length, @origin.y - @sheet.thickness, @origin.z]
        c4 = [@origin.x, @origin.y - @sheet.thickness, @origin.z]
      end

      if orientation == :left || orientation == :right
        c5 = [@origin.x, @origin.y - tab_start, 0]
        c6 = [@origin.x + @sheet.thickness, @origin.y - tab_start, 0]
        c7 = [@origin.x, @origin.y - tab_end, 0]
        c8 = [@origin.x + @sheet.thickness, @origin.y - tab_end, 0]
        if orientation == :left
          c9 = c6
          c10 = c8
        else
          c9 = c5
          c10 = c7
        end
      else
        c5 = [@origin.x + tab_start, @origin.y, 0]
        c6 = [@origin.x + tab_start, @origin.y - @sheet.thickness, 0]
        c7 = [@origin.x + tab_end, @origin.y, 0]
        c8 = [@origin.x + tab_end, @origin.y - @sheet.thickness, 0]
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
    def draw!
      left_side = draw_side(orientation: :left, origin: [0, 0, 0])
      top_side = draw_side(orientation: :top, origin: [0 + @sheet.thickness, 0, 0])
      right_side = draw_side(orientation: :right, origin: [side_length, 0 - @sheet.thickness, 0])
      bottom_side = draw_side(orientation: :bottom, origin: [0, 0 - side_length, 0])

      bottom_center_piece_line_pts = [
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

      bottom_center_piece_face = create_center_piece_face(bottom_center_piece_line_pts)

      bottom_center_piece_face.reverse!
      bottom_center_piece_face.pushpull @sheet.thickness
      top_center_piece_line_pts = []


      bottom_center_piece_line_pts.each do |line_points|
        first_point = line_points[0].dup
        last_point = line_points[1].dup
        first_point.z = @sheet.thickness
        last_point.z = @sheet.thickness
        top_center_piece_line_pts << [first_point, last_point]

      end
      top_center_piece_face = create_center_piece_face(top_center_piece_line_pts)

      center_piece_group = Sketchup.active_model.active_entities.add_group bottom_center_piece_face.all_connected
    end
  end
  def initialize
    @sheet = WikiHouse::Sheet.new
    @column = Column.new
  end
  def wall_height
    80
  end
  def draw!
    @bottom_column_cap = ColumnCap.new(@column, [0,0,0])
    @bottom_column_cap.draw!
    @top_column_cap = ColumnCap.new(@column, [0,0,wall_height])
    @top_column_cap.draw!
  end
end