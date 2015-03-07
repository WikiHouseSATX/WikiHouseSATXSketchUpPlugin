class WikiHouse::Joint
  attr_reader :joiner
  def initialize(joiner)
    @joiner = joiner
  end
  def total_height
    @total_height
  end
  def sheet
    @joiner ? @joiner.sheet : nil
  end
  def set_total_height_from_line(start, finish, orientation)
    index = orientation == :y ? 0 : 1

    @total_height = (finish[index] - start[index]).abs
  end
  def join!(face,start, finish, orientation = :x)
    raise ArgumentError, "You must override this method"
  end
end
