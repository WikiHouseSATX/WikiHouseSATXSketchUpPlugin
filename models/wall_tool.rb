class WikiHouse::WallTool
  WikiHouse::Tools.register(:wall, self)
  def activate
    #	puts 'Your tool has been activated.'
  end

  def deactivate(view)
    #puts "Your tool has been deactivated in view: #{view}"
  end

  def draw_it(x, y, view)


      wall = WikiHouse::Wall.new()
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
    tool = WikiHouse::WallTool.new
    cmd = UI::Command.new("WikiHouse Wall") {

      Sketchup.active_model.select_tool(tool)

    }
    cmd.small_icon = WikiHouse.plugin_file("WikiHouse_logo_12.png", "images")
    cmd.large_icon = WikiHouse.plugin_file("WikiHouse_logo_24.png", "images")
    cmd.tooltip = "WikiHouse Wall"
    cmd.status_bar_text = "Auto Draws the wall"
    cmd.menu_text = "WikiHouse Wall"
    WikiHouse::Tools.add_to_toolbar(cmd)
    tool
  end

end
