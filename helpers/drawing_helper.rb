module DrawingHelper
	def self.included(base)
		base.extend(ClassMethods)
	end
	module ClassMethods
		def degrees_to_radians(degrees)
			degrees * Math::PI / 180
		end
    def vertex_to_s(vertex)
      "#{vertex.x} #{vertex.y} #{vertex.z}"
    end
    def edge_to_s(edge)
     "Edge: start #{vertex_to_s(edge.start.position)} end #{vertex_to_s(edge.end.position)}"
    end
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
		edges << draw_line(c1, c2) unless omit_sides.include? :s1
		edges << draw_line(c2, c3) unless omit_sides.include? :s2
		edges << draw_line(c3, c4) unless omit_sides.include? :s3
		edges << draw_line(c4,c1) unless omit_sides.include? :s4
		edges
	end
	def draw_triangle(x1,y1, x2, y2, x3, y3, omit_sides = [])
		p1 = [x1, y1, 0]
		p2 = [x2, y2, 0]
		p3 = [x3, y3, 0]
		edges  = []
		edges << draw_line(p1, p2)  unless omit_sides.include? :s1
		edges << draw_line(p2, p3) unless omit_sides.include? :s2
		edges << draw_line(p3, p1) unless omit_sides.include? :s3

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
		edges << draw_line(c1, c2) unless omit_sides.include? :s1
		edges << draw_line(c2, c3) unless omit_sides.include? :s2
		edges << draw_line(c3, c4) unless omit_sides.include? :s3
		edges << draw_line(c4,c1) unless omit_sides.include? :s4
		edges
	end
	def draw_line(pt1, pt2)
		Sketchup.active_model.entities.add_line(pt1, pt2)
	end
	end
