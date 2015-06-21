# Nesting Process
# ==========================
# Find all the flat parts
# create a sheet for each part
# copy the part to each sheet
# press button to export sheets to individual svg files

#Ignore the inside.outside edge for the first draft

class WikiHouse::Nester
  class NestedPart
    include WikiHouse::PartHelper

    def initialize(sheet: nil, group: nil, origin: nil, label: nil)
      part_init(sheet: sheet, group: group, origin: origin, label: label)
    end
  end

  attr_reader :strategy

  def nest_group_name
    "WikiHouse::Nested"
  end

  def nest_layer_name
    "WikiHouse::NestedLayer"
  end

  def initialize(strategy: nil, starting_x: 300, staring_y: 300)
    @starting_x = starting_x
    @starting_y = staring_y
    @nest_group = nil
    @sheet = WikiHouse.sheet.new
    @sheets = []
    @strategy = strategy ? strategy : WikiHouse::SingleNesting.new
    Sk.find_or_create_layer(name: nest_layer_name)
  end

  def nest!(item)
    Sk.start_operation("Nesting Items", disable_ui: true)

    puts "Nesting #{item.name}"

    original_layer = Sk.current_active_layer
    Sk.make_layer_active_name(name: nest_layer_name)


    #draw a sheet
    c1 = [@last_x, @starting_y, 0]
    c2 = [@last_x + @sheet.length, @starting_y, 0]
    c3 = [@last_x + @sheet.length, @starting_y + @sheet.width, 0]
    c4 = [@last_x, @starting_y + @sheet.width, 0]
    lines = Sk.draw_all_points([c1, c2, c3, c4])

    #now copy the part over
    sheet_outline = Sk.add_group lines
    sheet_outline.name = "sheet outline"

    sheet_group = Sk.add_group
    Sk.nest_group(destination_group: sheet_group, source_group: sheet_outline)
    gcopy = Sk.copy_group(destination_group: sheet_group, source_group: item)
    gcopy.make_unique
    gcopy.entities.each { |e| e.layer = nest_layer_name}
    gcopy.name = item.name
    part = NestedPart.new(group: gcopy)
    x = @last_x

    part.move_to(point: [x, @starting_y, 0]).go!
    part.set_tag(tag_name: "group_source", value: item.name)
    part.set_tag(tag_name: "source", value: item.entityID)

    sheet_group.name = "Sheet ##{@sheets.count + 1}"
    @sheets << sheet_group
    @last_x += @sheet.length + 10
    Sk.make_layer_active(original_layer)
    Sk.commit_operation
  end

  def draw!
    @nest_group = nil


    Sk.active_entities.each do |top|
      if top.typename == "Group" && top.name == WikiHouse::Flattener.flat_group_name
        puts "Found the flat group #{top.entities.count}"
        @last_x = @starting_x

        top.entities.each do |e|
          puts "#{e.name} #{e.typename}"
          nest!(e)
        end
      end
    end
    unless @sheets.empty?
      puts "Creating Flat Group"
      @nest_group = Sk.add_group @sheets
      @nest_group.name = nest_group_name
    end
  end
end