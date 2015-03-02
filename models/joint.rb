class Joint
  def initialize(joiner)
    @joiner = joiner
  end
  def join!(start, finish, orientation = :x)
    raise ArgumentError, "You must override this method"
  end
end
