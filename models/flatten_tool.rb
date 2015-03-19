class WikiHouse::FlattenTool
  WikiHouse::Tools.register(:flatten, self)
  def activate
    #	puts 'Your tool has been activated.'
    flattener  = WikiHouse::Flattener.new()
    flattener.draw!
  end

  def deactivate(view)
    #puts "Your tool has been deactivated in view: #{view}"
  end


  def self.init
    #puts "initializing the menu system"
    setup_toolbar if WikiHouse.build_menus?
  end

  def self.setup_toolbar
    tool = WikiHouse::FlattenTool.new
    cmd = UI::Command.new("WikiHouse Flattener") {

      Sketchup.active_model.select_tool(tool)

    }
    cmd.small_icon = WikiHouse.plugin_file("WikiHouse_logo_12.png", "images")
    cmd.large_icon = WikiHouse.plugin_file("WikiHouse_logo_24.png", "images")
    cmd.tooltip = "WikiHouse Flattener"
    cmd.status_bar_text = "Finds all parts and makes them flat"
    cmd.menu_text = "WikiHouse Flattener"
    WikiHouse::Tools.add_to_toolbar(cmd)
    tool
  end

end
