class WikiHouse::WallPanelFace

  include WikiHouse::PartHelper


  def initialize(panel: nil, sheet: nil, group: nil, origin: nil, label: label)
    part_init(origin: origin, sheet: sheet, label: label)
    @panel = panel ? panel : raise(ArgumentError, "You must provide a WallPanel")
  end




  def draw!
    # Sk.find_or_create_layer(name: self.class.name)
    # Sk.make_layer_active_name(name: self.class.name)
    # @left_column.draw!
    # @right_column.draw!
    #
    # #set_group([@left_column.group])
    # set_group([@left_column.group, @right_column.group])


  end


end