# #Large portions of this code use packing ideas from
# #sprite-factory https://github.com/jakesgordon/sprite-factory/blob/master/LICENSE
# #Copyright (c) 2011, 2012, 2013, 2014, 2015, Jake Gordon and contributors
# # Permission is hereby granted, free of charge, to any person obtaining a copy
# # of this software and associated documentation files (the "Software"), to deal
# # in the Software without restriction, including without limitation the rights
# # to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# # copies of the Software, and to permit persons to whom the Software is
# # furnished to do so, subject to the following conditions:
# #
# # The above copyright notice and this permission notice shall be included in all
# # copies or substantial portions of the Software.
# #
# # THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# # IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# # FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# # AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# # LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# # OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# # SOFTWARE.
# # Nesting Process
# # ==========================
# # Find all the flat parts
# # create a sheet for each part
# # copy the part to each sheet
# # press button to export sheets to individual svg files
# # Do a simple area calculation to decide if we should even try to fit it on the sheet
# #Ignore the inside.outside edge for the first draft
#
# #need a nestable part wrapper
# # It needs to figure out the approx area - using the bounding box
# # It should alo figur eout the actual area using the face.area
# # The system should sort the parts by area from largest to smallest.
# # The system should be able to confirm that it fits on a sheet at all - and stop if the part doesn't
# # the system should be able to confirm that it hasn't collided with any other parts
# # we need to be able to move the part on the sheet and be able to rotate it quickly (starting with 90 degree increments)
# #The nest should be able to show how many sheets - and the use/waste for each sheet - as well as a total use/waste for the whole thing
# #http://codeincomplete.com/posts/2011/5/7/bin_packing/
# #https://github.com/jakesgordon/bin-packing
#


# #should consider rotating the parts for better fit
# #shoudl look at other parts before giving up and creating a new sheet
# should go back to exisitng sheets to find a place
require "ostruct"
class WikiHouse::FirstFitDecreasingNesting
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
    parts = sort_parts!(parts)
    last_x = @starting_x


    root = OpenStruct.new(x: sheet.margin, y: sheet.margin, w: @sheet.length, h: @sheet.width, sheet: 1)
    parts.each do |part|
      #  puts "Sheet #{root.sheet} "

      #  puts "Part - #{part.label}"
      node = find_node(root, part.bound_width_with_margin, part.bound_length_with_margin)
      unless node.nil?
        #    puts "Node is  #{node}"
        part.fit = split_node(node, part.bound_width_with_margin, part.bound_length_with_margin)

      else
        #start a new sheet
        #   puts "Doesn't fiT - starting new sheet"
        root = OpenStruct.new(x: sheet.margin, y: sheet.margin, w: @sheet.length, h: @sheet.width, sheet: root.sheet + 1)
        node = find_node(root, part.bound_width_with_margin, part.bound_length_with_margin)
        unless node.nil?
          #    puts "Node is  #{node}"
          part.fit = split_node(node, part.bound_width_with_margin, part.bound_length_with_margin)


        else
          raise ArgumentError, "#{part.label}No way to fit the part onto a sheet #{part.bound_width_with_margin} #{part.bound_length_with_margin}"
        end
      end
    end
    #
    # sheet_group = build_a_sheet(left_top_corner: [@starting_x, @starting_y,0], right_bottom_corner: [@starting_x + @sheet.length, @starting_y + @sheet.width, 0], nest_group: nest_group)
    # sheet_group.name = "Sheet ##{root.sheet}"
    max_sheet_count = parts.collect { |p| p.fit.sheet }.max
    parts.each do |p|
      #     if @nested_sheets[p.fit]
      sheet_number = p.fit.sheet
      if @nested_sheets[p.fit.sheet - 1].nil?
        sheet_start_x = @starting_x + ((sheet_number - 1) * (@sheet.length + gap_between_sheets))
        sheet_group = build_a_sheet(left_top_corner: [sheet_start_x, @starting_y, 0],
                                    right_bottom_corner: [sheet_start_x + @sheet.length, @starting_y + @sheet.width, 0],
                                    nest_group: nest_group)
        puts "Making the sheet "
        sheet_group.name = "Sheet ##{p.fit.sheet} of #{max_sheet_count}"
        @nested_sheets[p.fit.sheet - 1] = sheet_group
      else
        sheet_group = @nested_sheets[p.fit.sheet - 1]
      end
      original_group_name = p.group.name
      original_entityID = p.group.entityID
      p.group = Sk.nest_group(destination_group: sheet_group, source_group: p.group)
      #   puts "#{p.label} #{p.fit.x} #{p.fit.y}  sheet #{p.fit.sheet}"
      p.move_to!(point: [@starting_x + ((sheet_number - 1) * (@sheet.length + gap_between_sheets)) + p.fit.x,
                         @starting_y + p.fit.y, 0])

      p.set_tag(tag_name: "group_source", value: original_group_name)
      p.set_tag(tag_name: "source", value: original_entityID)

    end

  end

  def find_node(root, w, h)
    if root.used
      find_node(root.right, w, h) || find_node(root.down, w, h)
    elsif (w <= root.w && h <= root.h)
      root
    else
      return nil
    end
  end

  def split_node(node, w, h)
    node.used = true
    node.down = OpenStruct.new(x: node.x, y: node.y + h, w: node.w, h: node.h - h, sheet: node.sheet)
    node.right = OpenStruct.new(x: node.x + w, y: node.y, w: node.w - w, h: h, sheet: node.sheet)
    node

  end


  def sort_parts!(parts)
    parts.sort do |a, b|
      a.max_length_width <=> b.max_length_width
      diff = [b.bound_width, b.bound_length].max <=> [a.bound_width, a.bound_length].max
      diff = [b.bound_width, b.bound_length].min <=> [a.bound_width, a.bound_length].min if diff.zero?
      diff = b.bound_length <=> a.bound_length if diff.zero?
      diff = b.bound_width <=> a.bound_width if diff.zero?
      diff
    end
  end


end