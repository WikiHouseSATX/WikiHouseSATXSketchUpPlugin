class WikiHouse::Flattener
  LAYER_NAME = "Flat View"

  def initialize
    @flat_group = nil
    @sheet = WikiHouse::Sheet.new
    Sk.find_or_create_layer(name: LAYER_NAME)

  end

  def thickness
    @sheet.thickness
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
    model = Sketchup.active_model
    model.start_operation('Flattening Item', true)

    original_layer = Sk.current_active_layer
    Sk.make_layer_active_name(name: LAYER_NAME)
    puts "Flattening #{group.name} #{group.entityID}"
    if !@flat_group
      @flat_group = Sk.add_group
      @flat_group.name = "Flat Version"
      @parts = []
      @last_x = 100
    end

    gcopy = Sk.transfer_group(destination_group: @flat_group, source_group: group)
    gcopy.make_unique
    gcopy.name = group.name + " Copy"
    gcopy.entities.each { |e| e.layer = LAYER_NAME }
    part = FlatPart.new(group: gcopy)


    last_part = @parts.last


    x = @last_x + 1
    if last_part
      width = part.bounds.width
      if width == thickness
        #  puts "Overriding"
        width = part.bounds.height
      end
      # puts "Width is #{width}"
      x += width

    end
    #  puts "Moveing to #{x}"
    @last_x = x
    part.move_to!(point: [x, 100, 0])

    primary_face = nil
    part.group.entities.each do |entity|
      if entity.typename == "Face" &&
          Sk.get_attribute(entity, WikiHouse::PartHelper::DEFAULT_DICTIONARY, "primary_face")
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

    part.set_tag(tag_name: "group_source", value: group.name)
    part.set_tag(tag_name: "flat", value: true)
    part.set_tag(tag_name: "source", value: group.entityID)
    @parts << part
    Sk.make_layer_active(original_layer)
    model.commit_operation


  end

  def is_cutable?(item)
    item.get_attribute(WikiHouse::PartHelper::DEFAULT_DICTIONARY, "cutable") == true
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
    model = Sketchup.active_model
    entities = model.entities
    entities.each do |top|
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