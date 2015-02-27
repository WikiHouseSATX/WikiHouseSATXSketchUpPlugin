class Part
	def initialize(face)
		@face = face
		@sheet = Sheet.new
	end
	def wikize!
		unless @face.edges.count == 4
			return WikiHouse.error("The face you have chosen has #{@face.edges.count}, but this tool only support 4.")
		end
		edge_lengths = @face.edges.collect { |e| e.length}
		unless [1,2].include? edge_lengths.uniq.count
			return WikiHouse.error("It must be a rectangle #{edge_lengths.uniq}")
		end
		@face.edges.each do |edge|
			puts edge.length
		end
		unless face_fits_on_sheet?
			#  return WikiHouse.error("That part is too big to fit on a sheet.")
			add_fitable_edges
		end
	end
	def face_fits_on_sheet?
		@face.edges.each do |edge|
			return false unless @sheet.fits_on_sheet?(edge.length)
		end
		true
	end
	def add_fitable_edges
		max_length = @face.edges.collect { |e| e.length}.max
		min_length = @face.edges.collect { |e| e.length}.min
		puts "Max Length is #{max_length}" if WikiHouse::LOG_ON
		if @sheet.fits_on_sheet?(max_length)
      puts "Already fits" if WikiHouse::LOG_ON
			return
		end
		unless @sheet.fits_on_sheet?(min_length)
			return WikiHouse.error("Can only wikize in one dimension.  Please divide the part so either the width or lengths fits on a sheet.")
		end
		edge_divisor = nil
		(2..10).each do |divisor|
			possible_edge_length = max_length / divisor.to_f
			if @sheet.fits_on_sheet?(possible_edge_length)
				edge_divisor = divisor.to_f
				break
			end

		end
		unless edge_divisor
			return WikiHouse.error("Unable to divide that face into pieces that will fit. Please add an edge manually.")
		end
		puts "Edge Divisor is #{edge_divisor}"
		long_edges = @face.edges.collect {|e| e}.delete_if { |e| e.length < max_length}
		start_edge = long_edges.first
		end_edge = long_edges.last


		if (start_edge.end.position.x.to_inch - start_edge.start.position.x.to_inch).abs == max_length.to_inch
			puts "X is long"
      new_length = max_length.to_inch/edge_divisor.to_f.to_inch
      starting_x = start_edge.start.position.x.to_l < start_edge.end.position.x.to_l ? start_edge.start.position.x : start_edge.end.position.x
      (edge_divisor.to_i - 1).times do |index|

        new_start = [  ((index + 1) * new_length) + starting_x ,
          start_edge.start.position.y.to_inch,
          0]
        new_end = [    ((index + 1) * new_length) + starting_x ,
          end_edge.end.position.y.to_inch,
        0]

        Sketchup.active_model.entities.add_line(new_start, new_end)
      end
		else
			puts "Y is long"
      starting_y = start_edge.start.position.y.to_l < start_edge.end.position.y.to_l ? start_edge.start.position.y : start_edge.end.position.y

			new_length = max_length.to_inch/edge_divisor.to_f.to_inch
			(edge_divisor.to_i - 1).times do |index|

				new_start = [start_edge.start.position.x.to_inch,
					((index + 1) * new_length) + starting_y ,
				0]
				new_end = [  end_edge.end.position.x.to_inch,
					((index + 1) * new_length) + starting_y ,
				0]

      	Sketchup.active_model.entities.add_line(new_start, new_end)
			end
		end


	end
end
