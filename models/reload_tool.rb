class ReloadTool
  Tools.register(:reload, self)  if  WikiHouse::DEV_MODE
	def activate
	#	puts 'Your tool has been activated.'
	end
	def deactivate(view)
		#puts "Your tool has been deactivated in view: #{view}"
	end
	def self.init
		#puts "initializing the menu system"
		setup_toolbar if WikiHouse.build_menus?
	end
  def reload
    SKETCHUP_CONSOLE.clear
    puts "Reloading Code"   if  WikiHouse::DEV_MODE
    WikiHouse.init
  end
  def self.setup_toolbar
    tool = ReloadTool.new
    cmd = UI::Command.new("WikiHouse Reload") {
        tool.reload
    }
    cmd.small_icon = WikiHouse.plugin_file("reload.png","images")
    cmd.large_icon = WikiHouse.plugin_file("reload.png","images")
    cmd.tooltip = "WikiHouse Reload"
    cmd.status_bar_text = "Reload's Code"
    cmd.menu_text = "WikiHouse Reload"
    Tools.add_to_toolbar(cmd)
    tool
  end
end
