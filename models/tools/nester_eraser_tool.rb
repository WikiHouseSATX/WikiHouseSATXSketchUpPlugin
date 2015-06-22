class WikiHouse::NesterEraserTool
  WikiHouse::Tools.register(:nester_eraser, self)
  def activate
    WikiHouse::Nester.erase!
  end

  def deactivate(view)
    #puts "Your tool has been deactivated in view: #{view}"
  end


  def self.init
    #puts "initializing the menu system"
    setup_toolbar if WikiHouse.build_menus?
  end

  def self.setup_toolbar
    tool = WikiHouse::NesterEraserTool.new
    cmd = UI::Command.new("WikiHouse Nester Eraser") {

      Sketchup.active_model.select_tool(tool)

    }
    cmd.small_icon = WikiHouse.plugin_file("eraser.png", "images")
    cmd.large_icon = WikiHouse.plugin_file("eraser.png", "images")
    cmd.tooltip = "WikiHouse Nester ERaser"
    cmd.status_bar_text = "This erases all the nested itmes"
    cmd.menu_text = "WikiHouse Nester Eraser"
    WikiHouse::Tools.add_to_toolbar(cmd)
    tool
  end

end
