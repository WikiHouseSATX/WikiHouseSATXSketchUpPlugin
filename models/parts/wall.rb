class WikiHouse::Wall

  include WikiHouse::PartHelper


  def initialize(origin: nil, sheet: nil, label: nil)
    part_init(sheet: sheet, origin: origin)

    @left_column = WikiHouse::Column.new(label: "Left", origin: @origin, sheet: @sheet, wall_panels_on: [0, 1, 2, 3], parent_part: self)
    @wall_panel = WikiHouse::WallPanel.new(label: "Wall Panel", origin: [@origin.x + @left_column.width, @origin.y, @origin.y], sheet: @sheet, parent_part: self)
    @right_column = WikiHouse::Column.new(label: "Right", origin: [@origin.x + @left_column.width + @wall_panel.width, @origin.y, @origin.z], sheet: @sheet, parent_part: self)
    @left_column_zpegs = []
    @right_column_zpegs = []
    wall_panel_zpegs.times do |index|
      @left_column_zpegs << WikiHouse::DoubleZPeg.new(label: "LeftColumn #{index + 1}", origin: @origin, sheet: @sheet)
      @right_column_zpegs << WikiHouse::DoubleZPeg.new(label: "RightColumn #{index + 1}", origin: @origin, sheet: @sheet)
    end

  end

  def wall_height
    80
  end

  def wall_panel_zpegs
    3
  end

  def draw!
    Sk.find_or_create_layer(name: self.class.name)
    Sk.make_layer_active_name(name: self.class.name)
    @left_column.draw!
    @wall_panel.draw!
    @right_column.draw!

    #Draw in the Zpegs
    #move them into place

    groups = [@left_column.group, @wall_panel.group, @right_column.group].compact
    set_group(groups)
  end


end