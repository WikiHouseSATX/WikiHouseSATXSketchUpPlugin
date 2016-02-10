class WikiHouse::RisingBarn1020 < WikiHouse::RisingBarn

  def initialize(origin: nil, label: nil, parent_part: nil)
    @origin = origin
    @label = label
    @parent_part = parent_part

    super
    # @roof = SplitRoof.new(origin: @origin,
    #                  parent_part: self,
    #                  label: "#{@label} Roof")

    #
    @walls = []
   #  wall = Wall.new(origin: @origin,
   #                  parent_part: self,
   #                  width: scale(7.550),
   #                  length: scale(4.711),
   #                  label: "#{@label} North Wall")
   #
   # wall.add_roof_slant(slant_height: scale(1.258), slant_right: true)
   #  wall.add_window(at: [scale(5.677), scale(3.349), 0],
   #                  window_width: scale(1.022),
   #                  window_length: scale(1.193))
   #  @walls << wall
   #   @walls <<   Wall.new(origin: @origin,
   #                               parent_part: self,
   #                               width: scale(13.625),
   #                               length: scale(4.711),
   #                               label: "#{@label} East Wall")
   #  wall = Wall.new(origin: @origin,
   #                                parent_part: self,
   #                                width: scale(7.550),
   #                                length: scale(4.711),
   #                                label: "#{@label} South Wall")
   #
   #   wall.add_roof_slant(slant_height: scale(1.258), slant_right: true)
   #   @walls << wall
    # wall = Wall.new(origin: @origin,
    #                 parent_part: self,
    #                 width: scale(13.625),
    #                 length: scale(5.969),
    #                 label: "#{@label} West Wall")
    #
    # wall.add_window(at: [scale(2.469), scale(1.064), 0],
    #                 window_width: scale(2.186),
    #                 window_length: scale(3.549))
    # wall.add_door(at: [scale(6.614), 0, 0],
    #                 door_width: scale(6.301),
    #                 door_length: scale(4.542))
    # @walls << wall

    #Todo Roof Panel

    #Todo Roof Support
  end

  def width
    scale(14.363)
  end

  def length
    scale(7.654)
  end

  def height
    scale(13.625)
  end
end