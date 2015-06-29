#Because we pull up to make the thickness of a part - the origin tracks bounds #2 - (left back bottom)

module WikiHouse::PartHelper
  include WikiHouse::AttributeHelper



  attr_reader :sheet, :group, :label, :parent_part

  def part_init(sheet: nil, group: nil, origin: nil, label: nil, parent_part: nil)
    @sheet = sheet ? sheet : WikiHouse.sheet.new
    @parent_part = parent_part
    @group = group
    @origin = origin ? origin : [0, 0, 0]
   # puts "#{self.class.name} origin #{Sk.point_to_s(@origin)}"
    @label = label
    @active_part = false

  end

  def active_part?
    @active_part ?  true  : false
  end
  def activate_part!
    @active_part = true
  end
  def drawn?
    @group ? true : false
  end
  def bounds
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

  def set_layer(layer_name)
    @group.entities.each { |e| e.layer = layer_name }
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

  def group= (new_group)
    @group = new_group
  end

  def set_group(entities)
    @group = Sk.add_group entities
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


  def sub_group(entities, label: nil)
    sub_group = Sk.add_group entities
    sub_group.name = label if label
    sub_group
  end


end