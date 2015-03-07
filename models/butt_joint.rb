class WikiHouse::ButtJoint < Joint
	def join!(start, finish, orientation)
		draw_line(start, finish)
	end
end
