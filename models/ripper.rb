#This class handles dividing up a given part
class WikiHouse::Ripper
  def initialize(sheet)
    @sheet = sheet
  end
  def divide(max_length)
    edge_divisor = nil
    (2..10).each do |divisor|
      possible_edge_length = max_length / divisor.to_f
      if @sheet.fits_on_sheet?(possible_edge_length)
        edge_divisor = divisor.to_f
        break
      end

    end
    edge_divisor
  end
end
