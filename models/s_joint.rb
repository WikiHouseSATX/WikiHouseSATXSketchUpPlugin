class SJoint < Joint
	# This class was based on the original S-Joint 3.4
	#  We made some changes
	# The parallelogram  had 77.5 and 102.5 as the angles - we changed it to 71.45 degrees
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


		c4 = [c3.x  - b_length, c3.y,0]
		[c1, c2, c3, c4]
	end
	def draw_parallelogram(x1,y1, b_length, h_length, x1_angle_in_degrees, omit_sides = [])

		c1,c2,c3,c4 = build_parallelogram_points(x1,y1, b_length, h_length, x1_angle_in_degrees)

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
	def build_box(top_right_x, top_right_y, bottom_left_x, bottom_left_y)
		c1 = [top_right_x,top_right_y,0]
		c2 = [top_right_x,bottom_left_y,0]
		c3 = [bottom_left_x, bottom_left_y,0]
		c4 = [bottom_left_x,top_right_y,0]
		[c1, c2, c3 ,c4]
	end
	def draw_box(top_right_x, top_right_y, bottom_left_x, bottom_left_y, omit_sides = [])

		c1, c2, c3, c4 = build_box(top_right_x, top_right_y, bottom_left_x, bottom_left_y)
		edges = []
		edges << Sketchup.active_model.entities.add_line(c1, c2) unless omit_sides.include? :s1
		edges << Sketchup.active_model.entities.add_line(c2, c3) unless omit_sides.include? :s2
		edges << Sketchup.active_model.entities.add_line(c3, c4) unless omit_sides.include? :s3
		edges << Sketchup.active_model.entities.add_line(c4,c1) unless omit_sides.include? :s4
		edges
	end
	def join!(first_point, last_point, orientation)

		if first_point.y < last_point.y
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
		# outer_parallelogram = draw_parallelogram(finish.x - (2 * one_third_height),
		#  start.y, total_height,
		#  total_height,angle_degrees, [])
		parallelogram_points = build_parallelogram_points(finish.x - (2 * one_third_height),
			start.y, total_height,
		total_height,angle_degrees)
		x1 = finish.x - (2 * one_third_height)
		y1 = finish.y + (1 * one_third_height)
		y2 = finish.y + (2 * one_third_height)
		x2 = finish.x + (2 * one_third_height)
		#	Sketchup.active_model.entities.add_line([x1, y1,0], [x2, y1 ,0])
		#	Sketchup.active_model.entities.add_line([x1, y2,0], [x2, y2,0])

		bottom_triangle_leg = one_third_height/Math.tan(SJoint.degrees_to_radians(angle_degrees))
		x1 = parallelogram_points[3].x
		y1 = parallelogram_points[3].y
		x2 = finish.x - (2 * one_third_height) + bottom_triangle_leg
		y2 = finish.y + (2 * one_third_height)

		Sketchup.active_model.entities.add_line([x1, y1,0], [x2, y2 ,0])


		x1 = finish.x - (2 * one_third_height) + bottom_triangle_leg
		x2 = finish.x
		y =  finish.y + (2 * one_third_height)
		Sketchup.active_model.entities.add_line([x1, y,0], [x2, y ,0])

		x = finish.x
		y1 =  finish.y + (1 * one_third_height)
		y2 =  finish.y + (2 * one_third_height)
		#lock goes in here
		# #lock
		width_of_lock_slot_inches = total_height/2.0
		thickness = @joiner.sheet.thickness
		# #top Right
		lx1 = finish.x + (width_of_lock_slot_inches/2.0)
		ly1 = start.y - (total_height/2.0) + thickness/2.0
		# #bottom left
		lx2 = finish.x - (width_of_lock_slot_inches/2.0)
		ly2 = ly1 - thickness
		lc1, lc2, lc3, lc4 = build_box(lx1, ly1, lx2, ly2)
		#Makes a cross
		# Top
		Sketchup.active_model.entities.add_line([x, y1,0], [x,ly2 ,0])
		#lock

		Sketchup.active_model.entities.add_line([x, lc1.y,0], lc1 )
		Sketchup.active_model.entities.add_line(lc2,lc3)
		Sketchup.active_model.entities.add_line(lc3,lc4)
		Sketchup.active_model.entities.add_line(lc4, [x, lc4.y,0])
		# lock left
		#Bottom
		Sketchup.active_model.entities.add_line([x, ly1,0], [x, y2 ,0])
		lock_face = Sketchup.active_model.active_entities.add_face([lc1, lc2, lc3, lc4])
		lock_face.erase!
		x1 = finish.x
		x2 = parallelogram_points[2].x - bottom_triangle_leg
		y =  finish.y + (1 * one_third_height)
		Sketchup.active_model.entities.add_line([x1, y,0], [x2, y ,0])

		x1 = parallelogram_points[2].x - bottom_triangle_leg
		y1 = finish.y + (1 * one_third_height)
		x2 = parallelogram_points[1].x
		y2 = parallelogram_points[1].y
		Sketchup.active_model.entities.add_line([x1, y1,0], [x2, y2 ,0])
		#


		# Fuse them into the part
		# Turn into group
	end
end
