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

  def fit?(part_bounds, sheet_bounds)
    puts "Comparing #{Sk.point_to_s(part_bounds)} vs #{Sk.point_to_s(sheet_bounds)}"
    part_bounds.x > sheet_bounds.x ||
        part_bounds.y > sheet_bounds.y ||
        part_bounds.z > sheet_bounds.z ? false : true

  end

  def nest!(parts: nil, nest_group: nil, nest_layer_name: nil)
    last_x = @starting_x
    parts.each do |part|

      sheet_group = build_a_sheet(nest_group: nest_group,
                                  left_top_corner: [last_x, @starting_y, 0],
                                  right_bottom_corner: [last_x + @sheet.length, @starting_y + @sheet.width, 0])
      sheet_group.name = "Sheet #{@nested_sheets.count + 1} of #{parts.count }"
      sheet_bounds = Sk.max_bounds(sheet_group)
      original_group_name = part.group.name
      original_entityID = part.group.entityID
      part.group = Sk.nest_group(destination_group: sheet_group, source_group: part.group)

      part.rotate(vector: [0, 1,0], rotation: 90.degrees).go!

      part.move_to(point: [last_x + sheet.margin, @starting_y + sheet.margin, 0]).go!
      puts part.group.name
      raise ScriptError
      fit_on_sheet = fit?(Sk.max_bounds(part.group), sheet_bounds)
      unless fit_on_sheet
        #try rotating it to make it fit
        part.rotate(vector: [0, 1,0], rotation: 90.degrees).go!
        fit_on_sheet = fit?(Sk.max_bounds(part.group), sheet_bounds)

      end
      unless fit_on_sheet
        raise ArgumentError, "This part doesn't fit!"
      end

      part.set_tag(tag_name: "group_source", value: original_group_name)
      part.set_tag(tag_name: "source", value: original_entityID)


      @nested_sheets << sheet_group
      last_x += @sheet.length + gap_between_sheets
    end


  end
end