class ButtJoint < Joint
	def join!(start, finish)
		Sketchup.active_model.entities.add_line(start, finish)
	end
end
