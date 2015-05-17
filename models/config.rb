class WikiHouse::Config
  def self.machine
    #WikiHouse::Laser
    WikiHouse::Cnc
  end
  def self.sheet
   #  WikiHouse::ImperialPlywood2332Sheet
    WikiHouse::ImperialPlywood34Sheet
   # WikiHouse::ImperialFiberboardSheet
  end
end