class JointLock
  def initialize(lock_on: nil)
    raise ArgumentError, "You must provide a lock edge" if !lock_on || !lock_on.respond_to?(:start)
    @lock_on = @lock_on
  end
  def draw!
    #
    # 	x = finish.x
    # 	y1 =  finish.y + (1 * one_third_height)
    # 	y2 =  finish.y + (2 * one_third_height)
    # 	#lock goes in here
    # 	# #lock
    # 	width_of_lock_slot_inches = total_height/2.0
    # 	thickness = @joiner.sheet.thickness
    # 	# #top Right
    # 	lx1 = finish.x + (width_of_lock_slot_inches/2.0)
    # 	ly1 = start.y - (total_height/2.0) + thickness/2.0
    # 	# #bottom left
    # 	lx2 = finish.x - (width_of_lock_slot_inches/2.0)
    # 	ly2 = ly1 - thickness
    # 	lc1, lc2, lc3, lc4 = build_box(lx1, ly1, lx2, ly2)
    # 	#Makes a cross
    # 	# Top
    # 	draw_line([x, y1,0], [x,ly2 ,0])
    # 	#lock
    #
    # 	draw_line([x, lc1.y,0], lc1 )
    # 	draw_line(lc2,lc3)
    # 	draw_line(lc3,lc4)
    # 	draw_line(lc4, [x, lc4.y,0])
    # 	# lock left
    # 	#Bottom
    # 	draw_line([x, ly1,0], [x, y2 ,0])
    # 	lock_face = Sketchup.active_model.active_entities.add_face([lc1, lc2, lc3, lc4])
    # 	lock_face.erase!
  end
end
