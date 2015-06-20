class WikiHouse::Orientation
  NORTH_FACE ||= 2
  EAST_FACE ||= 1
  SOUTH_FACE ||= 0
  WEST_FACE ||= 3
  attr_reader :face_index
  def initialize(face_index: nil)
    @face_index = face_index
  end

  def face_label
    return "North" if @face_index == NORTH_FACE
    return "East" if @face_index == EAST_FACE
    return "South" if @face_index == SOUTH_FACE
    return "West" if @face_index == WEST_FACE
    "Unknown"
  end
  def ==(other)
    other.face_index == self.face_index
  end
  def north?
    @face_index == NORTH_FACE
  end
  def east?
    @face_index == EAST_FACE
  end
  def south?
    @face_index == SOUTH_FACE
  end
  def west?
    @face_index == WEST_FACE
  end
  def self.north
    WikiHouse::Orientation.new(face_index: NORTH_FACE)
  end
  def self.east
    WikiHouse::Orientation.new(face_index: EAST_FACE)
  end
  def self.south
    WikiHouse::Orientation.new(face_index: SOUTH_FACE)
  end
  def self.west
    WikiHouse::Orientation.new(face_index: WEST_FACE)
  end
end