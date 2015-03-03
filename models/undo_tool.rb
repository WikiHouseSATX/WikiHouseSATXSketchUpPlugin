class UndoTool
  Tools.register(:undo, self)
	def activate
	#	puts 'Your tool has been activated.'
	end
	def deactivate(view)
		#puts "Your tool has been deactivated in view: #{view}"
	end
	def undo(x,y, view)
		ph = view.pick_helper
    ph.do_pick(x,y)
    face = ph.picked_face
    undo_face(face)
	end
  def undo_face(face)
    count = 0
    if face
      puts "Found a face #{face}"   if  WikiHouse::DEV_MODE
      while face.edges.count > 4 && count < 100
        Sketchup.undo
        count += 1
      end
      if face.edges.count > 4
        puts "Sorry couldn't undo enough to reset that face"
      else
        TransformerTool.last_face = nil
      end
    else
      puts "Didn't click on a face"
    end
  end
	def onLButtonDoubleClick(flags, x, y, view)
		#	wikihouse_it!(view)
		#  draw_stairs(x,y)
		undo(x,y,view)
		# if WikiHouse::LOG_ON
		# 	puts "onLButtonDown: flags =  #{flags}"
		# 	puts "                   x = #{x}"
		# 	puts "      y = #{y}"
		# 	puts "                view = #{view}"
		# end
	end
	def self.init
	#	puts "initializing the menu system"
		setup_toolbar if WikiHouse.build_menus?
	end
	def self.setup_toolbar
    tool = UndoTool.new
		cmd = UI::Command.new("WikiHouse Undo") {

			Sketchup.active_model.select_tool(tool)
      if TransformerTool.last_face
          tool.undo_face(TransformerTool.last_face)

  #        Sketchup.active_model.select_tool(nil)
#          Sketchup.active_model.select_tool(Tools.tool(:transformer)[:tool])
      end

		}
		cmd.small_icon = WikiHouse.plugin_file("WikiHouse_logo_12.png","images")
		cmd.large_icon = WikiHouse.plugin_file("WikiHouse_logo_24.png","images")
		cmd.tooltip = "WikiHouse Undo"
		cmd.status_bar_text = "Tries to Undo Until It is reset"
		cmd.menu_text = "WikiHouse Undo"
    Tools.add_to_toolbar(cmd)
    tool
	end

end
