class TransformerTool
	def activate
		puts 'Your tool has been activated.'
	end
  def transform(x,y, view)
    face = view.inputpoint x, y
    if face
      puts "Found a face #{face}"
    else
      puts "Didn't click on a face"
    end
  end
	def onLButtonDown(flags, x, y, view)
		#	wikihouse_it!(view)
		#  draw_stairs(x,y)
    transform(x,y,view)
		if WikiHouse::LOG_ON
			puts "onLButtonDown: flags =  #{flags}"
			puts "                   x = #{x}"
			puts "      y = #{y}"
			puts "                view = #{view}"
		end
	end
	def self.init
		puts "initializing the menu system"
		setup_toolbar if WikiHouse.build_menus?
	end
	def self.setup_toolbar
		toolbar = UI::Toolbar.new "WikiHouse"
		cmd = UI::Command.new("WikiHouse Transform") {
			transformer_tool = TransformerTool.new
			Sketchup.active_model.select_tool(transformer_tool)

		}
		cmd.small_icon = WikiHouse.plugin_file("WikiHouse_logo_12.png","images")
		cmd.large_icon = WikiHouse.plugin_file("WikiHouse_logo_24.png","images")
		cmd.tooltip = "WikiHouse Transformer"
		cmd.status_bar_text = "Let's you pick a face to wikize"
		cmd.menu_text = "WikiHouse Transform"
		toolbar = toolbar.add_item cmd
		toolbar.show
		toolbar.restore
	end

end

# #Copyright 2015 WikiHouseSATX
#
#
# def wikihouse_it!(view)
# #  view = Sketchup.active_model.active_view
#   ph = view.pick_helper
#  x,y = view.center
#
#  puts "Cord - #{x} #{y}"
#    ph.do_pick(x,y)
#    entities = ph.all_picked
#    entities.each do |e|
#      puts "Transforming? #{e.class}"
#      e.pushpull sheet_thickness
#      status = e.set_attribute "wikihousedictionary", "transformed", true
#      e.attribute_dictionaries.each {|dict| puts dict }
#
#    end
#
# end
#
# # UI.add_context_menu_handler do |context_menu|
# #   context_menu.add_item("WikiHouse It!") {
# #    #wikihouse_it!
# #    my_tool = MyTool.new
# #    Sketchup.active_model.select_tool(my_tool)
# #   }
# # end
# #
# # Add a menu item to launch our plugin.
# # UI.menu("Plugins").add_item("Draw stairs") {
# # #  UI.messagebox("I'm about to draw stairs!")
# # #  UI.messagebox("Here they come")
# #  # Call our new method.
# #  my_tool = MyTool.new
# # Sketchup.active_model.select_tool(my_tool)
# #
# #
# #  #  draw_stairs(my_tool)
# # }
#
#
#
#
#
#
#
#
#
#
# def draw_stairs(orig_x = 0, orig_y = 0)
#   prompts = ["# of Sheets", "Length (In)", "Width (In)", "Thickness(In)"]
#   defaults = [10, sheet_length, sheet_width, sheet_thickness ]
# #  list = ["", "", "Male|Female"]
#   input = UI.inputbox(prompts, defaults, "What are your sheets?")
#
#   # Create some variables.
#   stairs = input[0]
#   #rise = 8
#   rise = 0 #0 means floor
#   run = input[1] #0 means fence
#   width = input[2]
#   thickness = input[3]
#   gap = 24
#   # Get handles to our model and the Entities collection it contains.
#   model = Sketchup.active_model
#   entities = model.entities
#   puts "                   x = #{orig_x}"
#   puts "      y = #{orig_y}"
#   # Loop across the same code several times
#   for step in 1..stairs
#     group = entities.add_group
#     # Calculate our stair corners.
#     x1 = orig_x
#     x2 = width + orig_x
#     y1 = run * step + gap
#     y2 = run * (step + 1)
#     z = rise * step
#
#     # Create a series of "points", each a 3-item array containing x, y, and z.
#     pt1 = [x1, y1, z]
#     pt2 = [x2, y1, z]
#     pt3 = [x2, y2, z]
#     pt4 = [x1, y2, z]
#
#     # Call methods on the Entities collection to draw stuff.
#     new_face = group.entities.add_face pt1, pt2, pt3, pt4
#     new_face.pushpull thickness
#
#   end
#
# end
# #
#
# class MyTool
#       def activate
#         puts 'Your tool has been activated.'
#       end
#
#       def onLButtonDown(flags, x, y, view)
#         wikihouse_it!(view)
#       #  draw_stairs(x,y)
#         puts "onLButtonDown: flags =  #{flags}"
#    puts "                   x = #{x}"
#    puts "      y = #{y}"
#    puts "                view = #{view}"
#  end
#      end
