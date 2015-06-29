module WikiHouse::NestingHelper
  def gap_between_sheets
    10
  end

  def gap_between_parts
    WikiHouse::Config.maching.nesting_part_gap
  end

  def build_a_sheet(left_top_corner: nil, right_bottom_corner: nil, nest_group: nil)
    sheet_group = Sk.add_group
    sheet_group = Sk.nest_group(destination_group: nest_group, source_group: sheet_group)

    if outline_sheets
      c1 = left_top_corner
      c2 = [right_bottom_corner.x, left_top_corner.y, left_top_corner.z]
      c3 = right_bottom_corner
      c4 = [left_top_corner.x, right_bottom_corner.y, left_top_corner.z]
      lines = Sk.draw_all_points([c1, c2, c3, c4])
      sheet_face = Sk.add_face(lines)
      #now copy the part over
      sheet_outline = Sk.add_group sheet_face.all_connected
      sheet_outline.name = WikiHouse::Nester.sheet_outline_group_name

      Sk.nest_group(destination_group: sheet_group, source_group: sheet_outline)
    end
    sheet_group
  end
end