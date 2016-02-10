class WikiHouse::BalticBirch42Sheet < WikiHouse::Sheet
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
    vertical? ? 12 : 12
  end

  def length
    vertical? ? 12 : 12
  end

  def thickness
    0.125
  end

  def margin
    0.125
  end
  def self.material_name
    "Wood_BalticBirch"
  end
  def self.material_filename
    WikiHouse.plugin_file("basswood.jpg", "images")
  end
end