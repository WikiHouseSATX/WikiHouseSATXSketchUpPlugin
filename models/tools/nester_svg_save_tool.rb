class WikiHouse::NesterSvgSaveTool
  WikiHouse::Tools.register(:nester_svg_save, self)

  def activate
    puts "Activating Save"
    WikiHouse.init
    nester = WikiHouse::NesterSvgSave.new
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
    tool = WikiHouse::NesterSvgSaveTool.new
    cmd = UI::Command.new("WikiHouse Nester SVG Save") {

      Sketchup.active_model.select_tool(tool)

    }
    cmd.small_icon = WikiHouse.plugin_file("svg_save.png", "images")
    cmd.large_icon = WikiHouse.plugin_file("svg_save.png", "images")
    cmd.tooltip = "WikiHouse Nester SVG Save"
    cmd.status_bar_text = "This saves the sheets as svgs"
    cmd.menu_text = "WikiHouse Nester SVG Save"
    WikiHouse::Tools.add_to_toolbar(cmd)
    tool
  end

end
