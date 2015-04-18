class WikiHouse::Config
  def self.machine
    #WikiHouse::Laser
    WikiHouse::Cnc
  end
  def self.sheet
     WikiHouse::ImperialPlywoodSheet
   # WikiHouse::ImperialFiberboardSheet
  end
end