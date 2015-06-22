#Single nesting is the dumbest form of nestting
# one part per sheet

require 'ostruct'
class WikiHouse::SingleNesting
  attr_reader :starting_x, :starting_y, :sheet
  def initialize(starting_x: nil, starting_y: nil, sheet: nil)
    @parts = []
    @starting_x = starting_x
    @starting_y = starting_y
    @sheet = sheet
    @nested_sheets = []
  end

  def nest!(parts: nil, nest_group: nil, nest_layer_name: nil)
    #for each aprt
    #create a sheet
    #move the part to the sheet
    last_x = @starting_x
    parts.each do |part|
      #draw a sheet
      c1 = [last_x, @starting_y, 0]
      c2 = [last_x + @sheet.length, @starting_y, 0]
      c3 = [last_x + @sheet.length, @starting_y + @sheet.width, 0]
      c4 = [last_x, @starting_y + @sheet.width, 0]
      lines = Sk.draw_all_points([c1, c2, c3, c4])

      #now copy the part over
      sheet_outline = Sk.add_group lines
      sheet_outline.name = "Sheet Outline"

      sheet_group = Sk.add_group
      sheet_group = Sk.nest_group(destination_group: nest_group, source_group: sheet_group)
      Sk.nest_group(destination_group: sheet_group, source_group: sheet_outline)
      part.group = Sk.nest_group(destination_group: sheet_group, source_group: part.group)




      part.move_to(point: [last_x, @starting_y, 0]).go!
      part.set_tag(tag_name: "group_source", value: part.group.name)
      part.set_tag(tag_name: "source", value: part.group.entityID)

      sheet_group.name = "Sheet #{@nested_sheets.count + 1} of #{parts.count }"
      @nested_sheets << sheet_group
      last_x += @sheet.length + 10
    end


  end
end

#   def nest!
#
#     Sk.start_operation("Nesting Items", disable_ui: true)
#
#     #puts "Nesting #{item.name}"
#
#     original_layer = Sk.current_active_layer
#     Sk.make_layer_active_name(name: nest_layer_name)
#
#     root = OpenStruct.new(x: 0, y: 0, w: @sheet.length, h: @sheet.width, sheet: 1)
#     @parts.each do |part|
#       puts "Sheet #{root.sheet} "
#       puts "Part - #{part.label}"
#       node = find_node(root, part.bound_width, part.bound_length)
#       unless node.nil?
#         puts "Node is  #{node}"
#         part.fit = split_node(node, part.bound_width, part.bound_length)
#       else
#         #start a new sheet
#         puts "Doesn't fiT - starting new sheet"
#         root = OpenStruct.new(x: 0, y: 0, w: @sheet.length, h: @sheet.width, sheet: root.sheet + 1)
#         node = find_node(root, part.bound_width , part.bound_length )
#         unless node.nil?
#           puts "Node is  #{node}"
#           part.fit = split_node(node, part.bound_width , part.bound_length )
#         else
#           raise ArgumentError, "#{part.label}No way to fit the part onto a sheet #{part.bound_width} #{part.bound_length}"
#         end
#       end
#     end
#
#     @parts.each do |p|
#       puts "#{p.label} #{p.fit.x} #{p.fit.y}"
#       p.move_to!(point: [ (@starting_x + (p.fit.sheet * (@sheet.length + 5) )) + p.fit.x,
#                           @starting_y + p.fit.y, 0])
#
#
#     end
#     #    @parts.each { |p| puts " #{p.label} #{p.max_length_width}" }
#     #experiment with packing in mass
#     #
#     # #draw a sheet
#     # c1 = [@last_x, @starting_y, 0]
#     # c2 = [@last_x + @sheet.length, @starting_y, 0]
#     # c3 = [@last_x + @sheet.length, @starting_y + @sheet.width, 0]
#     # c4 = [@last_x, @starting_y + @sheet.width, 0]
#     # lines = Sk.draw_all_points([c1, c2, c3, c4])
#     #
#     # #now copy the part over
#     # sheet_outline = Sk.add_group lines
#     # sheet_outline.name = "sheet outline"
#     #
#     # sheet_group = Sk.add_group
#     # Sk.nest_group(destination_group: sheet_group, source_group: sheet_outline)
#     # gcopy = Sk.copy_group(destination_group: sheet_group, source_group: item)
#     # gcopy.make_unique
#     # gcopy.entities.each { |e| e.layer = nest_layer_name}
#     # gcopy.name = item.name
#     # part = NestedPart.new(group: gcopy)
#     # x = @last_x
#     #
#     # part.move_to(point: [x, @starting_y, 0]).go!
#     # part.set_tag(tag_name: "group_source", value: item.name)
#     # part.set_tag(tag_name: "source", value: item.entityID)
#     #
#     # sheet_group.name = "Sheet ##{@sheets.count + 1}"
#     # @sheets << sheet_group
#     # @last_x += @sheet.length + 10
#     Sk.make_layer_active(original_layer)
#     Sk.commit_operation
#   end
#
