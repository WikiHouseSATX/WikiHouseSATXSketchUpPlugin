class Fillet
 include DrawingHelper
  def initialize(fillet_on: nil, fillet_off: nil, angle_in_degrees: 90)
    @fillet_on = fillet_on
    @fillet_off = fillet_off
    @angle_in_degrees = angle_in_degrees
    raise ArgumentError, "Can only fillet angles 90 or less" if @angle_in_degrees.abs > 90
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
  def angle_in_radians
    Fillet.degrees_to_radians(angle_in_degrees)
  end
  def angle_in_degrees
    @angle_in_degrees
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
    #@fillet_off.erase!
    if x_shift < 0
      #negative bit size for x
      if y_shift < 0
        #negative for y
        if angle_in_degrees == 90
          raise ScriptError, "No code"
        else
          raise ScriptError, "No code"
        end
      else
        #positing bit size for y

        if angle_in_degrees == 90
        #  c1,c2, c3, c4  = build_box(x1 -   bit_size, y1 - 2 * bit_size, x2, y2)

        raise ScriptError, "No code"
        else
          y_inc = Math.sin(angle_in_radians) * bit_size
          x_inc = Math.cos(angle_in_radians) * bit_size
          centerpoint = Geom::Point3d.new
          centerpoint.x = @intersection.position.x #+ x_inc
          centerpoint.y = @intersection.position.y# - y_inc
          centerpoint.z = 0

          vector = Geom::Vector3d.new 0,0,1
          vector2 = Geom::Vector3d.new 1,0,0
          vector3 = vector.normalize!
          Sketchup.active_model.active_entities.add_arc(centerpoint, vector2, vector3, bit_size,
           0.degrees,360.degrees - angle_in_radians )

          fsy_inc = Math.sin(angle_in_radians) * bit_size * 2
          fsx_inc = Math.cos(angle_in_radians) * bit_size * 2

          new_fillet_start = [@intersection.position.x - fsx_inc, @intersection.position.y - fsy_inc, 0]
      #    draw_line(new_fillet_start,[@intersection.position.x - fsx_inc + 10, @intersection.position.y - fsy_inc, 0] )
      #    draw_line(fillet_end, new_fillet_start)
    end
        #negative bit size for y
    #    draw_line(c1, c2)
  #      draw_line(c2,c3)
  #      draw_line(c3,c4)
  #      draw_line(c4,c1)
  #      draw_line(c3, fillet_end)
      end
    else
      #positing bit size for x
        if y_shift < 0
          #negative bit size for y
          if angle_in_degrees == 90
            raise ScriptError, "No code"
          else
            raise ScriptError, "No code"
          end
        else
          #positing bit size for y
          if angle_in_degrees == 90
            raise ScriptError, "No code"
          else
            raise ScriptError, "No code"
          end
        end
    end

  end
end
