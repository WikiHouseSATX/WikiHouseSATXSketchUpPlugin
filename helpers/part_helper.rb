#Because we pull up to make the thickness of a part - the origin tracks bounds #2 - (left back bottom)

module WikiHouse::PartHelper

  DEFAULT_MATERIAL = "Wood_Plywood_Knots"

  def self.tag_dictionary
    "WikiHouse"
  end
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
      def tag_dictionary
       WikiHouse::PartHelper.tag_dictionary
      end
  end
  attr_reader :sheet, :group, :label

  def part_init(sheet: nil, group: nil, origin: nil, label: nil)
    @sheet = sheet ? sheet : WikiHouse::Sheet.new

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

  def mark_cutable!
    set_tag(tag_name: "cutable", value: true)
  end

  def mark_primary_face!(face)
    Sk.set_attribute(face, tag_dictionary, "primary_face", true)
  end
  def mark_inside_edge!(edge)
   set_tag(entity: edge, tag_name: "inside_edge", value: true)
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

  def set_tag(tag_name: nil, value: nil, entity: nil)
    return nil if entity.nil? && group.nil?
    if entity
      entity.set_attribute tag_dictionary, tag_name, value
    else
      group.set_attribute tag_dictionary, tag_name, value
    end
  end

  def get_tag(tag_name: nil, entity: nil)
    return nil if entity.nil? && group.nil?
    if entity
      entity.get_attribute tag_dictionary, tag_name
    else
      group.get_attribute tag_dictionary, tag_name
    end

  end

  def remove_tag(tag_name: nil, entity: nil)
    return nil if entity.nil? && group.nil?
    if entity
      entity.delete_attribute tag_dictionary, tag_name
    else
      group.delete_attribute tag_dictionary, tag_name
    end

  end

  def tag_dictionary
    WikiHouse::PartHelper.tag_dictionary
  end

end