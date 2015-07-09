class WikiHouse::SlotConnector < WikiHouse::Connector


  def initialize(length_in_t: nil,
                 count: 1, width_in_t: nil, thickness: nil, sections: nil,
  fillet_off: false)
    @thickness = thickness ? thickness : WikiHouse.sheet.new.thickness
    @length_in_t = length_in_t ? length_in_t : self.class.standard_length_in_t
    @count = count
    @width_in_t = width_in_t ? width_in_t : self.class.standard_width_in_t
    @sections = sections
    @fillet_off = fillet_off
  end
  def slot?
    true
  end

  def name
    :slot
  end



  def fillet_off?
    @fillet_off ? true : false
  end

  def points(bounding_start: nil,
             bounding_end: nil,
             start_pt: nil,
             end_pt: nil,
             orientation: nil,
             starting_thickness: nil,
             total_length: nil)

    unless [:right, :left, :top, :bottom].include?(orientation)
      raise ArgumentError, "#{orientation} is not supported by this connector"
    end
    c5 = start_pt
    c6 = end_pt


    slot_width = width
    slot_count = count
    if orientation == :top && starting_thickness
      c5.x += starting_thickness
    elsif orientation == :bottom && starting_thickness
      c5.x -= starting_thickness
    end
    slot_points = [c5]


    section_gap = Sk.round((total_length - (slot_count * slot_width))/(slot_count.to_f + 1.0))

    slot_count.times do |i|
      starting_length = ((i + 1) * section_gap) + (i * slot_width) - starting_thickness
      if orientation == :right

        start_slot = c5.y - starting_length

        end_slot = start_slot - slot_width


        pc1 = [c5.x - length, start_slot, c5.z]
        pc2 = [c5.x, start_slot, c5.z]
        pc3 = [c5.x, end_slot, c5.z]
        pc4 = [c5.x - length, end_slot, c5.z]


      elsif orientation == :left

        start_slot = c5.y + starting_length
        end_slot = start_slot + slot_width


        pc4 = [c5.x, start_slot, c5.z]
        pc3 = [c5.x + length, start_slot, c5.z]
        pc2 = [pc3.x, end_slot, c5.z]
        pc1 = [c5.x, end_slot, c5.z]


      elsif orientation == :top

        start_slot = c5.x + starting_length

        end_slot = start_slot + slot_width


        pc4 = [start_slot, c5.y, c5.z]
        pc3 = [start_slot, c5.y - length, c5.z]
        pc2 = [end_slot, pc3.y, c5.z]
        pc1 = [end_slot, c5.y, c5.z]


      elsif orientation == :bottom

        start_slot = c5.x - starting_length
        end_slot = start_slot - slot_width


        pc1 = [start_slot, c5.y + length, c5.z]
        pc2 = [start_slot, c5.y, c5.z]
        pc3 = [end_slot, c5.y, c5.z]
        pc4 = [end_slot, c5.y + length, c5.z]
      end
      if orientation == :top || orientation == :left
        current_points = [pc4, pc3, pc2, pc1]
      else
        current_points = [pc2, pc1, pc4, pc3]
      end
      unless fillet_off?
        WikiHouse::DogBoneFillet.by_points(current_points, 0, 1, 2)
        WikiHouse::DogBoneFillet.by_points(current_points, 5, 4, 3, reverse_it: true)
      end
      slot_points.concat(current_points)

    end
    slot_points << c6


  end

end