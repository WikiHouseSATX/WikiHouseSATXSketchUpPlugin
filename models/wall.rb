class WikiHouse::Wall
  include WikiHouse::DrawingHelper

  def initialize
    @sheet = WikiHouse::Sheet.new
  end

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

  def draw_bottom_footer

  end

  def draw_side(orientation: :left, origin: nil)
    if orientation == :left
      c1 = origin
      c2 = [origin.x + @sheet.thickness, origin.y, origin.z]
      c3 = [origin.x + @sheet.thickness, origin.y - side_length, origin.z]
      c4 = [origin.x, origin.y - side_length, origin.z]
    elsif orientation == :right
      c1 = origin
      c2 = [origin.x + @sheet.thickness, origin.y, origin.z]
      c3 = [origin.x + @sheet.thickness, origin.y - side_length, origin.z]
      c4 = [origin.x, origin.y - side_length, origin.z]
    elsif orientation == :top
      c1 = origin
      c2 = [origin.x + side_length, origin.y, origin.z]
      c3 = [origin.x + side_length, origin.y - @sheet.thickness, origin.z]
      c4 = [origin.x, origin.y - @sheet.thickness, origin.z]
    elsif orientation == :bottom
      c1 = origin
      c2 = [origin.x + side_length, origin.y, origin.z]
      c3 = [origin.x + side_length, origin.y - @sheet.thickness, origin.z]
      c4 = [origin.x, origin.y - @sheet.thickness, origin.z]
    end

    if orientation == :left || orientation == :right
      c5 = [origin.x, origin.y - tab_start, 0]
      c6 = [origin.x + @sheet.thickness, origin.y - tab_start, 0]
      c7 = [origin.x, origin.y - tab_end, 0]
      c8 = [origin.x + @sheet.thickness, origin.y - tab_end, 0]
      if orientation == :left
        c9 = c6
        c10 = c8
      else
        c9 = c5
        c10 = c7
      end
    else
      c5 = [origin.x + tab_start, origin.y, 0]
      c6 = [origin.x + tab_start, origin.y - @sheet.thickness, 0]
      c7 = [origin.x + tab_end, origin.y, 0]
      c8 = [origin.x + tab_end, origin.y - @sheet.thickness, 0]
      if orientation == :bottom
        c9 = c5
        c10 = c7
      else
        c9 = c6
        c10 = c8
      end
    end
    lines = []
    lines << draw_line(c1, c2)
    lines << draw_line(c2, c3)
    lines << draw_line(c3, c4)
    lines << draw_line(c4, c1)
    face = Sketchup.active_model.active_entities.add_face(lines)
    draw_line(c5, c6)
    draw_line(c7, c8)

    line = draw_line(c9,c10) #interior line
    line.erase!
    [c1, c2, c3, c4, c5, c6, c7, c8]
  end

  def draw!
    left_side = draw_side(orientation: :left, origin: [0, 0, @sheet.thickness])
    top_side = draw_side(orientation: :top, origin: [0 + @sheet.thickness, 0, @sheet.thickness])
    right_side = draw_side(orientation: :right, origin: [side_length, 0 - @sheet.thickness, @sheet.thickness])
    bottom_side = draw_side(orientation: :bottom, origin: [0, 0 - side_length, @sheet.thickness])

    center_piece_lines = [
        draw_line(left_side[4], left_side[6]),
        draw_line(left_side[4], left_side[5]),
        draw_line(left_side[6], left_side[7]),
        draw_line(left_side[7], left_side[2]),


         draw_line(top_side[4], top_side[6]),

         draw_line(top_side[4], top_side[5]),
         draw_line(top_side[6], top_side[7]),
         draw_line(top_side[3], top_side[5]),
         draw_line(top_side[3], left_side[5]),
         draw_line(top_side[7], right_side[0]),

        draw_line(right_side[0], right_side[4]),
        draw_line(right_side[4], right_side[5]),
        draw_line(right_side[5], right_side[7]),
        draw_line(right_side[7], right_side[6]),
        draw_line(right_side[6], bottom_side[1]),

        draw_line(bottom_side[6], bottom_side[1]),
        draw_line(bottom_side[6], bottom_side[7]),
        draw_line(bottom_side[7], bottom_side[5]),
        draw_line(bottom_side[5], bottom_side[4]),

        draw_line(bottom_side[4], left_side[2]),
    ]

    top_center_piece_face = Sketchup.active_model.active_entities.add_face(center_piece_lines)
    #center_piece_group = Sketchup.active_model.active_entities.add_group center_piece_face.all_connected
  end
end