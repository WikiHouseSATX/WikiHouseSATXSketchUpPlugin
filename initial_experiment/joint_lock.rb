class WikiHouse::JointLock
  include WikiHouse::DrawingHelper
  attr_reader :group

  def initialize(lock_on: nil, joint: nil, group: nil)
    raise ArgumentError, "You must provide a lock edge" if !lock_on || !lock_on.respond_to?(:start)
    raise ArgumentError, "You must provide a join" if !joint || !joint.respond_to?(:total_height)
    @group = group
    if lock_on.start.position.x == lock_on.end.position.x
      @orientation = :y
      if lock_on.start.position.y > lock_on.end.position.y
        @start = lock_on.end

      else
        @start = lock_on.start

      end

    elsif lock_on.end.position.y == lock_on.end.position.y
      @orientation = :x
      if lock_on.start.position.x > lock_on.end.position.x
        @start = lock_on.end

      else
        @start = lock_on.start

      end
    else
      raise ArgumentError, "Locks currently only support straight edges"
    end
    @end = lock_on.other_vertex(@start)
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

      center = [@start.position.x, @start.position.y + length/2.0, 0]
      #Reconnect Edges
      draw_line(@start.position, [center.x,
                                  center.y - thickness_inches/2.0, 0], group: @group)

      draw_line([center.x,
                 center.y + thickness_inches/2.0, 0], @end.position, group: @group)

      c1 = [center.x - width_of_lock_slot_inches/2.0,
            center.y + thickness_inches/2.0, 0]
      c2 = [center.x + width_of_lock_slot_inches/2.0,
            center.y + thickness_inches/2.0, 0]
      c3 = [center.x + width_of_lock_slot_inches/2.0,
            center.y - thickness_inches/2.0, 0]
      c4 = [center.x - width_of_lock_slot_inches/2.0,
            center.y - thickness_inches/2.0, 0]
      line1 = draw_line(c1, c2, group: @group)
      line2 = draw_line(c2, c3, group: @group)
      line3 = draw_line(c3, c4, group: @group)
      line4 = draw_line(c4, c1, group: @group)
      line1_position = WikiHouse::EdgePosition.from_edge(line1)
      line2_position = WikiHouse::EdgePosition.from_edge(line2)
      line3_position = WikiHouse::EdgePosition.from_edge(line3)
      line4_position = WikiHouse::EdgePosition.from_edge(line4)

      lock_face = Sketchup.active_model.active_entities.add_face([line1, line2, line3, line4])
      lock_face.erase!
      puts "****ILock************"
      fillet = WikiHouse::Fillet.new(fillet_on: line2_position,
                                     fillet_off: line1_position, group: @group)
      fillet.draw!
      fillet2 = WikiHouse::Fillet.new(fillet_on: line2_position,
                                      fillet_off: line3_position, group: @group)
      fillet2.draw!

      fillet3 = WikiHouse::Fillet.new(fillet_on: line4_position,
                                      fillet_off: line1_position, group: @group)
      fillet3.draw!
      fillet4 = WikiHouse::Fillet.new(fillet_on: line4_position,
                                      fillet_off: line3_position, group: @group)
      fillet4.draw!
      puts "****ILock************"
    end

  end
end
