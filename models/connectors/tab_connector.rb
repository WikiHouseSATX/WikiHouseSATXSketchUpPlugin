class WikiHouse::TabConnector < WikiHouse::Connector

  def tab?
    true
  end

  def name
    :tab
  end

  def build_tab_points(start_pt: nil,
                       end_pt: nil,
                       orientation: nil,
                       total_length: nil,
                       tab_count: nil,
                       tab_width: nil,
                       starting_thickness: nil,
                       section_gap: nil


  )
    c5 = start_pt
    c6 = end_pt
    tab_points = [c5]

    tab_count.times do |i|
      starting_length = ((i + 1) * section_gap) + (i * tab_width) - starting_thickness

      if orientation == :right


        start_tab = c5.y - starting_length

        end_tab = start_tab - tab_width


        pc1 = [c5.x, start_tab, c5.z]
        pc2 = [c5.x + length, start_tab, c5.z]
        pc3 = [c5.x + length, end_tab, c5.z]
        pc4 = [c5.x, end_tab, c5.z]


      elsif orientation == :left

        start_tab = c5.y + starting_length
        end_tab = start_tab + tab_width


        pc4 = [c5.x - length, start_tab, c5.z]
        pc3 = [c5.x, start_tab, c5.z]
        pc2 = [c5.x, end_tab, c5.z]
        pc1 = [c5.x - length, end_tab, c5.z]


      elsif orientation == :top

        start_tab = c5.x + starting_length

        end_tab = start_tab + tab_width


        pc4 = [start_tab, c5.y + length, c5.z]
        pc3 = [start_tab, c5.y, c5.z]
        pc2 = [end_tab, c5.y, c5.z]
        pc1 = [end_tab, c5.y + length, c5.z]


      elsif orientation == :bottom

        start_tab = c5.x - starting_length
        end_tab = start_tab - tab_width


        pc1 = [start_tab, c5.y, c5.z]
        pc2 = [start_tab, c5.y - length, c5.z]
        pc3 = [end_tab, c5.y - length, c5.z]
        pc4 = [end_tab, c5.y, c5.z]
      end
      if orientation == :top || orientation == :left
        current_points = [pc3, pc4, pc1, pc2]
      else
        current_points = [pc1, pc2, pc3, pc4]
      end

      tab_points.concat(current_points)
      WikiHouse::Fillet.by_points(tab_points, tab_points.length - 3, tab_points.length - 4, tab_points.length - 5, reverse_it: true)

      if i > 0

        WikiHouse::Fillet.by_points(tab_points, tab_points.length - 8, tab_points.length - 7, tab_points.length - 6)

      end

    end

    tab_points << c6

    WikiHouse::Fillet.by_points(tab_points, tab_points.length - 3, tab_points.length - 2, tab_points.length - 1)
    tab_points
  end

  def points(bounding_start: nil,
             bounding_end: nil,
             start_pt: nil,
             end_pt: nil,
             orientation: nil,
             starting_thickness: nil,
             total_length: nil)

    unless [:right, :left, :top, :bottom].include?(orientation)
      raise ArgumentError, "#{orientation} is not supported by this connector"
    end

    if !sections.nil? && !sections.empty?

      c5 = start_pt
      c6 = end_pt


      tab_width = width
      tab_count = count

      if orientation == :top && starting_thickness
        c5.x += starting_thickness
      elsif orientation == :bottom && starting_thickness
        c5.x -= starting_thickness
      end
      if orientation == :right
        if c5.x == bounding_start.x
          c5.x -= length

        end
        c6.x = c5.x
      elsif orientation == :left
        if c5.x == bounding_start.x
          c5.x += length

        end
        c6.x = c5.x
      elsif orientation == :top
        if c5.y == bounding_start.y
          c5.y -= length

        end
        c6.y = c5.y
      elsif orientation == :bottom
        if c5.y == bounding_start.y
          c5.y += length

        end
        c6.y = c5.y
      end
      section_gap = Sk.round((total_length - (tab_count * tab_width))/(tab_count.to_f + 1.0))
      build_tab_points(start_pt: c5,
                       end_pt: c6,
                       orientation: orientation,
                       total_length: total_length,
                       tab_count: tab_count,
                       tab_width: tab_width,
                       starting_thickness: starting_thickness,
                       section_gap: section_gap)


    else
      c5 = start_pt
      c6 = end_pt


      tab_width = width
      tab_count = count

      if orientation == :top && starting_thickness
        c5.x += starting_thickness
      elsif orientation == :bottom && starting_thickness
        c5.x -= starting_thickness
      end
      if orientation == :right
        if c5.x == bounding_start.x
          c5.x -= length

        end
        c6.x = c5.x
      elsif orientation == :left
        if c5.x == bounding_start.x
          c5.x += length

        end
        c6.x = c5.x
      elsif orientation == :top
        if c5.y == bounding_start.y
          c5.y -= length

        end
        c6.y = c5.y
      elsif orientation == :bottom
        if c5.y == bounding_start.y
          c5.y += length

        end
        c6.y = c5.y
      end
      section_gap = Sk.round((total_length - (tab_count * tab_width))/(tab_count.to_f + 1.0))
      build_tab_points(start_pt: c5,
                       end_pt: c6,
                       orientation: orientation,
                       total_length: total_length,
                       tab_count: tab_count,
                       tab_width: tab_width,
                       starting_thickness: starting_thickness,
                       section_gap: section_gap)

    end


  end
end
