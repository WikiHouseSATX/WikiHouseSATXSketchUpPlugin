#Because we pull up to make the thickness of a part - the origin tracks bounds #2 - (left back bottom)

module WikiHouse::PartHelper
  include WikiHouse::AttributeHelper


  attr_reader :sheet, :group, :label, :parent_part, :component

  def part_init(sheet: nil, component: nil, group: nil, origin: nil, label: nil, parent_part: nil)
    @sheet = sheet ? sheet : WikiHouse.sheet.new
    @parent_part = parent_part
    @group = group
    @component = component
    @origin = origin ? origin : [0, 0, 0]
    # puts "#{self.class.name} origin #{Sk.point_to_s(@origin)}"
    @label = label
    @active_part = false

  end

  def entities
    if component
      return component.definition.entities

    end
    group ? group.entities : []
  end

  def component?
    @component.nil? ? false : true
  end

  def active_part?
    @active_part ? true : false
  end

  def activate_part!
    @active_part = true
  end

  def drawn?
    @group ? true : false
  end

  def bounds
    if component
      return component.definition.bounds
    end
    group ? group.bounds : nil
  end

  def bound_length

  end

  def full_label
    "#{self.class.name} #{@label}".strip
  end

  def origin
    @origin
  end

  def origin=(o)
    @origin = o
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

  # def copy
  #
  # end

  def alter!(transformation, undoable: true)
    #Warning move and transform behave differently
 #   puts "Origin before #{@origin}"
    if group
      if undoable
        group.transform! transformation
      else
        group.move! transformation

      end

      @origin = [transformation.origin.x + @origin.x,
                 transformation.origin.y + @origin.y,
                 transformation.origin.z + @origin.z]
    elsif component
      if undoable
        component.transform! transformation
      else
        component.move! transformation

      end

      @origin = [transformation.origin.x + @origin.x,
                 transformation.origin.y + @origin.y,
                 transformation.origin.z + @origin.z]
    end

  end

  def set_layer(layer_name)
    entities.each { |e| e.layer = layer_name }
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

  def clone()
    alteration.clone
  end

  def rotate(point: nil, vector: nil, rotation: nil)
    alteration.rotate(point: point, vector: vector, rotation: rotation)
  end

  def rotate!(point: nil, vector: nil, rotation: nil)
    alteration.rotate!(point: point, vector: vector, rotation: rotation)
  end

  def scale(arg1, arg2 = nil, arg3 = nil, arg4 = nil)
    alteration.scale(arg1, arg2 = nil, arg3 = nil, arg4 = nil)
  end

  def scale!(arg1, arg2 = nil, arg3 = nil, arg4 = nil)
    alteration.scale!(arg1, arg2 = nil, arg3 = nil, arg4 = nil)
  end

  def flip_x(point: nil)
    alteration.flip_x(point: point)
  end

  def flip_x!(point: nil)
    alteration.flip_x!(point: point)
  end

  def flip_y(point: nil)
    alteration.flip_y(point: point)
  end

  def flip_y!(point: nil)
    alteration.flip_y!(point: point)
  end

  def flip_z(point: nil)
    alteration.flip_z(point: point)
  end

  def flip_z!(point: nil)
    alteration.flip_z!(point: point)
  end

  def group= (new_group)
    @group = new_group
  end

  def set_group(new_entities)
    @group = Sk.add_group new_entities
    @group.name = full_label
    set_default_properties
  end

  def set_default_properties

  end

  def set_material(face, face_material: nil)
    if face_material.nil?
      face_material = active_part? ? sheet.active_material : sheet.material
    end
    face.material = face_material
  end


  def sub_group(new_entities, label: nil)
    sub_group = Sk.add_group new_entities
    sub_group.name = label if label
    sub_group
  end

  def face_front_long!
    WikiHouse::Direction.front().apply(self)
  end
  def face_front_wide!
    WikiHouse::Direction.front(length_up: false).apply(self)
  end
  def face_back_long!
    WikiHouse::Direction.back().apply(self)
  end
  def face_back_wide!
    WikiHouse::Direction.back(length_up: false).apply(self)
  end
  def face_left_long!
    WikiHouse::Direction.left().apply(self)
  end
  def face_left_wide!
    WikiHouse::Direction.left(length_up: false).apply(self)
  end
  def face_right_long!
    WikiHouse::Direction.right().apply(self)
  end
  def face_right_wide!
    WikiHouse::Direction.right(length_up: false).apply(self)
  end
  def face_top_long!
    WikiHouse::Direction.top().apply(self)
  end
  def face_top_wide!
    WikiHouse::Direction.top(length_up: false).apply(self)
  end
  def face_bottom_long!
    WikiHouse::Direction.bottom().apply(self)
  end
  def face_bottom_wide!
    WikiHouse::Direction.bottom(length_up: false).apply(self)
  end
end