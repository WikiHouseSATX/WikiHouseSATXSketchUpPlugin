class WikiHouse::Meranti27mmSheet < WikiHouse::Sheet
  #2.7mm
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
    vertical? ? 12 : 24
  end

  def length
    vertical? ? 21 : 8
  end

  def thickness
    0.106
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