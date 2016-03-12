#this class handles building up transformations before they are applied
# tr = WikiHouse::Alter.new(group: group)
# tr.rotate.move.scale.go!
# tr.rotate!
# tr.rotate.move!

class WikiHouse::Alteration
  def initialize(part: part)
    @part = part
    @operations = []
    self
  end
  def clone
    @operations << @part.group.transformation
    self
  end
  def go!
    unless @operations.length == 0

      #puts "Part Origin before: #{@part.origin}"
      @part.alter! @operations.inject(:*)
      @operations = []
      #  puts "Part Origin after: #{@part.origin}"
    end
    self
  end

  def rotate!(point: nil, vector: nil, rotation: nil)
    rotate(point: point, vector: vector, rotation: rotation)
    go!
  end

  def move_by!(x: 0, y: 0, z: 0)
    move_by(x: x, y: y, z: z)
    go!

  end

  def move_to!(point: nil)
    move_to(point: point)
    go!
  end

  def scale!(arg1, arg2 = nil, arg3 = nil, arg4 = nil)
    scale(arg1, arg2, arg3, arg4)
    go!
  end

  def rotate(point: nil, vector: nil, rotation: nil)
    point ||= @part.origin
    raise ArgumentError, "You must provide a vector" unless vector
    raise ArgumentError, "You must provide a rotation" unless rotation
    @operations << Geom::Transformation.rotation(Geom::Point3d.new(point), vector, rotation)
    self
  end

  def move_to(point: nil)
    point ||= @part.origin
    @operations << Geom::Transformation.new(Geom::Point3d.new(point))
    self
  end

  def move_by(x: 0, y: 0, z: 0)
    @operations << Geom::Transformation.translation(Geom::Vector3d.new(x, y, z))
    self
  end

  def scale(arg1, arg2 = nil, arg3 = nil, arg4 = nil)
    if arg1 && arg2 && arg3 && arg4
      #With four arguments it does a non-uniform scale about an arbitrary point.
      @operations << Geom::Transformation.scaling(arg1, arg2, arg3, arg4)

    elsif arg1 && arg2 && arg3
      #With three arguments, it does a non-uniform scale about the origin.
      @operations << Geom::Transformation.scaling(arg1, arg2, arg3)
    elsif arg1 && arg2
      #With two arguments, it does a uniform scale about an arbitrary point.
      @operations << Geom::Transformation.scaling(arg1, arg2)
    else
      #With one argument, it does a uniform scale about the origin.
      @operations << Geom::Transformation.scaling(arg1)
    end
    self
  end

  def flip_x(point: nil)
    point ||= @part.origin
    scale(point, -1, 1, 1)

    self
  end

  def flip_y(point: nil)
    point ||= @part.origin
    scale(point, 1, -1, 1)
    self
  end

  def flip_z(point: nil)
    point ||= @part.origin
    scale(point, 1, 1, -1)
    self
  end

  def flip_x!(point: nil)
    flip_x(point: point)
    go!
  end

  def flip_y!(point: nil)
    flip_y(point: point)
    go!
  end

  def flip_z!(point: nil)
    flip_z(point: point)
    go!
  end
end