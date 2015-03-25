class WikiHouse::Nester
  LAYER_NAME = "WikiHouse::Nested"
  attr_reader :strategy

  def initialize(strategy: nil)
    @strategy = strategy ? strategy : WikiHouse::SingleNesting.new
    Sk.find_or_create_layer(name: LAYER_NAME)
  end
  def nest!
    #find  the flat group
    #if it doesn't exist - trigger a flattener
    puts "Nesting!"
    flat_group = Sk.find_group_by_name(WikiHouse::Flattener::LAYER_NAME)
    if !flat_group
      puts "Building flat group"
      flattener  = WikiHouse::Flattener.new()
      flattener.draw!
      flat_group = Sk.find_group_by_name(WikiHouse::Flattener::LAYER_NAME)
    end
    if flat_group
      puts "Nesting #{flat_group.name}"
      @strategy.nest!(flat_group)
    else
      raise ScriptError, "Unable to find or create flat versions needed for nesting"
    end
    #pass the group over to the strategy

  end
end