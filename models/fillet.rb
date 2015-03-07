class Fillet
	attr_reader :c1, :c2, :c3, :c4, :face
	include DrawingHelper
	def initialize(fillet_on: nil, fillet_off: nil, angle_in_degrees: 90)
		@fillet_on = fillet_on
		@fillet_off = fillet_off
		@angle_in_degrees = angle_in_degrees
		@c1 = @c2 = @c3 = @c4 = @face = nil
		raise ArgumentError, "Can only fillet angles 90 or less" if @angle_in_degrees.abs > 90
		puts "Edge1 #{Fillet.edge_to_s(@fillet_on)}"
		puts "Edge2 #{Fillet.edge_to_s(@fillet_off)}"
		if fillet_on.start.position == fillet_off.start.position
			@intersection = fillet_on.start
			@fillet_off_end = fillet_off.end
      @fillet_on_end = fillet_on.end
		elsif fillet_on.start.position == fillet_off.end.position
			@intersection = fillet_on.start
			@fillet_off_end = fillet_off.start
      @fillet_on_end = fillet_on.end
		elsif fillet_on.end.position == fillet_off.start.position
			@intersection = fillet_on.end
			@fillet_off_end = fillet_off.end
      @fillet_on_end = fillet_on.start
		elsif   fillet_on.end.position == fillet_off.end.position
			@intersection = fillet_on.end
			@fillet_off_end = fillet_off.start
      @fillet_on_end = fillet_on.start
		else
			raise ArgumentError, "The edges must intersect to form a fillet On #{@fillet_on.start.position}/#{@fillet_on.end.position} to #{@fillet_off.start.position}/#{@fillet_off.end.position}"
		end

	end

	def angle_in_radians
		Fillet.degrees_to_radians(angle_in_degrees)
	end
	def angle_in_degrees
		@angle_in_degrees
	end
	def bit_radius
		0.25
	end

	def draw!
  #  if angle_in_degrees == 90
      slope =  slope(@intersection.position.x, @intersection.position.y,
                             @fillet_off_end.position.x, @fillet_off_end.position.y)


      if  slope.nil?
        #vertical
        on_orientation = @intersection.position.x  > @fillet_on_end.position.x  ? -1 * bit_radius : bit_radius
        off_orientation = @intersection.position.y > @fillet_off_end.position.y ? -2 * bit_radius : 2 * bit_radius

        @c1 = [@intersection.position.x, @intersection.position.y, 0]
        @c2 = [@intersection.position.x + on_orientation, @c1.y, 0 ]
        @c3 = [@intersection.position.x, @intersection.position.y + off_orientation, 0]
        @c4 = [@c2.x, @c3.y, 0]
        skip_side = :s12
      elsif slope == 0
        #horizontal
        on_orientation = @intersection.position.y > @fillet_on_end.position.y  ?  bit_radius :  -1 * bit_radius
        off_orientation = @intersection.position.x > @fillet_off_end.position.x ? -2 * bit_radius : 2 * bit_radius
        puts "Orientation #{on_orientation} #{off_orientation}"
        @c1 = [@intersection.position.x, @intersection.position.y, 0]
        @c2 = [@intersection.position.x, @c1.y + on_orientation, 0 ]
        @c3 = [@intersection.position.x + off_orientation,  @c2.y , 0]
        @c4 = [@c3.x, @c1.y, 0]
        skip_side = :s41
      else
          #some kind of angle
          on_orientation = @intersection.position.x > @fillet_on_end.position.x  ?   bit_radius/2.0 :  -1 * bit_radius/2.0
          off_orientation = @intersection.position.y > @fillet_off_end.position.y ? -2 * bit_radius : 2 * bit_radius
          bottom_triangle_leg = (2 * bit_radius)/Math.tan(angle_in_radians)
          bottom_triangle_leg = bottom_triangle_leg * -1 if on_orientation > 0

          @c1 = [@intersection.position.x, @intersection.position.y, 0]
          @c2 = [@c1.x + on_orientation, @c1.y, 0 ]
          @c3 = [@c2.x, @c1.y + off_orientation , 0]
          @c4 = [@c1.x + bottom_triangle_leg, c3.y, 0]
          skip_side = :s41
      end

    if @c1
  		fillet_edges = []

  		fillet_edges << 	draw_line(@c1, @c2)
  		fillet_edges <<   draw_line(@c2,@c3)
  		fillet_edges << 	draw_line(@c3,@c4)
  		fillet_edges << 	draw_line(@c4, @c1)
      if skip_side == :s12
      elsif skip_side == :s23
      elsif skip_side == :s34
      elsif skip_side == :s41
        fillet_edges[3].erase!
      end
  		#@face = Sketchup.active_model.active_entities.add_face(fillet_edges)

  	#	if @face
  #			@face.erase!
  #		else
  #			puts "**********UNABLE TO REMOVE FILLET FACE?*********************"
  #		end
    end
  end
end
 # 	#  @fillet_on.erase!
 # 	#figure out orientation and the side to ommit
 # 	#Fille Off Direction
 # 	x_shift = @intersection.position.x - @fillet_off_end.position.x
 # 	y_shift = @intersection.position.y - @fillet_off_end.position.y
 # puts  "Fillet Directions  On: #{fillet_on_x_direction}/#{fillet_on_y_direction}Off:#{fillet_off_x_direction}/#{fillet_off_y_direction}  "
 # 	puts "X #{x_shift} Y #{y_shift}"
 # 	x1 = @intersection.position.x
 # 	y1 = @intersection.position.y
 # 	x2 = @intersection.position.x
 # 	y2 = @intersection.position.y
 #
 # 	@c1  = @c2 = @c3 = @c4 = nil
 # 	fillet_end = [ @fillet_off_end.position.x,  @fillet_off_end.position.y, @fillet_off_end.position.z]
 # 	#@fillet_off.erase!
 # 	if angle_in_degrees == 90
 # 		if x_shift == 0
 # 			if y_shift < 0
 # 			else
 # 			end
 #
 # 		else
 # 			if x_shift < 0
 #
 # 			else
 # 			end
 # 		end
 #
 # 		@c1,@c2,@c3,@c4 = build_box( @intersection.position.x + 2 * bit_radius,
 # 			@intersection.position.y ,
 # 		@intersection.position.x , @intersection.position.y - bit_radius )
 #
 # 	else
 # 		if x_shift < 0
 # 			#negative bit size for x
 # 			if y_shift < 0
 # 				#negative for y
 # 				raise ScriptError, "No code"
 # 			else
 # 				#positing bit size for y
 #
 #
 # 				@c1 = [@intersection.position.x - bit_radius/2.0, @intersection.position.y, 0]
 # 				@c2 = [@intersection.position.x, @intersection.position.y,0]
 #
 # 				@c4 = [@c1.x, @c1.y - 2 * bit_radius ,0]
 #
 # 				bottom_triangle_leg = (bit_radius * 2)/Math.tan(angle_in_radians)
 #
 # 				@c3 = [@c4.x + bottom_triangle_leg + bit_radius/2.0, @c4.y, 0]
 # 				new_edge = @fillet_off.split(@c3)
 # 				new_edge.erase! if new_edge
 #
 # 			end
 # 		else
 # 			#positing bit size for x
 # 			if y_shift < 0
 # 				#negative bit size for y
 #
 #
 # 				@c4 = [@intersection.position.x, @intersection.position.y,0]
 # 				@c3 = [@intersection.position.x + bit_radius/2.0, @intersection.position.y, 0]
 # 				@c2  = [@c3.x, @c3.y + 2 * bit_radius ,0]
 #
 # 				bottom_triangle_leg = (bit_radius * 2)/Math.tan(angle_in_radians)
 #
 # 				#	@c1 = [@c2.x - bottom_triangle_leg - bit_radius/2.0, @c2.y, 0]
 # 				@c1 = [@c4.x - bottom_triangle_leg, @c2.y, 0]
 # 				new_edge = @fillet_off.split(@c1)
 # 				@fillet_off.erase!
 # 				@fillet_off = new_edge
 #
 # 			else
 # 				#positing bit size for y
 # 				raise ScriptError, "No code"
 # 			end
 # 		end
 # 	end
 # 	if @c1
 # 		fillet_edges = []
 #
 # 		fillet_edges << 	draw_line(@c1, @c2)
 # 		fillet_edges <<   draw_line(@c2,@c3)
 # 		fillet_edges << 	draw_line(@c3,@c4)
 # 		fillet_edges << 	draw_line(@c4, @c1)
 # 		@face = Sketchup.active_model.active_entities.add_face(fillet_edges)
 #
 # 		if @face
 # 			@face.erase!
 # 		else
 # 			puts "**********UNABLE TO REMOVE FILLET FACE?*********************"
 # 		end
 #
 # 	end
 # end
