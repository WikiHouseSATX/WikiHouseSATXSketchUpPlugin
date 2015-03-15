module WikiHouse::PartHelper

  DEFAULT_DICTIONARY = "WikiHouse" unless defined? DEFAULT_DICTIONARY

  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods

  end
  attr_reader :sheet, :group

  def part_init(sheet: nil, group: nil, origin: nil)
    @sheet = sheet ? sheet : WikiHouse::Sheet.new

    @group = group
    @origin = origin ? origin : [0,0,0]

  end
   def origin
    @origin
   end
  def draw!
    raise ScriptError, "You need to override this is method"
  end

  def thickness
    @sheet.thickness
  end

  def make_part_right_thickness(face)
    face.reverse!
    face.pushpull thickness
  end

  def copy

  end

  def move_to!(point)
    Sk.move_to!(group, point)
    @origin = point
  end

end