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
    #puts "Calling"
    keepers = [:DEV_MODE, :LOG_ON, :CURRENT_PLATFORM, :Tools, :Tool]
    konstants = self.constants
    keepers.each do |keep|
      konstants.reject! {|k| k.to_s.match(keep.to_s)}
    end

    #Object.send(:remove_const, :Foo)
    puts "Reloading Constants #{konstants}" if LOG_ON
    konstants.each {|k| self.send(:remove_const, k.to_sym)}
    Dir[ plugin_file("*.rb", "helpers")].each do |file|
      #puts file if LOG_ON
      load file
    end
    Dir[ plugin_file("*.rb", "overrides")].each do |file|
      #puts file if LOG_ON
      load file
    end
    #load plugin_file("joint.rb","models") #Other files depend on this
    load plugin_file("tools.rb","models") #Other files depend on this

    Dir[ plugin_file("*.rb", "models")].each do |file|
    #  puts file if LOG_ON
      load file unless ["tools.rb"].include? File.basename(file)
    end
    Tools.init_all
    @build_menus = false
  end


end
WikiHouse.init
