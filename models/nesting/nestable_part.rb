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
  def bound_margin
    WikiHouse::Config.machine.nesting_part_gap
  end
  def bound_length_with_margin
    bound_length + bound_margin
  end

  def bound_width_with_margin
    bound_width + bound_margin
  end

  def bound_area_with_margin
    bound_length_margin * bound_width_margin
  end
end