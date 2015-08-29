#Needs to create the Flat group at the top
#Add the ability to mark dowels through two components

class WikiHouse::Flattener
  @@dowel_x = 0
  @@flat_x = 0
  @@flat_group = nil
  @@plucked_group = nil
  include WikiHouse::AttributeHelper

  def initialize(starting_x: 0, starting_y: 400)
    @starting_x = starting_x
    @starting_y = starting_y
    @flat_group = nil
    @sheet = WikiHouse.sheet.new
    Sk.find_or_create_layer(name: outside_edge_layer_name)
    Sk.find_or_create_layer(name: inside_edge_layer_name)
    @components_flattened = []
  end

  def outside_edge_layer_name
    "WikiHouse::Flat::OutsideEdge"
  end

  def inside_edge_layer_name
    "WikiHouse::Flat::InsideEdge"
  end

  def self.flat_group_name
    "WikiHouse::Flat"
  end

  def self.plucked_group_name
    "WikiHouse::Plucked"
  end

  def self.apply_dowels
    unless Sk.selection.empty?

      x = @@flat_x
      Sk.selection.each do |sel|

        if !@@flat_group
          @@flat_group = Sk.find_or_create_global_group(name: flat_group_name)
          puts "Creating Flat Group"

        end
        begin
        gcopy = Sk.nest_component(destination_group: @@flat_group, source_component: sel,
                                  make_unique: true)
        rescue TypeError
          @@flat_group = Sk.find_or_create_global_group(name: flat_group_name)
          gcopy = Sk.nest_component(destination_group: @@flat_group, source_component: sel,
                                    make_unique: true)
        end

        gcopy.name = sel.name + " Copy"
      #  gcopy.definition.entities.each { |e| e.layer = outside_edge_layer_name }
        part = FlatPart.new(component: gcopy)

        real_x = x

        if Sk.flipped_x?(sel)
          puts "#{sel.name} is flipped on the x"
          move = part.flip_x

          real_x = (x + part.bounds.width) * -1
        end
        if Sk.flipped_y?(sel)
          puts "#{sel.name} is flipped on the y"
          move = part.flip_y
        #  y_mod = part.bounds.height
        end
        if Sk.flipped_z?(sel)
          puts "#{sel.name} is flipped on the z"
          move = part.flip_z
        end
        if move
          move.move_to(point: [0,0,0]).move_by(x: real_x, y: 400, z: 0).go!
        else
          part.move_to!(point: [x, 400, 0])
        end
        part.entities.each do |entity|
          if Sk.is_a_face?(entity)
            puts "Found a face"
           #   Sk.get_attribute(entity, WikiHouse::PartHelper.tag_dictionary, "primary_face")
         #   primary_face = entity
           # break
          end
        end
        x += part.bounds.width + 10
      end

    end
    @@flat_x = x
  end

  def self.pluck_part

    unless Sk.selection.empty?
      x = @@dowel_x
      Sk.selection.each do |sel|
        if !@@plucked_group
          @@plucked_group = Sk.find_or_create_global_group(name: plucked_group_name)
          puts "Creating Flat Group"

        end
        #
        # # return if @components_flattened.include?(component.definition.name)
        gcopy = Sk.nest_component(destination_group: @@plucked_group, source_component: sel, make_unique: false)

        gcopy.name = sel.name + " Copy"

        part = FlatPart.new(component: gcopy)


        part.move_to!(point: [x, 300, 0])
        x += part.bounds.width + 10
      end

    end
    @@dowel_x = x
  end

  def self.mark_selection_flattenable
    "Marking Flattenable"
    unless Sk.selection.empty?
      Sk.selection.each do |e|
        if is_groupish?(e)
          mark_flattenable!(e)
        end
      end
    end
  end

  def self.mark_selection_primary_face
    "Marking Primary Face"
    unless Sk.selection.empty?
      if Sk.selection.length != 1
        UI.messagebox("You can only mark one face at a time.")
        return
      end
      if Sk.is_a_face?(Sk.selection.first)
        mark_primary_face!(Sk.selection.first)
      else
        UI.messagebox("This can only be used on a face.")
      end

    end

  end

  def self.remove_selection_flattenable
    "Removing Flattenable"
    unless Sk.selection.empty?
      Sk.selection.each do |e|
        remove_flattenable!(e)
      end
    end
  end

  def self.remove_selection_primary_face
    "Removing Primary Face"
    unless Sk.selection.empty?
      Sk.selection.each do |e|
        remove_primary_face!(e)
      end
    end
  end

  def self.is_cutable?(item)
    v = item.get_attribute(WikiHouse::PartHelper.tag_dictionary, "cutable")
    v == true || v == "true"
  end

  def self.is_flattenable?(item)
    v = item.get_attribute(WikiHouse::PartHelper.tag_dictionary, "flattenable")
    v == true || v == "true"
  end

  def self.is_inside_edge?(item)
    item.get_attribute(WikiHouse::PartHelper.tag_dictionary, "inside_edge") == true
  end

  def self.is_groupish?(item)
    Sk.is_a_component_instance?(item) || Sk.is_a_group?(item)
  end

  def is_cutable?(item)
    self.class.is_cutable?(item)
  end

  def is_flattenable?(item)
    self.class.is_flattenable?(item)
  end

  def is_inside_edge?(item)
    self.class.is_inside_edge?(item)
  end

  def is_groupish?(item)
    self.class.is_groupish?(item)
  end

  def flat_group_name
    self.class.flat_group_name
  end

  def thickness
    @sheet.thickness
  end

  def median(array)
    sorted = array.sort
    len = sorted.length
    return (sorted[(len - 1) / 2] + sorted[len / 2]) / 2.0
  end

  def find_wiki_parent(entity)
    return entity if entity.name.match("Wiki")
    find_wiki_parent(entity.parent)
  end

  class FlatPart
    include WikiHouse::PartHelper

    def initialize(sheet: nil, component: nil, group: nil, origin: nil, label: nil)
      part_init(sheet: sheet, component: component, group: group, origin: origin, label: label)
    end
  end

  def flatten_component!(component)

    Sk.start_operation("Flattening Item", disable_ui: true)


    original_layer = Sk.current_active_layer
    Sk.make_layer_active_name(name: outside_edge_layer_name)
    puts "Flattening #{component.name} #{component.entityID}"
    if !@flat_group
      @flat_group = Sk.find_or_create_global_group(name: flat_group_name)
      puts "Creating Flat Group"
      @components_flattened = []
      @parts = []
      @last_x = @starting_x
    end

    # return if @components_flattened.include?(component.definition.name)
    gcopy = Sk.nest_component(destination_group: @flat_group, source_component: component, make_unique: true)
    @components_flattened << component.definition.name
    gcopy.name = component.name + " Copy"
    gcopy.definition.entities.each { |e| e.layer = outside_edge_layer_name }
    part = FlatPart.new(component: gcopy)


    x = @last_x + 3

    part.move_to!(point: [x, @starting_y, 0])


    box = [part.bounds.width, part.bounds.height, part.bounds.depth].reject { |i| i == thickness }
    # puts "Bounding box is  #{box}"

    if box == []
      width = thickness
    else
      width = box.first
    end
    x += width
    # puts "next x is #{x}"

    @last_x = x
    primary_face = nil
    part.entities.each do |entity|
      if Sk.is_a_face?(entity) &&
          Sk.get_attribute(entity, WikiHouse::PartHelper.tag_dictionary, "primary_face")
        primary_face = entity
        break
      end
    end
    if primary_face
      loop = primary_face.outer_loop
      primary_face.material = nil
      z_filter = primary_face.vertices.first.position.z #use this to filter out things not at the same level as the plane

      off_of_z = lambda do |entity|

        return false if !Sk.is_an_edge?(entity)
        return true if entity.start.position.z != z_filter || entity.end.position.z != z_filter
        return false
      end
      off_of_z_count = lambda do |list|
        list.find_all { |e| off_of_z.call(e) }.count
      end

      #need to loop until all stray edges are removed
      while off_of_z_count.call(part.entities) != 0
        part.entities.each do |entity|
          next if entity == primary_face
          erase = false
          if Sk.is_a_face?(entity)
            erase = true
          end
          if !entity.deleted? && Sk.is_an_edge?(entity)
            erase = true if off_of_z.call(entity)

          end
          entity.erase! if erase
        end
      end
      if primary_face.normal.z == -1
        #puts "Reversing #{primary_face.normal.z}"
        primary_face.reverse!
      end
      part.move_to!(point: [x, 200, -1 * z_filter])
    else
      puts "This part does not have a primary face :("
    end
    part.entities.each do |e|
      next if !e.valid? || e.deleted?
      if is_inside_edge?(e)
        #  puts "Found an inside edge"
        e.layer = inside_edge_layer_name
      end
    end
    part.set_tag(tag_name: "component_source", value: component.name)
    part.set_tag(tag_name: "flat", value: true)
    part.set_tag(tag_name: "source", value: component.entityID)
    @parts << part
    Sk.make_layer_active(original_layer)

    Sk.commit_operation


  end

  def flatten_group!(group)
    Sk.start_operation("Flattening Item", disable_ui: true)


    original_layer = Sk.current_active_layer
    Sk.make_layer_active_name(name: outside_edge_layer_name)
    puts "Flattening #{group.name} #{group.entityID}"
    if !@flat_group
      puts "Creating Flat Group"
      @flat_group = Sk.add_group
      @flat_group.name = flat_group_name
      @parts = []
      @last_x = @starting_x
    end

    gcopy = Sk.copy_group(destination_group: @flat_group, source_group: group)
    gcopy.make_unique
    gcopy.name = group.name + " Copy"
    gcopy.entities.each { |e| e.layer = outside_edge_layer_name }
    part = FlatPart.new(group: gcopy)


    x = @last_x + 3

    part.move_to!(point: [x, @starting_y, 0])


    box = [part.bounds.width, part.bounds.height, part.bounds.depth].reject { |i| i == thickness }
    if box == []
      width = thickness
    elsif box.first > 40
      width = box.last
    else
      width = box.first
    end
    x += width


    @last_x = x
    primary_face = nil
    part.entities.each do |entity|
      if Sk.is_a_face?(entity) &&
          Sk.get_attribute(entity, WikiHouse::PartHelper.tag_dictionary, "primary_face")
        primary_face = entity
        break
      end
    end
    if primary_face
      loop = primary_face.outer_loop
      primary_face.material = nil
      z_filter = primary_face.vertices.first.position.z #use this to filter out things not at the same level as the plane

      off_of_z = lambda do |entity|

        return false if !Sk.is_an_edge?(entity)
        return true if entity.start.position.z != z_filter || entity.end.position.z != z_filter
        return false
      end
      off_of_z_count = lambda do |list|
        list.find_all { |e| off_of_z.call(e) }.count
      end

      #need to loop until all stray edges are removed
      while off_of_z_count.call(part.entities) != 0
        part.entities.each do |entity|
          next if entity == primary_face
          erase = false
          if Sk.is_a_face?(entity)
            erase = true
          end
          if !entity.deleted? && Sk.is_an_edge?(entity)
            erase = true if off_of_z.call(entity)

          end
          entity.erase! if erase
        end
      end
      if primary_face.normal.z == -1
        #puts "Reversing #{primary_face.normal.z}"
        primary_face.reverse!
      end
      part.move_to!(point: [x, 200, -1 * z_filter])
    else
      puts "This part does not have a primary face :("
    end
    part.entities.each do |e|
      next if !e.valid? || e.deleted?
      if is_inside_edge?(e)
        #  puts "Found an inside edge"
        e.layer = inside_edge_layer_name
      end
    end
    part.set_tag(tag_name: "group_source", value: group.name)
    part.set_tag(tag_name: "flat", value: true)
    part.set_tag(tag_name: "source", value: group.entityID)
    @parts << part
    Sk.make_layer_active(original_layer)

    Sk.commit_operation


  end


  def crawl_group(item)
    item.entities.each do |subitem|

      if subitem.is_a?(Sketchup::Group)
        if is_cutable?(subitem) || is_flattenable?(subitem)
          flatten_group!(subitem)
        else
          crawl_group(subitem)
        end
      elsif Sk.is_a_component_instance?(subitem)
        if is_cutable?(subitem) || is_flattenable?(subitem)
          flatten_component!(subitem)
        else
          crawl_component(subitem)
        end
      end

    end
  end

  def crawl_component(item)
    item.definition.entities.each do |subitem|
      if subitem.is_a?(Sketchup::Group)
        if is_cutable?(subitem) || is_flattenable?(subitem)
          flatten_group!(subitem)
        else
          crawl_group(subitem)
        end
      elsif Sk.is_a_component_instance?(subitem)
        if is_cutable?(subitem) || is_flattenable?(subitem)
          flatten_component!(subitem)
        else
          crawl_component(subitem)
        end
      end

    end
  end

  def draw!
    puts "Flattening"
    @flat_group = nil

    Sk.entities.each do |top|

      if top.is_a?(Sketchup::Group)
        if is_cutable?(top) || is_flattenable?(top)
          flatten_group!(top)
        else
          crawl_group(top)
        end
      elsif Sk.is_a_component_instance?(top)
        if is_cutable?(top) || is_flattenable?(top)
          flatten_component!(top)
        else
          crawl_component(top)
        end
      end

    end
  end
end


#Find the master group - flattenable
#find the final component - that is cutable
# Copy over and make it orient correctly
# Find the primary face

# matching_faces=[]
# Sketchup.active_model.selection.each{|e|
#   if e.is_a?(Sketchup::Face)
#     ### check for compliance with some 'property' and then
#     matching_faces << e if match
#   elsif e.is_a?(Sketchup::Group)
#     e.entities.parent.entities.each{|face|
#       next unless face.is_a?(Sketchup::Face)
#       ### check for compliance with some 'property' and then
#       matching_faces << face if match
#     }
#   elsif e.is_a?(Sketchup::ComponentInstance)
#     e.parent.entities.each{|face|
#       next unless face.is_a?(Sketchup::Face)
#       ### check for compliance with some 'property' and then
#       matching_faces << face if match
#     }
#   end
# }