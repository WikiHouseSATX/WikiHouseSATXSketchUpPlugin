class SJoint < Joint
	# Legth Joint is Wood T1
	#                          Wood T2 B4 Wood
	#                          Wood  B3 B2 B1
	# Right sjoint is B1 B2 B3 T1Wood
	#                           Wood B4                   Wood
	#                           T2 Wood
	# I measured the model in sketchup and use those measurements to make
	# the ratios
	# total_HEIGHT = 22 13/16  22.8125
	#          Width X height
	# b1 = 7 11/16 X  7 5/8  7.6875 x  7.625

	# b2 = 3 3/4 X 7 5/8  3.75 x 7.625

	# b3 = 8 x 7 5/8  =  8 x 7.625

	# b4 = 8 x 7 11/16  8 x 7.625

	# triangle1 = 3 1/2 x 15 5/16  3.5 x 15.3125
	MEASURED_HEIGHT = 22.8125  unless defined? MEASURED_HEIGHT
	MEASURED_B1_WIDTH = 7.6875  unless defined? MEASURED_B1_WIDTH
	MEASURED_B1_HEIGHT = 7.625  unless defined? MEASURED_B1_HEIGHT
	MEASURED_B2_WIDTH = 3.75 unless defined? MEASURED_B2_WIDTH
	MEASURED_B3_WIDTH = 8 unless defined? MEASURED_B3_WIDTH
	MEASURED_B4_HEIGHT = 7.625 unless defined? MEASURED_B4_HEIGHT
	MEASURED_T1_WIDTH = 3.5 unless defined? MEASURED_T1_WIDTH
	MEASURED_T1_HEIGHT = 15.3125 unless defined? MEASURED_T1_HEIGHT
	def total_height
		@total_height
	end
	def set_total_height_from_line(start, finish, orientation)
		index = orientation == :y ? 0 : 1

		@total_height = finish[index] - start[index]
	end
	def size_ratio(measurement)
		ratio = measurement.to_f/MEASURED_HEIGHT
		total_height.to_f * ratio
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
	def join!(start, finish, orientation)
		#start & finish is a straight line down the middle of the part.
		#need to add kind of joint
		puts "I'm an SJoint" if WikiHouse::LOG_ON
		Sketchup.active_model.entities.add_line(start, finish)
		set_total_height_from_line(start, finish, orientation)
		puts "Total Height #{total_height}"
		b1_width = size_ratio(MEASURED_B1_WIDTH)
		b1_height = size_ratio(MEASURED_B1_HEIGHT)
		b2_width = size_ratio(MEASURED_B2_WIDTH)
		b2_height = size_ratio(MEASURED_B1_HEIGHT)
		b3_width = size_ratio(MEASURED_B3_WIDTH)
		b3_height = size_ratio(MEASURED_B1_HEIGHT)
		b4_width =  size_ratio(MEASURED_B3_WIDTH)
		b4_height = size_ratio(MEASURED_B4_HEIGHT)
		t1_width = size_ratio(MEASURED_T1_WIDTH)
		t1_height = size_ratio(MEASURED_T1_HEIGHT)
		t2_width = size_ratio(MEASURED_T1_WIDTH)
		t2_height = size_ratio(MEASURED_T1_HEIGHT)

		# Draw the Shapes onto the part
		# Right side
		#b2
		b2 = draw_box(finish[0],finish[1],
		finish[0] - b2_width, finish[1] - b2_height,[:s1,:s2, :s3] )
		b1 = draw_box( finish[0] - b2_width, finish[1],
		finish[0] - b2_width - b1_width, finish[1] - b1_height ,[:s1,:s2, :s3] )
		b3 = draw_box(finish[0] + b3_width ,finish[1],
		finish[0] , finish[1] - b3_height ,[:s1,:s2, :s3, :s4] )
		b4 = draw_box(finish[0] + b3_width ,finish[1] - b3_height,
		finish[0] , finish[1] - b3_height - b4_height ,[:s1,:s2, :s3, :s4])
		t1 = draw_triangle( finish[0] + b3_width ,finish[1],
			finish[0] + b3_width, finish[1] - t1_height,
			finish[0] + b3_width + t1_width, finish[1] - t1_height,[:s1,:s2, :s3]
		)
		t2 = draw_triangle( 	finish[0] - b2_width - b1_width, finish[1] - b1_height,
			finish[0] - b2_width - b1_width, finish[1] - b1_height - t2_height,
			finish[0] - b2_width - b1_width + t2_width, finish[1] - b1_height - t2_height,
		[:s1, :s2, :s3]	)
		# Left Side
		# Fuse them into the part
		# Turn into group
	end
end
