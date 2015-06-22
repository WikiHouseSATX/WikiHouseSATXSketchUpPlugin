#Large portions of this code use packing ideas from
#sprite-factory https://github.com/jakesgordon/sprite-factory/blob/master/LICENSE
#Copyright (c) 2011, 2012, 2013, 2014, 2015, Jake Gordon and contributors
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
# Nesting Process
# ==========================
# Find all the flat parts
# create a sheet for each part
# copy the part to each sheet
# press button to export sheets to individual svg files
# Do a simple area calculation to decide if we should even try to fit it on the sheet
#Ignore the inside.outside edge for the first draft

#need a nestable part wrapper
# It needs to figure out the approx area - using the bounding box
# It should alo figur eout the actual area using the face.area
# The system should sort the parts by area from largest to smallest.
# The system should be able to confirm that it fits on a sheet at all - and stop if the part doesn't
# the system should be able to confirm that it hasn't collided with any other parts
# we need to be able to move the part on the sheet and be able to rotate it quickly (starting with 90 degree increments)
#The nest should be able to show how many sheets - and the use/waste for each sheet - as well as a total use/waste for the whole thing
#http://codeincomplete.com/posts/2011/5/7/bin_packing/
#https://github.com/jakesgordon/bin-packing

#Needs to draw sheets
#needs to add margins between parts
#should consider rotating the parts for better fit
#shoudl look at other parts before giving up and creating a new sheet
require 'ostruct'
class WikiHouse::Nester
  class NestablePart
    include WikiHouse::PartHelper
    attr_accessor :fit

    def initialize(sheet: nil, group: nil, origin: nil, label: nil)
      part_init(sheet: sheet, group: group, origin: origin, label: label)
    end

    def max_length_width
      bounds.height > bounds.width ? bounds.height : bounds.width
    end

    def bound_length
      bounds.height
    end

    def bound_width
      bounds.width
    end

    def bound_area
      bound_width * bound_length
    end
  end
  class NestedSheet
    #this part handles the bookkeeping for the parts that are assigned ot see if we should even consider the part.
    attr_reader :total_area, :area_in_use, :sheet

    def initialize(sheet: nil)

    end

  end
  attr_reader :strategy

  def self.nest_layer_name
    "WikiHouse::NestedLayer"
  end
  def self.erase!
    Sk.remove_layer(name: nest_layer_name, delete_geometry: true)
  end
  def nest_group_name
    "WikiHouse::Nested"
  end

  def nest_layer_name
    self.class.nest_layer_name
  end

  def initialize(strategy: nil, starting_x: 300, staring_y: 300)
    @starting_x = starting_x
    @starting_y = staring_y
    @nest_group = nil
    @sheet = WikiHouse.sheet.new
    @sheets = []
    @parts = []
    @strategy = strategy ? strategy : WikiHouse::SingleNesting.new
    Sk.find_or_create_layer(name: nest_layer_name)
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

  def nest!

    Sk.start_operation("Nesting Items", disable_ui: true)

    #puts "Nesting #{item.name}"

    original_layer = Sk.current_active_layer
    Sk.make_layer_active_name(name: nest_layer_name)

    root = OpenStruct.new(x: 0, y: 0, w: @sheet.length, h: @sheet.width, sheet: 1)
    @parts.each do |part|
      puts "Sheet #{root.sheet} "
      puts "Part - #{part.label}"
      node = find_node(root, part.bound_width, part.bound_length)
      unless node.nil?
        puts "Node is  #{node}"
        part.fit = split_node(node, part.bound_width, part.bound_length)
      else
        #start a new sheet
        puts "Doesn't fiT - starting new sheet"
        root = OpenStruct.new(x: 0, y: 0, w: @sheet.length, h: @sheet.width, sheet: root.sheet + 1)
        node = find_node(root, part.bound_width , part.bound_length )
        unless node.nil?
          puts "Node is  #{node}"
          part.fit = split_node(node, part.bound_width , part.bound_length )
        else
          raise ArgumentError, "#{part.label}No way to fit the part onto a sheet #{part.bound_width} #{part.bound_length}"
        end
      end
    end

    @parts.each do |p|
      puts "#{p.label} #{p.fit.x} #{p.fit.y}"
      p.move_to!(point: [ (@starting_x + (p.fit.sheet * (@sheet.length + 5) )) + p.fit.x,
                         @starting_y + p.fit.y, 0])


    end
    #    @parts.each { |p| puts " #{p.label} #{p.max_length_width}" }
    #experiment with packing in mass
    #
    # #draw a sheet
    # c1 = [@last_x, @starting_y, 0]
    # c2 = [@last_x + @sheet.length, @starting_y, 0]
    # c3 = [@last_x + @sheet.length, @starting_y + @sheet.width, 0]
    # c4 = [@last_x, @starting_y + @sheet.width, 0]
    # lines = Sk.draw_all_points([c1, c2, c3, c4])
    #
    # #now copy the part over
    # sheet_outline = Sk.add_group lines
    # sheet_outline.name = "sheet outline"
    #
    # sheet_group = Sk.add_group
    # Sk.nest_group(destination_group: sheet_group, source_group: sheet_outline)
    # gcopy = Sk.copy_group(destination_group: sheet_group, source_group: item)
    # gcopy.make_unique
    # gcopy.entities.each { |e| e.layer = nest_layer_name}
    # gcopy.name = item.name
    # part = NestedPart.new(group: gcopy)
    # x = @last_x
    #
    # part.move_to(point: [x, @starting_y, 0]).go!
    # part.set_tag(tag_name: "group_source", value: item.name)
    # part.set_tag(tag_name: "source", value: item.entityID)
    #
    # sheet_group.name = "Sheet ##{@sheets.count + 1}"
    # @sheets << sheet_group
    # @last_x += @sheet.length + 10
    Sk.make_layer_active(original_layer)
    Sk.commit_operation
  end

  def build_nestable_part(item)
    original_layer = Sk.current_active_layer
    Sk.make_layer_active_name(name: nest_layer_name)
    gcopy = Sk.copy_group(destination_group: @nest_group, source_group: item)
    gcopy.make_unique
    gcopy.entities.each { |e| e.layer = nest_layer_name }
    gcopy.name = item.name
    part = NestablePart.new(group: gcopy, origin: [0, 0, 0], label: item.name)
    part.move_to!(point: [0, 0, 0])


    Sk.make_layer_active(original_layer)
    part
  end

  def sort_parts!
    @parts.sort! do |a, b|
      a.max_length_width <=> b.max_length_width
      diff = [b.bound_width, b.bound_length].max <=> [a.bound_width, a.bound_length].max
      diff = [b.bound_width, b.bound_length].min <=> [a.bound_width, a.bound_length].min if diff.zero?
      diff = b.bound_length <=> a.bound_length if diff.zero?
      diff = b.bound_width <=> a.bound_width if diff.zero?
      diff
    end


  end

  def draw!
    puts "Creating Flat Group"
    @nest_group = Sk.add_group
    @nest_group.name = nest_group_name

    Sk.active_entities.each do |top|
      if top.typename == "Group" && top.name == WikiHouse::Flattener.flat_group_name
        puts "Found the flat group #{top.entities.count}"
        @last_x = @starting_x

        top.entities.each do |e|
          #crate the nestable part
          @parts << build_nestable_part(e)
          #puts "#{e.name} #{e.typename}"
          #nest!(e)
        end
        sort_parts!
        nest!
      end
    end

  end
end