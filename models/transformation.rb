#this class handles building up transformations before they are applied
# tr = WikiHouse::Transformation.new(group: group)
# tr.rotate.move.scale.go!
# tr.rotate!
# tr.rotate.move!

class WikiHouse::Transformation
  def initalize(group: group)

    @group = group
    @operations = []
    self
  end
  def go!

  end

  def rotate!

  end

  def move!

  end

  def translate!

  end

  def scale!

  end

  def rotate

  end

  def move

  end
  def translate

  end
  def scale

  end
end