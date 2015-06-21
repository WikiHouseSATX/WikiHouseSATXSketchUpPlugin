class WikiHouse::CurrentPartTool
  WikiHouse::Tools.register(:current_part, self)

  def draw_it(x, y, view)
    WikiHouse.init
    part = WikiHouse::Config.current_part
    part.draw!
  end

  def onLButtonDoubleClick(flags, x, y, view)

    draw_it(x, y, view)

  end

  def self.init
    #puts "initializing the menu system"
    setup_toolbar if WikiHouse.build_menus?
  end

  def self.setup_toolbar
    tool = WikiHouse::CurrentPartTool.new
    cmd = UI::Command.new("Current Part") {

      Sketchup.active_model.select_tool(tool)

    }
    cmd.small_icon = WikiHouse.plugin_file("puzzle.png", "images")
    cmd.large_icon = WikiHouse.plugin_file("puzzle.png", "images")
    cmd.tooltip = "Current Part"
    cmd.status_bar_text = "Auto Draws the current part"
    cmd.menu_text = "Current Part"
    WikiHouse::Tools.add_to_toolbar(cmd)
    tool
  end

end
