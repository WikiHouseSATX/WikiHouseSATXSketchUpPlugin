#Because we pull up to make the thickness of a part - the origin tracks bounds #2 - (left back bottom)

module WikiHouse::PartHelper

  DEFAULT_DICTIONARY = "WikiHouse" unless defined? DEFAULT_DICTIONARY

  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods

  end
  attr_reader :sheet, :group, :label

  def part_init(sheet: nil, group: nil, origin: nil, label: nil)
    @sheet = sheet ? sheet : WikiHouse::Sheet.new

    @group = group
    @origin = origin ? origin : [0, 0, 0]
    @label = label
  end
  def full_label
    "#{self.class.name} #{@label}".strip
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

  def alter!(transformation, undoable: false)
    if @group
      if undoable
        @group.transform! transformation
      else
        @group.move! transformation

      end

      @origin = transformation.origin

    end

  end

  def alteration
    WikiHouse::Alteration.new(part: self)
  end

  def move_to(point: nil)
    alteration.move_to(point: point)
  end

  def move_to!(point: nil)
    alteration.move_to!(point: point)
  end
  def move_by(x: 0, y: 0, z: 0)
    alteration.move_by(x: x, y: y, z: z)
  end

  def move_by!(x: 0, y: 0, z: 0)
    alteration.move_by!(x: x, y: y, z: z)
  end

  def rotate(point: nil, vector: nil, rotation: nil)
    alteration.rotate(point: point, vector: vector, rotation: rotation)
  end

  def rotate!(point: nil, vector: nil, rotation: nil)
    alteration.rotate!(point: point, vector: vector, rotation: rotation)
  end
  def set_group(entities)
    @group = Sk.add_group entities
    @group.name = full_label
  end
  def sub_group(entities, label: nil)
    sub_group = Sk.add_group entities
    sub_group.name = label if label
    sub_group
  end
end