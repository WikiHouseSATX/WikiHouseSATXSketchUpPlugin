#Copyright 2015 WikiHouseSATX 


def sheet_width(unit = "inches")
  48
end
def sheet_length(unit = "inches")
  96
end
def sheet_thickness(unit = "inches")
  0.71
end
def sheet_margin(unit="inches")
  0.5
end

def draw_stairs(orig_x = 0, orig_y = 0)
  prompts = ["# of Sheets", "Length (In)", "Width (In)", "Thickness(In)"]
  defaults = [10, sheet_length, sheet_width, sheet_thickness ]
#  list = ["", "", "Male|Female"]
  input = UI.inputbox(prompts, defaults, "What are your sheets?")

  # Create some variables.
  stairs = input[0]
  #rise = 8
  rise = 0 #0 means floor
  run = input[1] #0 means fence
  width = input[2]
  thickness = input[3]
  gap = 24
  # Get handles to our model and the Entities collection it contains.
  model = Sketchup.active_model
  entities = model.entities
  puts "                   x = #{orig_x}"
  puts "      y = #{orig_y}"
  # Loop across the same code several times
  for step in 1..stairs
    group = entities.add_group
    # Calculate our stair corners.
    x1 = orig_x
    x2 = width + orig_x
    y1 = run * step + gap
    y2 = run * (step + 1)
    z = rise * step

    # Create a series of "points", each a 3-item array containing x, y, and z.
    pt1 = [x1, y1, z]
    pt2 = [x2, y1, z]
    pt3 = [x2, y2, z]
    pt4 = [x1, y2, z]

    # Call methods on the Entities collection to draw stuff.
    new_face = group.entities.add_face pt1, pt2, pt3, pt4
    new_face.pushpull thickness

  end

end
# Add a menu item to launch our plugin.
UI.menu("Plugins").add_item("Draw stairs") {
#  UI.messagebox("I'm about to draw stairs!")
#  UI.messagebox("Here they come")
  # Call our new method.
  my_tool = MyTool.new
Sketchup.active_model.select_tool(my_tool)


  #  draw_stairs(my_tool)
}

UI.add_context_menu_handler do |context_menu|
  context_menu.add_item("Hello World") {
    UI.messagebox("Hello world")
  }
end

class MyTool
      def activate
        puts 'Your tool has been activated.'
      end

      def onLButtonDown(flags, x, y, view)
        draw_stairs(x,y)
        puts "onLButtonDown: flags =  #{flags}"
   puts "                   x = #{x}"
   puts "      y = #{y}"
   puts "                view = #{view}"
 end
     end
