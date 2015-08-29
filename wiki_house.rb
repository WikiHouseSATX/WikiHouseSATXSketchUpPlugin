#Copyright 2015 WikiHouseSATX, Dirk Elmendorf
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

  def self.machine
    WikiHouse::Config.machine
  end

  def self.sheet

    WikiHouse::Config.sheet
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
    # puts File.join(path_list) if LOG_ON
    File.join(path_list)
  end

  def self.init
    #puts "Calling"
    keepers = [:DEV_MODE, :LOG_ON, :CURRENT_PLATFORM, :Tools, :Tool]
    konstants = self.constants
    keepers.each do |keep|
      konstants.reject! { |k| k.to_s.match(keep.to_s) }
    end


    puts "Reloading Constants #{konstants}" if LOG_ON
    konstants.each { |k| self.send(:remove_const, k.to_sym) }
    Dir[plugin_file("*.rb", "helpers")].each do |file|
      #puts file if LOG_ON
      load file
    end
    Dir[plugin_file("*.rb", "overrides")].each do |file|
      #puts file if LOG_ON
      load file
    end
    base_files = []
    base_classes = [["connector.rb", "connectors"],
                    ["pocket_connector.rb", "connectors"],
                    ["tab_connector.rb", "connectors"],
                    ["machine.rb", "machines"],
                    ["sheet.rb", "sheets"],
                    ["imperial_plywood_3_4_sheet.rb", "sheets"],
                    ["tools.rb", "tools"],
                    ["wall_panel.rb", "parts"],
                    ["wall_panel_outer_side.rb", "parts"]]
    base_classes.each do |item|
      load plugin_file(item[0], ["models", item[1]]) #Other files depend on this
      base_files << item[0]
    end


    Dir[plugin_file("*.rb", ["models", "**"])].each do |file|
      #puts file if LOG_ON
      load file unless base_files.include? File.basename(file)
    end

    load plugin_file("WorkPlane.rb" ,"plane_tools")
    load plugin_file("FlattenToPlane.rb" ,"plane_tools")
    Tools.init_all
    @build_menus = false
  end


end
WikiHouse.init
