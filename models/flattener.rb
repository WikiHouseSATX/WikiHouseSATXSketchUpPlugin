#Needs to create the Flat group at the top
#Add the ability to mark dowels through two components

class WikiHouse::Flattener
  @@dowel_x = 0
  @@flat_x = 0
  @@flat_group = nil
  @@plucked_group = nil
  include WikiHouse::AttributeHelper
  #
  # class Doweler
  #   def initialize
  #     @start_point  = nil
  #     @end_point  = nil
  #   end
  #
  #   def activate
  #     puts "Activating Doweler"
  #     Sk.set_status_message("Click for the start of the line")
  #   end
  #
  #   def deactivate(view=nil)
  #     @start_point = nil
  #     @end_point = nil
  #     puts "Deactivateing Doweler"
  #   end
  #
  #   def onLButtonDown(flags, x, y, view)
  #     if @start_point.nil?
  #       ph = view.pick_helper
  #       ph.do_pick(x, y)
  #       @start_point = [x,y]
  #       @start_face = ph.picked_face
  #       @start_element = ph.picked_element
  #       Sk.set_status_message "Click for the second point"
  #     elsif @end_point.nil?
  #       ph = view.pick_helper
  #       ph.do_pick(x, y)
  #       @end_point = [x,y]
  #       @end_face = ph.picked_face
  #       @end_element = ph.picked_element
  #       Sk.set_status_message "Click for the second point"
  #     else
  #       puts [@start_point, @start_face, @start_element]
  #       puts [@end_point, @end_face, @end_element]
  #       Sketchup.send_action("selectSelectionTool:")
  #     end
  #
  #   end
  # end

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

  def self.mark_face(color: :white)
    Sk.selection.each do |sel|
      if Sk.is_a_face?(sel)
        sel.material = color
      end
    end
  end

  def self.attribute(item, name: nil, default: nil)
    stored_value = item.get_attribute(tag_dictionary, name)
    if stored_value.nil?
      item.set_attribute(tag_dictionary, name, default)
      stored_value = default
    end
    stored_value
  end

  def self.apply_dowels

    # Sketchup.active_model.select_tool(WikiHouse::Flattener::Doweler.new())
    unless Sk.selection.empty?

      Sk.set_status_message("Doweling")
      Sk.start_operation("Doweling Item", disable_ui: true)
      item = Sk.selection.first
      if Sk.is_a_face?(item)
        tag_dictionary = "WikiHouse"
        dowel_center_override = attribute(item, name: "dowel_center_override", default: 0)
        dowel_start_override = attribute(item, name: "dowel_start_override", default: 0)
        dowel_gap_in_inches = attribute(item, name: "dowel_gap_in_inches", default: 6.0)
        dowel_off_center = attribute(item, name: "dowel_off_center", default: 0.5)
        dowel_skip_first = attribute(item, name: "dowel_skip_first", default: false)
        dowel_skip_last = attribute(item, name: "dowel_skip_last", default: false)
        dowel_radius = attribute(item, name: "dowel_radius", default: 0.125)
        dowel_depth = attribute(item, name: "dowel_depth", default: 0.625)
        bounds = item.bounds


        puts "Dowel Gap: #{dowel_gap_in_inches}"
        puts "Dowl Off Center: #{dowel_off_center}"
        if bounds.width > bounds.height
          center = bounds.center

          puts "Wider than Tall"


          min = bounds.min
          min_x = min.x + dowel_start_override
          min_z = min.z
          last_dowel_count = (((bounds.width - (2 * dowel_start_override))/dowel_gap_in_inches) - 1).round
          (0...last_dowel_count).each do |x|
            next if x == 0 && dowel_skip_first
            next if x == last_dowel_count && dowel_skip_last
            if bounds.min.y == bounds.max.y
              center_z = dowel_center_override != 0 ? dowel_center_override + min.z : center.z
              circle = Sk.draw_circle(center_point: [min_x + ((x + 1) * dowel_gap_in_inches),
                                                     center.y,
                                                     center_z + (x % 2 == 0 ? dowel_off_center : -1.0 * dowel_off_center)],
                                      radius: dowel_radius, normal: item.normal)
              puts "top"

            else
              center_y = dowel_center_override != 0 ? dowel_center_override + min.y : center.y
              circle = Sk.draw_circle(center_point: [min_x + ((x + 1) * dowel_gap_in_inches),
                                                     center_y + (x % 2 == 0 ? dowel_off_center : -1.0 * dowel_off_center),
                                                     center.z],
                                      radius: dowel_radius, normal: item.normal)
              # puts "bottom #{min_x + ((x + 1) * dowel_gap_in_inches)} #{min.x + ((x + 1) * dowel_gap_in_inches) - dowel_start_override}"
            end


          end
        else
          puts "Taller than Wide"
          # center = bounds.center
          #
          #
          #
          # min = bounds.min
          # min_x = min.x
          # min_z = min.z
          # last_dowel_count = ((bounds.width/dowel_gap_in_inches) - 1).round
          # (0...last_dowel_count).each do |x|
          #   next if x == 0 && dowel_skip_first
          #   next if x == last_dowel_count && dowel_skip_last
          #   if bounds.min.y == bounds.max.y
          #     center_z = dowel_center_override != 0 ? dowel_center_override + min.z : center.z
          #     circle = Sk.draw_circle(center_point: [
          #                                            center.x,
          #                                            min.y + ((x + 1) * dowel_gap_in_inches),
          #                                            center_z + (x % 2 == 0 ? dowel_off_center : -1.0 * dowel_off_center)],
          #                             radius: dowel_radius, normal: item.normal)
          #
          #
          #   else
          #     center_y = dowel_center_override != 0 ? dowel_center_override + min.y : center.y
          #     circle = Sk.draw_circle(center_point: [min.x + ((x + 1) * dowel_gap_in_inches),
          #                                            center_y + (x % 2 == 0 ? dowel_off_center : -1.0 * dowel_off_center),
          #                                            center.z],
          #                             radius: dowel_radius, normal: item.normal)
          #
          #   end
          #
          #
          # end
        end
      else
        puts "Doh", item
        Sk.set_status_message("Sorry it only works on a single face")
      end


      Sk.commit_operation
    else
      puts "Sorry no selection?"
    end

  end

  def self.super_flatten

    unless Sk.selection.empty?
      Sk.start_operation("Super Flattening Item", disable_ui: true)
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

        if move
          move.move_to(point: [0, 0, 0]).move_by(x: real_x, y: 500, z: 0).go!
        else
          part.move_to!(point: [x, 500, 0])
        end
        all_entities = []
        part.entities.each do |e|
          if Sk.is_a_face?(e)
            all_entities << e.all_connected
          end
        end
        all_entities.flatten!

        g = Sk.add_group
        g.name = "Flat " + sel.name
        outer_loop = nil
        inner_loops = []
        all_entities.each do |e|
          next if e.deleted?
          if Sk.is_a_face?(e) && Sk.get_attribute(e, WikiHouse::PartHelper.tag_dictionary, "primary_face").to_s == "true"
            outer_loop = e.outer_loop.edges.collect { |e| [e.start.position, e.end.position] }
            e.loops.each do |loop|
              next if loop.outer?
              inner_loops << loop.edges.collect { |e| [e.start.position, e.end.position] }
            end
            break
          end
        end


        all_entities.each do |e|
          next if e.deleted?
          if Sk.is_a_face?(e)
            e.erase!
          elsif Sk.is_an_edge?(e)
            start_pt = e.start.position
            end_pt = e.end.position

            Sk.draw_line([start_pt.x, start_pt.y, 0], [end_pt.x, end_pt.y, 0], group: g)

            e.erase!
          end
        end
        if outer_loop
         # puts "Redrawing the outerloop"
          lines = []
          last_line = nil
          outer_loop.each do |e|

            if last_line
              if last_line[1] == e[0]
                start_pt = e[0]
                end_pt = e[1]
              else
                start_pt = e[1]
                end_pt = e[0]
              end
            else
              #first run
              if outer_loop[1][0] == e[0]
                start_pt = e[0]
                end_pt = e[1]
              else
                start_pt = e[1]
                end_pt = e[0]
              end

            end
          #  puts "Outer #{start_pt} -> #{end_pt}"
            lines << Sk.draw_line([start_pt.x, start_pt.y, 0], [end_pt.x, end_pt.y, 0], group: g)
            last_line = [start_pt, end_pt]

          end

          face =g.entities.add_face(lines)
          # e = outer_loop.first
          # lines << Sk.draw_line([e[0].x, e[0].y, 0], [e[1].x, e[1].y, 0], group: g)
          # Sk.add_face(lines)
        end
        if inner_loops
         # puts "Redrawing the outerloop"

          inner_loops.each do |loop|
            lines = []
            last_line = nil
            loop.each do |e|

              if last_line
                if last_line[1] == e[0]
                  start_pt = e[0]
                  end_pt = e[1]
                else
                  start_pt = e[1]
                  end_pt = e[0]
                end
              else
                #first run
                if loop[1][0] == e[0]
                  start_pt = e[0]
                  end_pt = e[1]
                else
                  start_pt = e[1]
                  end_pt = e[0]
                end

              end
           #   puts "Innert #{start_pt} -> #{end_pt}"
              lines << Sk.draw_line([start_pt.x, start_pt.y, 0], [end_pt.x, end_pt.y, 0], group: g)
              last_line = [start_pt, end_pt]
            end
            face =g.entities.add_face(lines)
            face.erase!
            # e = outer_loop.first
            # lines << Sk.draw_line([e[0].x, e[0].y, 0], [e[1].x, e[1].y, 0], group: g)
            # Sk.add_face(lines)
          end

        end


        # Sk.add_face(g.entities.select { |e| Sk.is_an_edge?(e) })
        Sk.nest_group(destination_group: @@flat_group, source_group: g)

        x += part.bounds.width + 10
        gcopy.erase!
      end

      @@flat_x = x
      Sk.commit_operation
    end


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
    unless Sk.selection.empty? "Removing Primary Face"
      Sk.selection.each do |e|
        remove_flattenable!(e)
      end
    end
  end

  def self.remove_selection_primary_face

    unless Sk.selection.empty?
      Sk.selection.each do |e|
        remove_primary_face!(e)
        if Sk.is_a_group?(e)
          e.entities.each { |sub_e| remove_primary_face!(sub_e) }
        elsif Sk.is_a_component_instance?(e)
          e.definition.entities.each { |sub_e| remove_primary_face!(sub_e) }
        end

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
    include WikiHouse::AttributeHelper

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
      normal = primary_face.normal
      loop = primary_face.outer_loop
      primary_face.material = nil
      if Sk.round_pt(normal) == [0, 1, 0]
        puts "Rotating?"

        part.move_to(point: [0, 0, 0]).rotate(point: [0, 0, 0], vector: [1, 0, 0], rotation: 90.degrees).move_to(point: [0, 0, 0]).go!
      else
        part.move_to(point: [0, 0, 0]).go!
      end
      tr = part.group.transformation
      pt = primary_face.vertices.first.position.transform!(tr)
      filter_value = Sk.round(pt.z)

      off_of_filter = lambda do |entity|
        return false if !Sk.is_an_edge?(entity)
        start_pt = entity.start.position.transform!(tr)
        end_pt = entity.end.position.transform!(tr)
        return true if Sk.round(start_pt.z) != filter_value ||
            Sk.round(end_pt.z) != filter_value
        return false
      end
      off_of_filter_count = lambda do |list|
        list.find_all { |e| off_of_filter.call(e) }.count
      end
      #need to loop until all stray edges are removed
      while off_of_filter_count.call(part.entities) != 0
        part.entities.each do |entity|
          next if entity == primary_face
          erase = false
          if Sk.is_a_face?(entity)
            erase = true
          end
          if !entity.deleted? && Sk.is_an_edge?(entity)
            erase = true if off_of_filter.call(entity)

          end
          entity.erase! if erase
        end
      end
      if Sk.round_pt(normal) == [0, 1, 0]
        puts "Rotating?"
        primary_face.reverse!
        part.rotate(point: [x, 20, 0], vector: [1, 0, 0], rotation: 90.degrees).move_to(point: [x, 20, 0]).go!

      else
        if primary_face.normal.z == -1
          #puts "Reversing #{primary_face.normal.z}"
          primary_face.reverse!
        end
        part.move_to(point: [x, 20, 0]).go!
      end
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

      if Sk.is_a_group?(subitem)
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
      if Sk.is_a_group?(subitem)
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

      if Sk.is_a_group?(top)
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