class ButtJoint < Joint
	def join!(start, finish, orientation)
		Sketchup.active_model.entities.add_line(start, finish)
	end
end
