class SJoint < Joint
	# This class was based on the original S-Joint 3.4
	#  We made some changes
	# The parallelogram  had 77.5 and 102.5 as the angles - we changed it to 80/100 degrees
	# The width of the parallelogram  was slightly less than the  width of the baord - we made it the width of the baord


	def self.version
		3.5
	end

	def total_height
		@total_height
	end
	def set_total_height_from_line(start, finish, orientation)
		index = orientation == :y ? 0 : 1

		@total_height = (finish[index] - start[index]).abs
	end
	def size_ratio(measurement)
		ratio = measurement.to_f/MEASURED_HEIGHT
		total_height.to_f * ratio
	end
	def self.degrees_to_radians(degrees)
		degrees * Math::PI / 180
	end
	def build_parallelogram_points(x1,y1, b_length, h_length, x1_angle_in_degrees)
		c1 = [x1, y1,0]
		c2 = [x1 + b_length, y1,0]
		bottom_triangle_leg = h_length/Math.tan(SJoint.degrees_to_radians(x1_angle_in_degrees))
		puts "#{x1} #{b_length} #{h_length} #{bottom_triangle_leg}"
		if x1_angle_in_degrees > 90
			c3 = [x1 + b_length + - bottom_triangle_leg, y1 - h_length,0]

		else
			c3 = [x1 + b_length + bottom_triangle_leg, y1 - h_length,0]
		end


		c4 = [c3[0]  - b_length, c3[1],0]
		[c1, c2, c3, c4]
	end
  def draw_parallelogram(x1,y1, b_length, h_length, x1_angle_in_degrees, omit_sides = [])

	  points = build_parallelogram_points(x1,y1, b_length, h_length, x1_angle_in_degrees)
		c1 = points[0]
		c2 = points[1]
		c3 = points[2]
		c4 = points[3]
		edges = []
		edges << Sketchup.active_model.entities.add_line(c1, c2) unless omit_sides.include? :s1
		edges << Sketchup.active_model.entities.add_line(c2, c3) unless omit_sides.include? :s2
   	edges << Sketchup.active_model.entities.add_line(c3, c4) unless omit_sides.include? :s3
		edges << Sketchup.active_model.entities.add_line(c4,c1) unless omit_sides.include? :s4
		edges
	end
	def draw_triangle(x1,y1, x2, y2, x3, y3, omit_sides = [])
		p1 = [x1, y1, 0]
		p2 = [x2, y2, 0]
		p3 = [x3, y3, 0]
		edges  = []
		edges << Sketchup.active_model.entities.add_line(p1, p2)  unless omit_sides.include? :s1
		edges << Sketchup.active_model.entities.add_line(p2, p3) unless omit_sides.include? :s2
		edges << Sketchup.active_model.entities.add_line(p3, p1) unless omit_sides.include? :s3

		edges
	end
	def draw_box(top_right_x, top_right_y, bottom_left_x, bottom_left_y, omit_sides = [])

		c1 = [top_right_x,top_right_y,0]
		c2 = [top_right_x,bottom_left_y,0]
		c3 = [bottom_left_x, bottom_left_y,0]
		c4 = [bottom_left_x,top_right_y,0]
		edges = []
		edges << Sketchup.active_model.entities.add_line(c1, c2) unless omit_sides.include? :s1
		edges << Sketchup.active_model.entities.add_line(c2, c3) unless omit_sides.include? :s2
		edges << Sketchup.active_model.entities.add_line(c3, c4) unless omit_sides.include? :s3
		edges << Sketchup.active_model.entities.add_line(c4,c1) unless omit_sides.include? :s4
		edges
	end
	def join!(first_point, last_point, orientation)

		if first_point[1] < last_point[1]
			start = last_point
			finish = first_point
		else
			start = first_point
			finish = last_point
		end
		#start & finish is a straight line down the middle of the part.
		#need to add kind of joint
		puts "I'm an SJoint" if WikiHouse::LOG_ON
	#Mid point Line
	#	Sketchup.active_model.entities.add_line(start, finish)
		set_total_height_from_line(start, finish, orientation)
		puts "Total Height #{total_height}"
		puts "Start #{start}"
		puts "Finish #{finish}"
		#71.45 degrees makes
		angle_degrees = 71.45
		one_third_height = total_height/3
		# outer_parallelogram = draw_parallelogram(finish[0] - (2 * one_third_height),
		#  start[1], total_height,
		#  total_height,angle_degrees, [])
	parallelogram_points = build_parallelogram_points(finish[0] - (2 * one_third_height),
			start[1], total_height,
			total_height,angle_degrees)
    x1 = finish[0] - (2 * one_third_height)
		y1 = finish[1] + (1 * one_third_height)
		y2 = finish[1] + (2 * one_third_height)
		x2 = finish[0] + (2 * one_third_height)
	#	Sketchup.active_model.entities.add_line([x1, y1,0], [x2, y1 ,0])
	#	Sketchup.active_model.entities.add_line([x1, y2,0], [x2, y2,0])

		bottom_triangle_leg = one_third_height/Math.tan(SJoint.degrees_to_radians(angle_degrees))
		x1 = parallelogram_points[3][0]
		y1 = parallelogram_points[3][1]
		x2 = finish[0] - (2 * one_third_height) + bottom_triangle_leg
		y2 = finish[1] + (2 * one_third_height)

		Sketchup.active_model.entities.add_line([x1, y1,0], [x2, y2 ,0])


		x1 = finish[0] - (2 * one_third_height) + bottom_triangle_leg
		x2 = finish[0]
		y =  finish[1] + (2 * one_third_height)
		Sketchup.active_model.entities.add_line([x1, y,0], [x2, y ,0])
		x = finish[0]
		y1 =  finish[1] + (1 * one_third_height)
		y2 =  finish[1] + (2 * one_third_height)
		Sketchup.active_model.entities.add_line([x, y1,0], [x, y2 ,0])
		x1 = finish[0]
		x2 = parallelogram_points[2][0] - bottom_triangle_leg
		y =  finish[1] + (1 * one_third_height)
		Sketchup.active_model.entities.add_line([x1, y,0], [x2, y ,0])

		x1 = parallelogram_points[2][0] - bottom_triangle_leg
		y1 = finish[1] + (1 * one_third_height)
		x2 = parallelogram_points[1][0]
		y2 = parallelogram_points[1][1]
		Sketchup.active_model.entities.add_line([x1, y1,0], [x2, y2 ,0])


		# Left Side
		# Fuse them into the part
		# Turn into group
	end
end
