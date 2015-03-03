class Tools
  def self.register(name, klass)
    @tools ||= {}
  #  puts "Registering Tool #{name} - #{klass}" if WikiHouse::LOG_ON
    @tools[name] = {:class => klass } unless @tools.has_key?(name)
  end

  def self.init_all
    @tools ||= {}
    @tools.keys.each do |name|
    #  puts "Init'ing Tool #{tool(name)[:class]}" if WikiHouse::LOG_ON
      tool(name)[:tool] = tool(name)[:class].init
    end
  end
  def self.tool(name)
    @tools ||= {}
    @tools[name]
  end
  def self.toolbar
    unless @toolbar
      @toolbar =  UI::Toolbar.new "WikiHouse"
    end
    @toolbar
  end
  def self.add_to_toolbar(cmd)
    @toolbar = toolbar.add_item cmd
    toolbar.show
    toolbar.restore
  end
end
