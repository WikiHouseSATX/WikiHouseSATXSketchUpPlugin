
class WikiHouse::Cnc < WikiHouse::Machine
  class Bit
    attr_reader :name, :diameter

    def initialize(name: nil, diameter: nil)
      @name = name
      @diameter = diameter
    end
    def radius
      diameter/2.0
    end
  end
  def self.bit
    Bit.new(name: "1/4 Up-cut (52-910)", diameter: 0.25)
  end
  def self.nesting_part_gap
    bit_diameter * 2.0
  end
  def self.bit_diameter
    self.bit.diameter
  end
  def self.bit_radius
    self.bit.radius
  end
  def self.fillet?
    true
  end
  def self.xy_speed
    3.0
  end
  def self.z_speed
    1.0
  end
end