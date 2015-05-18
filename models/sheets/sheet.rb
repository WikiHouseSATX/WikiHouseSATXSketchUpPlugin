class WikiHouse::Sheet

  include WikiHouse::PartHelper
  attr_reader :origin, :orientation

  def initialize (origin: nil, orientation: :vertical, flat: false, label: nil)
   #origin is lower left corner
    part_init(origin: origin, sheet: self, label: label)
    @orientation = orientation == :horizontal ? :horizontal : :vertical
    @flat = flat
  end

  def flat?
    @flat ? true : false
  end



  def width_with_margin
    width - margin * 2
  end

  def length_with_margin
    length - margin * 2
  end

  def fits_on_sheet?(edge_length)
    edge_length < width_with_margin.to_l || edge_length < length_with_margin.to_l ? true : false
  end

  def self.material_name
    "Wood_Plywood_Knots"
  end
  def self.material_filename
    WikiHouse.plugin_file("plywood.jpg", "images")
  end
  def self.active_material_name
    "Active_Face_Material"
  end
  def self.active_material_filename
    WikiHouse.plugin_file("grass.jpg", "images")
  end
  def active_material
    #this is used to make a given face different for debugging
    Sk.add_material(self.class.active_material_name, filename: self.class.active_material_filename )
  end
  def material
    Sk.add_material(self.class.material_name, filename: self.class.material_filename )
  end
  def draw!

    if flat?
      c1 = [origin.x , origin.y + length, origin.z]
      c2 = [origin.x + width, c1.y, origin.z]
      c3 = [c2.x, origin.y, origin.z]
      c4 = origin
      lines = Sk.draw_all_points([c1, c2, c3, c4])

      face = Sk.add_face(lines)
      set_group(face.all_connected)

    else
      raise ScriptError, "No code for sheet with thickness"
    end
  end
end
