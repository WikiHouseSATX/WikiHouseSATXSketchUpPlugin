class WikiHouse::Sheet

  def units
    :inches
  end

  def width
    48
  end

  def length
    96
  end

  def thickness
    0.71
  end

  def margin
    0.5
  end

  def width_with_margin
    width - margin * 2
  end

  def length_with_margin
    length - margin * 2
  end

  def fits_on_sheet?(edge_length)
    edge_length < width_with_margin.to_l || edge_length < length_with_margin.to_l ? true : false
  end
end
