class WikiHouse::ImperialPlywood34Sheet < WikiHouse::Sheet
  def units
    :inches
  end

  def horizontal?
    @orientation == :horizontal
  end

  def vertical?
    !horizontal?
  end

  def width
    vertical? ? 48 : 96
  end

  def length
    vertical? ? 96 : 48
  end

  def thickness
    0.75
  end

  def margin
    0.5
  end
  def self.material_name
    "Wood_Plywood_Knots"
  end
  def self.material_filename
    WikiHouse.plugin_file("plywood.jpg", "images")
  end
  def self.active_material_filename
    WikiHouse.plugin_file("arrow_up.jpg","images")
  end

end