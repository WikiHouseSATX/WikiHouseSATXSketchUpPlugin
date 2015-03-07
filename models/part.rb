class WikiHouse::Part
	def initialize(face)
		@face = face
		@sheet = Sheet.new
		@ripper = Ripper.new(@sheet)
		@joiner = Joiner.new(SJoint, @sheet)
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
		edge_divisor = @ripper.divide(max_length)
		unless edge_divisor
			return WikiHouse.error("Unable to divide that face into pieces that will fit. Please add an edge manually.")
		end
		puts "Edge Divisor is #{edge_divisor}"
		@joiner.make_joints!(edge_divisor, @face)
	end
end
