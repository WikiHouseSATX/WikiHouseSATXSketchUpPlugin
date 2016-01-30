class WikiHouse::CoroplastSheet < WikiHouse::Sheet
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
    vertical? ? 24 : 12
  end

  def thickness
    0.169
  end

  def margin
    0.125
  end
  def self.material_name
    "Plastic_Coroplast"
  end
  def self.material_filename
    WikiHouse.plugin_file("coroplast.jpg", "images")
  end
end