class WikiHouse::WallPanel

  include WikiHouse::PartHelper

  def initialize(origin: nil, sheet: nil, label: nil)
    part_init(sheet: sheet, origin: origin)
  #has 2 caps, 4 faces, 6 ribs, 4 sides
  #  @top_cap = WikiHouse::WallPanelCap.new(label: "Top", origin: @origin, sheet: sheet, panel: self)
  #  @bottom_cap = WikiHouse::WallPanelCap.new(label: "Bottom", origin: [@origin.x + 12 , @origin.y, @origin.z ], sheet: sheet, panel: self)
  #  @left_outer_side = WikiHouse::WallPanelSide.new(label: "Left Outer", origin: @origin, sheet: sheet, panel: self)
    # @left_column = WikiHouse::Column.new(label: "Left", origin: @origin, sheet: sheet)
    # @right_column = WikiHouse::Column.new(label: "Right", origin: [@origin.x + 40, @origin.y + 40, @origin.z + 10], sheet: sheet)
  @ribs = []
    @ribs << WikiHouse::WallPanelRib.new(label: "Rib #1", origin: @origin, sheet: sheet, panel: self)

  end

  def panel_height
    80
  end
  def panel_width
    80
  end
  def panel_rib_width
    40
  end
  def panel_depth
    10
  end
  def tab_width
    5
  end
  def number_of_internal_supports
     3
  end
  def number_of_face_tabs
    2
  end

  def draw!
     Sk.find_or_create_layer(name: self.class.name)
     Sk.make_layer_active_name(name: self.class.name)
    # @top_cap.draw!
    #  @bottom_cap.draw!
    # set_group([@top_cap.group, @bottom_cap.group])

   # @left_outer_side.draw!
   # sef_group([@left_outer_side.group])
    @ribs.first.draw!
    set_group([@ribs.first.group])

  end


end