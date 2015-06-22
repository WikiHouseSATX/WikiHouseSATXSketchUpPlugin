class WikiHouse::NesterSaveTool
  WikiHouse::Tools.register(:nester_save, self)
  def activate
    nester  = WikiHouse::Nester.new()
    nester.save!
  end

  def deactivate(view)
    #puts "Your tool has been deactivated in view: #{view}"
  end


  def self.init
    #puts "initializing the menu system"
    setup_toolbar if WikiHouse.build_menus?
  end

  def self.setup_toolbar
    tool = WikiHouse::NesterSaveTool.new
    cmd = UI::Command.new("WikiHouse Nester Save") {

      Sketchup.active_model.select_tool(tool)

    }
    cmd.small_icon = WikiHouse.plugin_file("svg_save.png", "images")
    cmd.large_icon = WikiHouse.plugin_file("svg_save.png", "images")
    cmd.tooltip = "WikiHouse Nester Save"
    cmd.status_bar_text = "This saves the sheets as svgs"
    cmd.menu_text = "WikiHouse Nester Save"
    WikiHouse::Tools.add_to_toolbar(cmd)
    tool
  end

end
