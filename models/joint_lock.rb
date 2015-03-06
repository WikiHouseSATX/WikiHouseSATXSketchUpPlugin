class JointLock
	include DrawingHelper
	def initialize(lock_on: nil, joint: nil)
		raise ArgumentError, "You must provide a lock edge" if !lock_on || !lock_on.respond_to?(:start)
		raise ArgumentError, "You must provide a join" if !joint || !joint.respond_to?(:total_height)
		if lock_on.start.position.x == lock_on.end.position.x
			@orientation = :y
			if lock_on.start.position.y > lock_on.end.position.y
				@start = lock_on.end
				@end = lock_on.start
			else
				@start = lock_on.start
				@end = lock_on.end
			end
		elsif lock_on.end.position.y == lock_on.end.position.y
			@orientation = :x
			if lock_on.start.position.x > lock_on.end.position.x
				@start = lock_on.end
				@end = lock_on.start
			else
				@start = lock_on.start
				@end = lock_on.end
			end
		else
			raise ArgumentError, "Locks currently only support straight edges"
		end
		@lock_on = lock_on
		@joint = joint
	end
	def draw!

		width_of_lock_slot_inches = @joint.total_height/2.0
		thickness_inches = @joint.sheet.thickness
		if @orientation == :x
        raise ScriptError, "No Code"

		elsif @orientation == :y
			length = @lock_on.length

      @lock_on.erase!

			center  = [@start.position.x , @start.position.y + length/2.0, 0]
		#Reconnect Edges
    	draw_line(@start.position,[center.x ,
			center.y - thickness_inches/2.0, 0] )

      draw_line([center.x ,
      center.y + thickness_inches/2.0, 0], @end.position )

      c1 = [center.x - width_of_lock_slot_inches/2.0,
			center.y + thickness_inches/2.0, 0]
      c2 = [center.x + width_of_lock_slot_inches/2.0,
      center.y + thickness_inches/2.0, 0]
      c3 = [center.x + width_of_lock_slot_inches/2.0,
      center.y - thickness_inches/2.0, 0]
			c4 = [center.x - width_of_lock_slot_inches/2.0,
			center.y - thickness_inches/2.0, 0]
      line1 = draw_line(c1,c2)
      line2 = draw_line(c2,c3)
      line3 = draw_line(c3,c4)
      line4 = draw_line(c4,c1)

      	lock_face = Sketchup.active_model.active_entities.add_face([line1, line2, line3, line4])
       	lock_face.erase!
puts "****ILock************"
      fillet = Fillet.new(fillet_on: line2,
        fillet_off: line1)
      fillet.draw!
      fillet2 = Fillet.new(fillet_on: line3,
        fillet_off: line2)
      fillet2.draw!
      puts "****ILock************"
		end

	end
end
