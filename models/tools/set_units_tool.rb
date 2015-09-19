class WikiHouse::SetUnitsTool
  WikiHouse::Tools.register(:set_units, self) if WikiHouse::DEV_MODE


  def self.init

    setup_toolbar if WikiHouse.build_menus?
  end


  def self.setup_toolbar
    tool = WikiHouse::ReloadTool.new
    cmd = UI::Command.new("WikiHouse Reload") {
      WikiHouse::Config.set_model_units
    }
    cmd.small_icon = WikiHouse.plugin_file("Tape-Measure-icon.png", "images")
    cmd.large_icon = WikiHouse.plugin_file("Tape-Measure-icon.png", "images")
    cmd.tooltip = "Make Model Decimal/4 Precision"
    cmd.status_bar_text = "Changes Model Units"
    cmd.menu_text = "Set Model Unit"
    WikiHouse::Tools.add_to_toolbar(cmd)
    tool
  end
end
