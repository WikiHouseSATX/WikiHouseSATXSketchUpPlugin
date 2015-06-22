class WikiHouse::NestablePart
  include WikiHouse::PartHelper
  attr_accessor :fit

  def initialize(sheet: nil, group: nil, origin: nil, label: nil)
    part_init(sheet: sheet, group: group, origin: origin, label: label)
  end

  def max_length_width
    bounds.height > bounds.width ? bounds.height : bounds.width
  end

  def bound_length
    bounds.height
  end

  def bound_width
    bounds.width
  end

  def bound_area
    bound_width * bound_length
  end
end