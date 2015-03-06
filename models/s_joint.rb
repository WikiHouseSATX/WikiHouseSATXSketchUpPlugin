class SJoint < Joint
	include DrawingHelper
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
		#	draw_line(start, finish)
		set_total_height_from_line(start, finish, orientation)
		puts "Total Height #{total_height}"
		puts "Start #{start}"
		puts "Finish #{finish}"
		#71.45 degrees makes
		angle_degrees = 71.45
		one_third_height = total_height/3

		parallelogram_points = build_parallelogram_points(finish.x - (2 * one_third_height),
			start.y, total_height,
		total_height,angle_degrees)

		bottom_triangle_leg = one_third_height/Math.tan(SJoint.degrees_to_radians(angle_degrees))
		x1 = parallelogram_points[3].x
		y1 = parallelogram_points[3].y
		x2 = finish.x - (2 * one_third_height) + bottom_triangle_leg
		y2 = finish.y + (2 * one_third_height)

		line1 =	draw_line([x1, y1,0], [x2, y2 ,0])


		x1 = finish.x - (2 * one_third_height) + bottom_triangle_leg
		x2 = finish.x
		y =  finish.y + (2 * one_third_height)
		line2 =	draw_line([x1, y,0], [x2, y ,0])
		# Top left
		fillet = Fillet.new(fillet_on: line2,  fillet_off: line1, angle_in_degrees: angle_degrees)
		fillet.draw!


		x1 = finish.x
		x2 = parallelogram_points[2].x - bottom_triangle_leg
		y =  finish.y + (1 * one_third_height)
		line4 =	draw_line([x1, y,0], [x2, y ,0])
		line4_position = EdgePosition.from_edge(line4)

		line3 = draw_line(line2.end, line4.start)
		line3_position = EdgePosition.from_edge(line3)


		 fillet = Fillet.new(fillet_on: line2,  fillet_off: line3_position)
		fillet.draw!

		 fillet = Fillet.new(fillet_on: line4,  fillet_off: line3_position)
		 fillet.draw!

		puts "#{SJoint.edge_to_s()
		lock = JointLock.new(lock_on: line3_position)
		#line3.erase!
	#	lock.draw!


		x1 = parallelogram_points[2].x - bottom_triangle_leg
		y1 = finish.y + (1 * one_third_height)
		x2 = parallelogram_points[1].x
		y2 = parallelogram_points[1].y

		line5 =		draw_line([x1, y1,0], [x2, y2 ,0])

		fillet = Fillet.new(fillet_on: line4_position,  fillet_off: line5, angle_in_degrees: angle_degrees)
		fillet.draw!


		# Fuse them into the part
		# Turn into group
	end
end
