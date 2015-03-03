class Fillet
 include DrawingHelper
  def initialize(fillet_on: nil, fillet_off: nil)
    @fillet_on = fillet_on
    @fillet_off = fillet_off
    puts "Edge1 #{Fillet.edge_to_s(@fillet_on)}"
    puts "Edge2 #{Fillet.edge_to_s(@fillet_off)}"
    if fillet_on.start.position == fillet_off.start.position
      @intersection = fillet_on.start
      @fillet_off_end = fillet_off.end
    elsif fillet_on.start.position == fillet_off.end.position
      @intersection = fillet_on.start
      @fillet_off_end = fillet_off.start
    elsif fillet_on.end.position == fillet_off.start.position
      @intersection = fillet_on.end
      @fillet_off_end = fillet_off.end
    elsif   fillet_on.end.position == fillet_off.end.position
        @intersection = fillet_on.end
        @fillet_off_end = fillet_off.start
    else
      raise ArgumentError, "The edges must intersect to form a fillet"
    end

  end
  def bit_size
    0.25
  end
  def draw!
  #  @fillet_on.erase!
#figure out orientation and the side to ommit
    x_shift = @intersection.position.x - @fillet_off_end.position.x
    y_shift = @intersection.position.y - @fillet_off_end.position.y

    puts "X #{x_shift} Y #{y_shift}"
    x1 = @intersection.position.x
    y1 = @intersection.position.y
    x2 = @intersection.position.x
    y2 = @intersection.position.y


    fillet_end = [ @fillet_off_end.position.x,  @fillet_off_end.position.y, @fillet_off_end.position.z]
    @fillet_off.erase!
    if x_shift < 0
      #negative bit size for x
      if y_shift < 0
        #negative for y
      else
        #positing bit size for y
        c1,c2, c3, c4  = build_box(x1 -   bit_size, y1 - 2 * bit_size, x2, y2)

        #negative bit size for y
        draw_line(c1, c2)
        draw_line(c2,c3)
  #      draw_line(c3,c4)
        draw_line(c4,c1)
        draw_line(c3, fillet_end)
      end
    else
      #positing bit size for x
        if y_shift < 0
          #negative bit size for y
          open_side = :s1
        else
          #positing bit size for y
          open_side = :s1
        end
    end

  end
end
