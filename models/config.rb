require 'ostruct'
class WikiHouse::Config
  def self.machine
  # WikiHouse::Laser
    WikiHouse::Cnc
  end
  def self.sheet
  #  WikiHouse::ImperialPlywood2332Sheet
    WikiHouse::ImperialPlywood34Sheet
 # WikiHouse::ImperialFiberboardSheet
  end
  def self.current_part
    parent_part = OpenStruct.new
    parent_part.length = 92/2.0
    parent_part.width = 92/2.0
    parent_part.depth = 10
    WikiHouse::WallPanelCap.new(label: "Top", origin: [0,0,0],  parent_part: parent_part)

  end
end