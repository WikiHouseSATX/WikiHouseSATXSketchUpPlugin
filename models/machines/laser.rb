class WikiHouse::Laser < WikiHouse::Machine
  def self.fillet?
    false
  end
  def self.nesting_part_gap
    0.126
  end
end