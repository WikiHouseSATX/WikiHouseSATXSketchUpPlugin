#Copyright 2015 WikiHouseSATX
#UI.messagebox('Core')
#Changes to this file require quiting SketchUp
module WikiHouse
  DEV_MODE = true
  LOG_ON = DEV_MODE
  CURRENT_PLATFORM = (Object::RUBY_PLATFORM =~ /mswin/i) ? :windows :
        ((Object::RUBY_PLATFORM =~ /darwin/i) ? :mac : :other) unless defined? CURRENT_PLATFORM

  def self.build_menus?
    @build_menus.nil? || @build_menus ? true : false
  end
  def self.reload
    SKETCHUP_CONSOLE.clear
    puts "Reloading Code"
   init

  end
  def self.error(msg)
    UI.messagebox(msg)
    return false
  end
  def self.plugin_file(filename, sub_directories = [])
    unless sub_directories.is_a? Array
      sub_directories = [sub_directories]
    end
    path_list = [File.dirname(__FILE__), sub_directories, filename].flatten!
    File.join(path_list)
  end
  def self.init
    puts "Calling"
    load plugin_file("joint.rb","models") #Other files depend on this
    Dir[ plugin_file("*.rb", "models")].each do |file|
      puts file if LOG_ON
      load file
    end
    setup_toolbar if WikiHouse.build_menus? && DEV_MODE
    TransformerTool.init

    @build_menus = false
  end
  def self.setup_toolbar
    toolbar = UI::Toolbar.new "WikiHouse"
    cmd = UI::Command.new("WikiHouse Reload") {
        WikiHouse.reload
    }
    cmd.small_icon = WikiHouse.plugin_file("reload.png","images")
    cmd.large_icon = WikiHouse.plugin_file("reload.png","images")
    cmd.tooltip = "WikiHouse Reload"
    cmd.status_bar_text = "Reload's Code"
    cmd.menu_text = "WikiHouse Reload"
    toolbar = toolbar.add_item cmd
    toolbar.show
    toolbar.restore
  end
end
WikiHouse.init
