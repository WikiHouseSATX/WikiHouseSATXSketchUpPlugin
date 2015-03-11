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

    else
      c5 = [origin.x + tab_start, origin.y, 0]
      c6 = [origin.x + tab_start, origin.y - @sheet.thickness, 0]
      c7 = [origin.x + tab_end, origin.y, 0]
      c8 =[origin.x + tab_end, origin.y - @sheet.thickness, 0]

    end
    lines = []
    lines << draw_line(c1, c2)
    lines << draw_line(c2, c3)
    lines << draw_line(c3, c4)
    lines << draw_line(c4, c1)
    face = Sketchup.active_model.active_entities.add_face(lines)
    draw_line(c5, c6)
    draw_line(c7, c8)
    line = draw_line(c6,c8)
    line.erase!
  end

  def draw!
    draw_side(orientation: :left, origin: [0,0,0])
    draw_side(orientation: :top, origin: [0 + @sheet.thickness, 0, 0])
    draw_side(orientation: :right, origin: [side_length, 0 - @sheet.thickness, 0])
    draw_side(orientation: :bottom, origin: [0, 0 - side_length, 0])

 

  end
end