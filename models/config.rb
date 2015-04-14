class WikiHouse::Config
  def self.machine
    WikiHouse::Laser
  end
  def self.sheet
   #  WikiHouse::ImperialPlywoodSheet
    WikiHouse::ImperialFiberboardSheet
  end
end