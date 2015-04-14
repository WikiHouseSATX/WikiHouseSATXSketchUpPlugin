
class WikiHouse::Cnc < WikiHouse::Machine

  def self.bit_diameter
    0.26
  end
  def self.bit_radius
    bit_diameter/2.0
  end
  def self.fillet?
    true
  end
end