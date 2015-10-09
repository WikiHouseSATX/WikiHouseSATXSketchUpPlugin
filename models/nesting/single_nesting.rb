#Single nesting is the dumbest form of nestting
# one part per ,sheet


require 'ostruct'
class WikiHouse::SingleNesting
  include WikiHouse::NestingHelper
  attr_reader :starting_x, :starting_y, :sheet, :outline_sheets

  def initialize(starting_x: nil, starting_y: nil, sheet: nil, outline_sheets: true)

    @starting_x = starting_x
    @starting_y = starting_y
    @sheet = sheet
    @nested_sheets = []
    @outline_sheets = outline_sheets
  end

  def fit?(part_bounds, sheet_bounds)
    puts "Comparing #{Sk.point_to_s(part_bounds)} vs #{Sk.point_to_s(sheet_bounds)}"
    part_bounds.x > sheet_bounds.x ||
        part_bounds.y > sheet_bounds.y ||
        part_bounds.z > sheet_bounds.z ? false : true

  end

  def fit_action(part, sheet_bounds)
    part_bounds = Sk.min_max_bounds(part.group)
    pmax = part_bounds[:max]
    pmin = part_bounds[:min]
    smax = sheet_bounds[:max]
    smin = sheet_bounds[:min]

    if pmax.z == smax.z && pmin.z == smax.z

      if pmax.x <= smax.x &&
          pmax.y <= smax.y &&

          pmin.x >= smin.x &&
          pmin.y >= smin.y

        return :move
      end
      if pmax.x <= smax.y &&
          pmax.y <= smax.x &&
          pmin.x >= smin.y &&
          pmin.y >= smin.x
        return :rotate
      end

    end

    nil

  end

  def nest!(parts: nil, nest_group: nil, nest_layer_name: nil)
    last_x = @starting_x
    parts.each do |part|

      sheet_group = build_a_sheet(nest_group: nest_group,
                                  left_top_corner: [last_x, @starting_y, 0],
                                  right_bottom_corner: [last_x + sheet.length,
                                                        @starting_y + sheet.width, 0])
      sheet_group.name = "Sheet #{@nested_sheets.count + 1} of #{parts.count }"

      #parts are at 0,0 - so need to make sheet bounds in same co-ordinate space
      sheet_bounds = {
          max: [sheet.length, sheet.width, 0],
          min: [0, 0, 0]
      }

      original_group_name = part.group.name
      original_entityID = part.group.entityID
      if Sk.is_a_group?(part.group)
        part.group = Sk.nest_group(destination_group: sheet_group, source_group: part.group)
      else
        part.group = Sk.nest_component(destination_group: sheet_group, source_component: part.group, make_unique: true)

      end

      action = fit_action(part, sheet_bounds)

      if action == :rotate

        part.rotate(vector: [0, 0, 1], rotation: -90.degrees).
            move_to(point: [0, 0, 0]).
            move_by(
                x: -1 * (@starting_y + sheet.margin + part.group.bounds.width), #-1 *  last_x, #+ sheet.margin),
                y: last_x + sheet.margin, # @starting_y + sheet.margin,
                z: 0).go!
      elsif action == :move
        part.move_to(point: [last_x + sheet.margin, @starting_y + sheet.margin, 0]).go!
      else
        raise ArgumentError, "This part doesn't fit! #{part.group.name}"
     end

      part.set_tag(tag_name: "group_source", value: original_group_name)
      part.set_tag(tag_name: "source", value: original_entityID)


      @nested_sheets << sheet_group
      last_x += @sheet.length + gap_between_sheets
    end


  end
end