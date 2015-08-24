class WikiHouse::FlattenTool
  WikiHouse::Tools.register(:flatten, self)

  def activate
    #	puts 'Your tool has been activated.'
    flattener = WikiHouse::Flattener.new()
    flattener.draw!
  end

  def deactivate(view)
    #puts "Your tool has been deactivated in view: #{view}"
  end


  def self.init
    #puts "initializing the menu system"
    setup_toolbar if WikiHouse.build_menus?
  end

  def self.setup_toolbar
    tool = WikiHouse::FlattenTool.new
    cmd = UI::Command.new("WikiHouse Flattener") {

      Sketchup.active_model.select_tool(tool)

    }

    # select_none.rb - adds "select none" option to context menu.
    UI.add_context_menu_handler { |menu|
      menu.add_item("Select None") {
        Sketchup.active_model.selection.clear
      }
      menu.add_item("Mark Flattenable") {
        WikiHouse::Flattener.mark_selection_flattenable
      }
      menu.add_item("Mark Primary Face") {
        WikiHouse::Flattener.mark_selection_primary_face
      }
      menu.add_item("Remove Flattenable") {
        WikiHouse::Flattener.remove_selection_flattenable
      }
      menu.add_item("Remove Primary Face") {
        WikiHouse::Flattener.remove_selection_primary_face
      }
    }

    cmd.small_icon = WikiHouse.plugin_file("steam_engine.png", "images")
    cmd.large_icon = WikiHouse.plugin_file("steam_engine.png", "images")
    cmd.tooltip = "WikiHouse Flattener"
    cmd.status_bar_text = "Finds all parts and makes them flat"
    cmd.menu_text = "WikiHouse Flattener"
    WikiHouse::Tools.add_to_toolbar(cmd)
    tool
  end

end
