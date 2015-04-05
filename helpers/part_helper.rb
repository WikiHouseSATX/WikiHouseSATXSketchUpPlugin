#Because we pull up to make the thickness of a part - the origin tracks bounds #2 - (left back bottom)

module WikiHouse::PartHelper
  include WikiHouse::AttributeHelper
  DEFAULT_MATERIAL = "Wood_Plywood_Knots"


  attr_reader :sheet, :group, :label, :parent_part

  def part_init(sheet: nil, group: nil, origin: nil, label: nil, parent_part: nil)
    @sheet = sheet ? sheet : WikiHouse::Sheet.new
    @parent_part = parent_part
    @group = group
    @origin = origin ? origin : [0, 0, 0]
    @label = label
  end

  def bounds
    group ? group.bounds : nil
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

  def set_material(face, material: nil)
    if material.nil?
      material = Sk.add_material(DEFAULT_MATERIAL, filename: WikiHouse.plugin_file("plywood.jpg", "images"))
    end
    face.material = material
  end

  def sub_group(entities, label: nil)
    sub_group = Sk.add_group entities
    sub_group.name = label if label
    sub_group
  end


end