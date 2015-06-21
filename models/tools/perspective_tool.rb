class WikiHouse::PerspectiveTool
  WikiHouse::Tools.register(:perspective, self)
  def activate

    	puts 'Your tool has been activated.'
      camera =  Sketchup.active_model.active_view.camera
    if camera.perspective?
      camera.perspective = false
      group = Sk.find_group_by_name("Flat", match_ok: true)
      eye = [180,140,250] #This needs to be calculated some how
      target = group ? group.bounds.center : [0,0,0]
      #eye = [target ]
      up = [0.0, 1.0, 0.0]
      # We just set it to exactly what it was pointing at in the first place
      camera.set eye, target, up
      puts "Up #{camera.up} "
      puts "Eye #{camera.eye}"
      puts "Target #{camera.target}"
      puts "Turning off perspective"
    else
      camera.perspective = true
      puts "Turning perspective back on"
    end
  end

  def deactivate(view)
    puts "Your tool has been deactivated in view: #{view}"
  end


  def self.init
    #puts "initializing the menu system"
    setup_toolbar if WikiHouse.build_menus?
  end

  def self.setup_toolbar
    tool = WikiHouse::PerspectiveTool.new
    cmd = UI::Command.new("WikiHouse Perspective") {

      Sketchup.active_model.select_tool(tool)

    }
    cmd.small_icon = WikiHouse.plugin_file("eye.png", "images")
    cmd.large_icon = WikiHouse.plugin_file("eye.png", "images")
    cmd.tooltip = "WikiHouse Perspective"
    cmd.status_bar_text = "Changes the perspective so you can export at 1 to 1"
    cmd.menu_text = "WikiHouse Perspective"
    WikiHouse::Tools.add_to_toolbar(cmd)
    tool
  end

end
