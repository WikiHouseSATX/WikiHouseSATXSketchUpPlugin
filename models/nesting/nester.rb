# Nesting Process
# ==========================
# Find all the flat parts
# create a sheet for each part
# copy the part to each sheet
# press button to export sheets to individual svg files
# Do a simple area calculation to decide if we should even try to fit it on the sheet
#Ignore the inside.outside edge for the first draft

#need a nestable part wrapper
# It needs to figure out the approx area - using the bounding box
# It should alo figur eout the actual area using the face.area
# The system should sort the parts by area from largest to smallest.
# The system should be able to confirm that it fits on a sheet at all - and stop if the part doesn't
# the system should be able to confirm that it hasn't collided with any other parts
# we need to be able to move the part on the sheet and be able to rotate it quickly (starting with 90 degree increments)
#The nest should be able to show how many sheets - and the use/waste for each sheet - as well as a total use/waste for the whole thing

class WikiHouse::Nester


  attr_reader :strategy, :outline_sheets

  def initialize(strategy: nil, starting_x: 0, starting_y: 300, outline_sheets: true)
    @starting_x = starting_x
    @starting_y = starting_y
    @nest_group = nil
    @sheet = WikiHouse.sheet.new
    @sheets = []
    @parts = []
    @outline_sheets
    @strategy = strategy ? strategy : WikiHouse::SingleNesting.new(outline_sheets: outline_sheets, starting_x: starting_x, starting_y: starting_y, sheet: @sheet)
   # @strategy = strategy ? strategy : WikiHouse::FirstFitDecreasingNesting.new(outline_sheets: outline_sheets,starting_x: starting_x, starting_y: starting_y, sheet: @sheet)
    Sk.find_or_create_layer(name: nest_layer_name)
  end

  def self.sheet_outline_group_name
    "Sheet Outline"
  end
  def self.nest_layer_name
    "WikiHouse::NestedLayer"
  end

  def self.nest_group_name
    "WikiHouse::Nested"
  end

  def self.erase!
    Sk.start_operation("Cleaning Up Parts", disable_ui: true)
    g = Sk.find_group_by_name(nest_group_name, match_ok: false)
    if g
      g.erase!
    end
    begin
      Sk.remove_layer(name: nest_layer_name, delete_geometry: true)
    rescue ArgumentError
      puts "unable to find that layer"
    end

    Sk.commit_operation
  end

  def nest_group_name
    self.class.nest_group_name
  end

  def nest_layer_name
    self.class.nest_layer_name
  end
  def save!
    #this needs to look at the group/layer
    #find all the sheets and trigger a save out to svg
  end

  def nest!
    Sk.active_entities.each do |top|
      if top.typename == "Group" && top.name == WikiHouse::Flattener.flat_group_name
        puts "Found the flat group #{top.entities.count}"

        Sk.start_operation("Building Nestable Parts", disable_ui: true)
        @nest_group = Sk.add_group
        @nest_group.name = nest_group_name
        top.entities.each do |e|
          #crate the nestable part
          @parts << build_nestable_part(e)

        end
        Sk.commit_operation
        Sk.start_operation("Nesting Items", disable_ui: true)

        original_layer = Sk.current_active_layer
        Sk.make_layer_active_name(name: nest_layer_name)

        strategy.nest!(parts: @parts, nest_group: @nest_group, nest_layer_name: nest_layer_name)
        Sk.make_layer_active(original_layer)
        Sk.commit_operation
      end
    end




  end

  def build_nestable_part(item)
    original_layer = Sk.current_active_layer
    Sk.make_layer_active_name(name: nest_layer_name)
    if Sk.is_a_group?(item)
      gcopy = Sk.copy_group(destination_group: @nest_group, source_group: item)
      gcopy.make_unique
      gcopy.entities.each { |e| e.layer = nest_layer_name }
    else

    gcopy = Sk.nest_component(destination_group: @nest_group, source_component: item, make_unique: true)


    gcopy.definition.entities.each { |e| e.layer = nest_layer_name }
    end


    gcopy.name = item.name
    part = WikiHouse::NestablePart.new(group: gcopy, origin: [0, 0, 0], label: item.name)
    part.move_to!(point: [0, 0, 0])


    Sk.make_layer_active(original_layer)
    part
  end

end