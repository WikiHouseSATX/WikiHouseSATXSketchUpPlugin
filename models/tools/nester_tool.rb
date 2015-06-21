class WikiHouse::NesterTool
  WikiHouse::Tools.register(:nester, self)
  def activate
    puts 'Nester triggered'
    nester  = WikiHouse::Nester.new()
    nester.draw!
  end

  def deactivate(view)
    puts "Your tool has been deactivated in view: #{view}"
  end


  def self.init
    #puts "initializing the menu system"
    setup_toolbar if WikiHouse.build_menus?
  end

  def self.setup_toolbar
    tool = WikiHouse::NesterTool.new
    cmd = UI::Command.new("WikiHouse Nester") {

      Sketchup.active_model.select_tool(tool)

    }
    cmd.small_icon = WikiHouse.plugin_file("basket.png", "images")
    cmd.large_icon = WikiHouse.plugin_file("basket.png", "images")
    cmd.tooltip = "WikiHouse Nester"
    cmd.status_bar_text = "Takes flat pieces and nests them into sheets"
    cmd.menu_text = "WikiHouse Nester"
    WikiHouse::Tools.add_to_toolbar(cmd)
    tool
  end

end
