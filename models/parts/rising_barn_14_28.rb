class WikiHouse::RisingBarn1428 < WikiHouse::RisingBarn

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
    wall = Wall.new(origin: @origin,
                    parent_part: self,
                    width: length,
                    length: scale(5.0525),
                    label: "#{@label} North Wall")


     wall.add_window(at: [scale(5.677), scale(2.156), 0],
                     window_width: scale(1.022),
                     window_length: scale(1.193))
  #  @walls << wall
    wall_width = width - scale(2 * 0.369)
    wall = Wall.new(origin: @origin,
                                 parent_part: self,
                                 width: wall_width,
                                 length: scale(5.0525),
                                 label: "#{@label} East Wall")
    wall.add_door(at: [((wall_width - scale(3.7468))/2.0) - scale(4.0874)/2.0, 0, 0],
        door_width: scale(4.0874),
                    door_length: scale(4.542))
 #   @walls << wall
    wall = Wall.new(origin: @origin,
                    parent_part: self,
                    width: length,
                    length: scale(5.0441),
                    label: "#{@label} South Wall")



    wall.add_roof_slant(slant_height: scale(2.0437), slant_right: false)
    wall.add_door(at: [scale(0.6356), 0, 0],
                  door_width: scale(4.0874),
                  door_length: scale(4.542))
   # @walls << wall
    wall = Wall.new(origin: @origin,
                    parent_part: self,
                    width: width - scale(2 * 0.369),
                    length: scale(5.0525),
                    label: "#{@label} West Wall")
    wall.add_roof_slant(slant_height: scale(2.053), slant_right: true)
    wall.add_door(at: [scale(3.9877), 0, 0],
                    door_width: scale(2.0437),
                    door_length: scale(4.542))
    wall.add_door(at: [scale(15.9508 + 0.369), 0, 0],
                  door_width: scale(2.0437),
                  door_length: scale(4.542))
    @walls << wall

    #Todo Roof Panel

    #Todo Roof Support
  end

  def width
    scale(19.075 + 2.0 * 0.369)
  end

  def length
    scale(9.537 + 2.0 * 0.369)
  end

  def height
    scale(5.0441)
  end
end