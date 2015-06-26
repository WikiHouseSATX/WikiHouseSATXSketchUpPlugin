#Single nesting is the dumbest form of nestting
# one part per sheet

require 'ostruct'
class WikiHouse::SingleNesting
  include WikiHouse::NestingHelper
  attr_reader :starting_x, :starting_y, :sheet
  def initialize(starting_x: nil, starting_y: nil, sheet: nil)

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

      sheet_group = build_a_sheet(nest_group: nest_group,
      left_top_corner: [last_x, @starting_y, 0] ,
      right_bottom_corner: [last_x + @sheet.length, @starting_y + @sheet.width, 0] )
      sheet_group.name = "Sheet #{@nested_sheets.count + 1} of #{parts.count }"

      original_group_name  =  part.group.name
      original_entityID = part.group.entityID
      part.group = Sk.nest_group(destination_group: sheet_group, source_group: part.group)


      part.move_to(point: [last_x, @starting_y, 0]).go!
      part.set_tag(tag_name: "group_source", value: original_group_name)
      part.set_tag(tag_name: "source", value: original_entityID)


      @nested_sheets << sheet_group
      last_x += @sheet.length + gap_between_sheets
    end


  end
end