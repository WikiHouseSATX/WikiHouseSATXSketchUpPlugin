class WikiHouse::Flattener


  def initialize(starting_x: 100, starting_y: 100)
    @starting_x = starting_x
    @starting_y = starting_y
    @flat_group = nil
    @sheet = WikiHouse::Sheet.new
    Sk.find_or_create_layer(name: outside_edge_layer_name)
    Sk.find_or_create_layer(name: inside_edge_layer_name)

  end

  def outside_edge_layer_name
    "WikiHouse::Flat::OutsideEdge"
  end

  def inside_edge_layer_name
    "WikiHouse::Flat::InsideEdge"
  end

  def flat_group_name
    "WikiHouse::Flat"
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

    def initialize(sheet: nil, group: nil, origin: nil, label: nil)
      part_init(sheet: sheet, group: group, origin: origin, label: label)
    end
  end

  def flatten!(group)
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


    x = @last_x - 3

    part.move_to!(point: [ x, @starting_y, 0])


      box = [part.bounds.width, part.bounds.height, part.bounds.depth ].reject {|i| i ==  thickness}
      if box == []
        width = thickness
      elsif box.first > 40
        width = box.last
      else
        width = box.first
      end
      x -= width



    @last_x = x
    primary_face = nil
    part.group.entities.each do |entity|
      if entity.typename == "Face" &&
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

        return false if entity.typename != "Edge"
        return true if entity.start.position.z != z_filter || entity.end.position.z != z_filter
        return false
      end
      off_of_z_count = lambda do |list|
        list.find_all { |e| off_of_z.call(e) }.count
      end

      #need to loop until all stray edges are removed
      while off_of_z_count.call(part.group.entities) != 0
        part.group.entities.each do |entity|
          next if entity == primary_face
          erase = false
          if entity.typename == "Face"
            erase = true
          end
          if !entity.deleted? && entity.typename == "Edge"
            erase = true if off_of_z.call(entity)

          end
          entity.erase! if erase
        end
      end
      if primary_face.normal.z == -1
        #puts "Reversing #{primary_face.normal.z}"
        primary_face.reverse!
      end
      part.move_to!(point: [x, 100, -1 * z_filter])
    else
      puts "This part does not have a primary face :("
    end
    part.group.entities.each do |e|
      next if !e.valid? || e.deleted?
      if  is_inside_edge?(e)
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

  def is_cutable?(item)
    item.get_attribute(WikiHouse::PartHelper.tag_dictionary, "cutable") == true
  end
  def is_inside_edge?(item)
    item.get_attribute(WikiHouse::PartHelper.tag_dictionary, "inside_edge") == true
  end


  def crawl(item)
    return unless item.respond_to?(:entities)
    item.entities.each do |subitem|

      if is_cutable?(subitem)
        flatten!(subitem)

      end
      if subitem.typename == "Group" && subitem.name.match("Wiki")
        crawl(subitem)
      end
    end
  end

  def draw!
    @flat_group = nil

    Sk.active_entities.each do |top|
      if is_cutable?(top)
        flatten!(top)
      end
      if top.typename == "Group" && top.name.match("Wiki")
        # puts top.name
        crawl(top)
      end
    end
  end
end