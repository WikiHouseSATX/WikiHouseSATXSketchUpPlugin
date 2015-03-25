class WikiHouse::SingleNesting
  def initialize(starting_x: 100, starting_y: 200)
    @starting_x = starting_x
    @starting_y = starting_y
    @sheets = []
    @nested_group = nil
  end

  def nest!(flat_group)
    puts "Single Nesting"
    last_x = @starting_x
    if !@nested_group
      @nested_group = Sk.add_group
      @nested_group.name = WikiHouse::Nester::LAYER_NAME

    end
    flat_group.entities.each do |e|
      if e.typename == "Group"
        puts "Found #{e.name}"
        #figure out if it fits on
        nested_sheet = Sk.add_group
        nested_sheet.name = "#{e.name} Sheet"
        origin = [last_x, @starting_y, 0]
        sheet = WikiHouse::Sheet.new(origin: origin, orientation: :vertical, flat: true)
        sheet.draw!

        sheet.set_layer(WikiHouse::Nester::LAYER_NAME)
        #nest the sheet
        gcopy = Sk.nest_group(destination_group: nested_sheet, source_group: sheet.group)
        sheet.group == gcopy
        #put the sheet into the nested group
        new_nested_sheet = Sk.nest_group(destination_group: @nested_group, source_group: nested_sheet)
        new_nested_sheet.name = "#{e.name} Sheet"

        @sheets << sheet
        last_x += sheet.width + 5
      end
    end
  end
end