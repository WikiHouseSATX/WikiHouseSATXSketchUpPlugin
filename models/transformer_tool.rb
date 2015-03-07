class WikiHouse::TransformerTool
	WikiHouse::Tools.register(:transformer, self)
	def self.last_face=(face)
		puts "Face Id #{face.entityID}" if face
		@last_face = face

	end
	def self.last_face
		@last_face
	end
	def activate
	#	puts 'Your tool has been activated.'
	end
	def deactivate(view)
		#puts "Your tool has been deactivated in view: #{view}"
	end
	def transform(x,y, view)
		ph = view.pick_helper
    ph.do_pick(x,y)
    face = ph.picked_face
		if face
			puts "Found a face #{face}"   if  WikiHouse::DEV_MODE
			self.class.last_face = face
      part = WikiHouse::Part.new(face)
      part.wikize!
		else
			puts "Didn't click on a face"
		end
	end
	def onLButtonDoubleClick(flags, x, y, view)
		#	wikihouse_it!(view)
		#  draw_stairs(x,y)
		transform(x,y,view)
		# if WikiHouse::LOG_ON
		# 	puts "onLButtonDown: flags =  #{flags}"
		# 	puts "                   x = #{x}"
		# 	puts "      y = #{y}"
		# 	puts "                view = #{view}"
		# end
	end
	def self.init
		#puts "initializing the menu system"
		setup_toolbar if WikiHouse.build_menus?
	end
	def self.setup_toolbar
	  tool = WikiHouse::TransformerTool.new
		cmd = UI::Command.new("WikiHouse Transform") {

			Sketchup.active_model.select_tool(tool)

		}
		cmd.small_icon = WikiHouse.plugin_file("WikiHouse_logo_12.png","images")
		cmd.large_icon = WikiHouse.plugin_file("WikiHouse_logo_24.png","images")
		cmd.tooltip = "WikiHouse Transformer"
		cmd.status_bar_text = "Let's you pick a face to wikize"
		cmd.menu_text = "WikiHouse Transform"
		WikiHouse::Tools.add_to_toolbar(cmd)
	  tool
	end

end
