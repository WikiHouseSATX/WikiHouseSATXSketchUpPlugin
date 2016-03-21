class WikiHouse::Direction
  TOP_FACE ||= 0
  BOTTOM_FACE ||= 1
  LEFT_FACE ||= 2
  RIGHT_FACE ||= 3
  FRONT_FACE ||= 4
  BACK_FACE ||=5

  attr_reader :face_direction

  def initialize(face_direction: nil, length_up: true)
    #Either the length is up or the width is up
    @face_direction = face_direction
    @length_up = length_up
  end

  def length_up?
    @length_up == true
  end

  def direction_label
    return "Top" if @face_direction == TOP_FACE
    return "Bottom" if @face_direction == BOTTOM_FACE
    return "Left" if @face_direction == LEFT_FACE
    return "Right" if @face_direction == RIGHT_FACE
    return "Front" if @face_direction == FRONT_FACE
    return "Back" if @face_direction == BACK_FACE
    "Unknown"
  end

  def ==(other)
    if other.respond_to?(:face_direction)
      other.face_direction == self.face_direction
    else
      self.face_direction == other
    end
  end


  def top?
    @face_direction == TOP_FACE
  end

  def bottom?
    @face_direction == BOTTOM_FACE
  end

  def left?
    @face_direction == LEFT_FACE
  end

  def right?
    @face_direction == RIGHT_FACE
  end

  def front?
    @face_direction == FRONT_FACE
  end

  def back?
    @face_direction == BACK_FACE
  end

  def current_direction(face)
    global_plane = Sk.face_to_global_plane(face)
    #The plane is returned as an Array of 4 numbers which are the coefficients of the plane equation Ax + By + Cz + D = 0.
    pa = global_plane[0]
    pb = global_plane[1]
    pc = global_plane[2]
    pd = global_plane[3]
    if ([pa, pb, pc] == [0.0, -1.0, 0.0])
      # front

      return :front
    elsif ([pa, pb, pc] == [-0.0, 1.0, -0.0])
      #back

      return :back
    elsif ([pa, pb, pc] == [0.0, -0.0, 1.0])
      #top

      return :top
    elsif ([pa, pb, pc] == [0.0, 0.0, -1.0])
      #bottom
      return :bottom
    elsif ([pa, pb, pc] == [-1.0, 0.0, 0.0])
      #left
      return :left
    elsif ([pa, pb, pc] == [1.0, -0.0, -0.0])
      #right
      return :right
    else
      raise ScriptError, "unable to determine current orientation"
    end

  end

  def apply(part)

    current = current_direction(part.primary_face)
    puts "Current: #{current}"
    if current == :top
      return if top?
      if length_up?
        part.rotate(vector: [0, 0, 1], rotation: 90.degrees).
            rotate(vector: [1, 0, 0], rotation: -180.degrees).go!
      else
        part.rotate(vector: [1, 0, 0], rotation: 180.degrees).go!
      end
      return if bottom?
    elsif current == :bottom
      return if bottom?
      #all the other moves are already in terms of bottom starting direction
    elsif current == :front
      return if front?

      if length_up?
        part.rotate(vector: [0, 0, 1], rotation: -90.degrees).
            rotate(vector: [0, 1, 0], rotation: -90.degrees).go!
      else
        part.rotate(vector: [1, 0, 0], rotation: 90.degrees).go!
      end
      return if bottom?
    elsif current == :back
      return if back?
      if length_up?
        part.move_by(x: -1 * part.thickness,
                     y: 0 * part.thickness,
                     z: 0).
            rotate(vector: [0, 0, 1], rotation: -270.degrees).
            rotate(vector: [0, 1, 0], rotation: -90.degrees).go!

      else
        part.move_by(x: -1 * part.thickness,
                     y: 0,
                     z: 0).
            rotate(vector: [0, 0, 1], rotation: -180.degrees).
            rotate(vector: [1, 0, 0], rotation: 90.degrees)..go!
      end
      return if bottom?
    elsif current == :left
      return if left?
      if length_up?
        part.rotate(vector: [0, 1, 0], rotation: -90.degrees).go!

      else
        part.rotate(vector: [1, 0, 0], rotation: -90.degrees).
            rotate(vector: [0, 1, 0], rotation: -90.degrees).go!

      end
      return if bottom?
    elsif current == :right
      return if right?
      if length_up?
        part.move_by(x: 0,
                     y: 0,
                     z: -1 * part.thickness).
            rotate(vector: [0, 1, 0], rotation: 90.degrees).go!
      else
        part.move_by(x: part.thickness,
                     y: 0,
                     z: 0).
            rotate(vector: [1.0, 0], rotation: 90.degrees).
            rotate(vector: [0, 1, 0], rotation: 90.degrees).go!
      end
      return if bottom?
    end
    if top?
      if length_up?
        part.rotate(vector: [1, 0, 0], rotation: 180.degrees).
            rotate(vector: [0, 0, 1], rotation: -90.degrees).go!
      else
        part.rotate(vector: [1, 0, 0], rotation: 180.degrees).go!
      end
    elsif bottom?
      if length_up?
        part.rotate(vector: [0, 0, 1], rotation: -90.degrees).
            move_by(x: 0,
                    y: 0,
                    z: part.thickness * -1).go!
      else
        part.rotate(vector: [0, 0, 1], rotation: 180.degrees).
            move_by(x: 0,
                    y: 0,
                    z: part.thickness * -1).go!
      end
    elsif left?
      if length_up?
        part.rotate(vector: [0, 1, 0], rotation: 90.degrees).go!

      else
        part.rotate(vector: [0, 1, 0], rotation: 90.degrees).
            rotate(vector: [1, 0, 0], rotation: 90.degrees).go!

      end
    elsif right?
      if length_up?
        part.rotate(vector: [0, 1, 0], rotation: -90.degrees).
            move_by(x: part.thickness,
                    y: 0,
                    z: 0).go!
      else
        part.rotate(vector: [0, 1, 0], rotation: -90.degrees).
            rotate(vector: [1.0, 0], rotation: -90.degrees).
            move_by(x: part.thickness,
                    y: 0,
                    z: 0).go!
      end
    elsif front?

      if length_up?
        part.rotate(vector: [0, 1, 0], rotation: 90.degrees).
            rotate(vector: [0, 0, 1], rotation: 90.degrees).go!
      else
        part.rotate(vector: [1, 0, 0], rotation: -90.degrees).go!
      end
    elsif back?
      if length_up?
        part.rotate(vector: [0, 1, 0], rotation: 90.degrees).
            rotate(vector: [0, 0, 1], rotation: 270.degrees).
            move_by(x: 0,
                    y: part.thickness,
                    z: 0).go!
      else
        part.rotate(vector: [1, 0, 0], rotation: -90.degrees).
            rotate(vector: [0, 0, 1], rotation: 180.degrees).
            move_by(x: 0,
                    y: part.thickness,
                    z: 0).go!
      end
    end
  end

  def self.top(length_up: true)

    WikiHouse::Direction.new(face_direction: TOP_FACE,
                             length_up: length_up)
  end

  def self.bottom(length_up: true)
    WikiHouse::Direction.new(face_direction: BOTTOM_FACE,
                             length_up: length_up)
  end

  def self.left(length_up: true)
    WikiHouse::Direction.new(face_direction: LEFT_FACE,
                             length_up: length_up)
  end

  def self.right(length_up: true)
    WikiHouse::Direction.new(face_direction: RIGHT_FACE,
                             length_up: length_up)
  end

  def self.front(length_up: true)

    WikiHouse::Direction.new(face_direction: FRONT_FACE,
                             length_up: length_up)
  end

  def self.back(length_up: true)

    WikiHouse::Direction.new(face_direction: BACK_FACE,
                             length_up: length_up)
  end

end