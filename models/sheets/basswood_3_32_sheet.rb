class WikiHouse::Basswood332Sheet < WikiHouse::Sheet
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
    vertical? ? 8 : 24
  end

  def length
    vertical? ? 24 : 8
  end

  def thickness
    0.0938
  end

  def margin
    0.125
  end
  def self.material_name
    "Wood_Basswood"
  end
  def self.material_filename
    WikiHouse.plugin_file("basswood.jpg", "images")
  end
end