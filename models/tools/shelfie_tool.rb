class WikiHouse::Shelfie
  WikiHouse::Tools.register(:shelfie, self)

  def draw_it(x, y, view)


    wall = WikiHouse::Shelfie.new()
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
    tool = WikiHouse::Shelfie.new
    cmd = UI::Command.new("WikiHouse Shelfie") {

      Sketchup.active_model.select_tool(tool)

    }
    cmd.small_icon = WikiHouse.plugin_file("WikiHouse_logo_12.png", "images")
    cmd.large_icon = WikiHouse.plugin_file("WikiHouse_logo_24.png", "images")
    cmd.tooltip = "WikiHouse Shelfie"
    cmd.status_bar_text = "Auto Draws the shelfie"
    cmd.menu_text = "WikiHouse Shelfie"
    WikiHouse::Tools.add_to_toolbar(cmd)
    tool
  end

end
