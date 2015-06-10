class WikiHouse::ZPeg
  WikiHouse::Tools.register(:z_peg, self)

  def draw_it(x, y, view)


 #   wall = WikiHouse::DoubleZPeg.new()
    wall = WikiHouse::DoubleUPeg.new()
    wall.draw!

  end

  def onLButtonDoubleClick(flags, x, y, view)

    draw_it(x, y, view)

  end

  def self.init
    #puts "initializing the menu system"
    setup_toolbar if WikiHouse.build_menus?
  end

  def self.setup_toolbar
    tool = WikiHouse::ZPeg.new
    cmd = UI::Command.new("WikiHouse ZPeg") {

      Sketchup.active_model.select_tool(tool)

    }
    cmd.small_icon = WikiHouse.plugin_file("WikiHouse_logo_12.png", "images")
    cmd.large_icon = WikiHouse.plugin_file("WikiHouse_logo_24.png", "images")
    cmd.tooltip = "WikiHouse ZPeg"
    cmd.status_bar_text = "Auto Draws the Zpeg"
    cmd.menu_text = "WikiHouse ZPeg"
    WikiHouse::Tools.add_to_toolbar(cmd)
    tool
  end

end
