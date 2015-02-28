class SJoint < Joint
  def join!(start, finish)
    #start & finish is a straight line down the middle of the part.
    #need to add kind of joint
		Sketchup.active_model.entities.add_line(start, finish)
	end
end
