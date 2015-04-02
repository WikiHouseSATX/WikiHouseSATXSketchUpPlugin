#This module is just a collection of helper methods to make it easier
# to interact with SketchUp.
#All the other classes call Sk. if they want to draw or do things in the
#SketchUp model.

module Sk

  extend self
  def model
    Sketchup.active_model
  end
  def start_operation(op_name, disable_ui: false, transparent: false, prev_trans: false)
    model.start_operation(op_name, disable_ui, transparent, prev_trans)
  end
  def commit_operation
   model.commit_operation
  end
  def abort_operation
    model.abort_operation
  end
  def active_entities
    model.active_entities
  end

  def round(val)
    val.to_f.round(4)
  end

  def degrees_to_radians(degrees)
    degrees.to_f * Math::PI / 180
  end

  def radians_to_degrees(radians)
    radians.to_f / Math::PI / 180
  end

  def vertex_to_s(vertex)
    point_to_s(vertex.position)
  end

  def point_to_s(point)
    "X:#{point.x} Y:#{point.y} Z:#{point.z}"
  end

  def edge_to_s(edge)
    "Edge: start #{point_to_s(edge.start.position)} end #{point_to_s(edge.end.position)}"
  end

  def color_material(name, color: nil)

    Sketchup.active_model.materials.each do |mat|
      return mat if mat.name == name
    end

    mat = Sketchup.active_model.materials.add name
    mat.color = color
    mat
  end

  def move_to!(group, point)
    return if !group
    point3d = Geom::Point3d.new 10, 0, 0
    t = Geom::Alteration.new point3d
    group.move! t
    group
  end

  def rotate(group: group, point: nil, vector: nil, rotation: nil)
    tr = Geom::Alteration.rotation point, vector, rotation
    group.move! tr
  end

  def rotate!(group: group, point: nil, vector: nil, rotation: nil)

  end

  def slope(x1, y1, x2, y2)
    change_in_y = (y2 - y1)
    change_in_x = (x2 - x1)
    change_in_x == 0 ? nil : change_in_y/change_in_x
  end

  def build_parallelogram_points(x1, y1, b_length, h_length, x1_angle_in_degrees)
    c1 = [x1, y1, 0]
    c2 = [x1 + b_length, y1, 0]
    bottom_triangle_leg = h_length/Math.tan(self.class.degrees_to_radians(x1_angle_in_degrees))
    puts "#{x1} #{b_length} #{h_length} #{bottom_triangle_leg}"
    if x1_angle_in_degrees > 90
      c3 = [x1 + b_length + -bottom_triangle_leg, y1 - h_length, 0]

    else
      c3 = [x1 + b_length + bottom_triangle_leg, y1 - h_length, 0]
    end


    c4 = [c3.x - b_length, c3.y, 0]
    [c1, c2, c3, c4]
  end

  def draw_parallelogram(x1, y1, b_length, h_length, x1_angle_in_degrees, omit_sides: [], group: nil)

    c1, c2, c3, c4 = build_parallelogram_points(x1, y1, b_length, h_length, x1_angle_in_degrees)

    edges = []
    edges << draw_line(c1, c2, group: group) unless omit_sides.include? :s1
    edges << draw_line(c2, c3, group: group) unless omit_sides.include? :s2
    edges << draw_line(c3, c4, group: group) unless omit_sides.include? :s3
    edges << draw_line(c4, c1, group: group) unless omit_sides.include? :s4
    edges
  end

  def draw_triangle(x1, y1, x2, y2, x3, y3, omit_sides: [], group: nil)
    p1 = [x1, y1, 0]
    p2 = [x2, y2, 0]
    p3 = [x3, y3, 0]
    edges = []
    edges << draw_line(p1, p2, group: group) unless omit_sides.include? :s1
    edges << draw_line(p2, p3, group: group) unless omit_sides.include? :s2
    edges << draw_line(p3, p1, group: group) unless omit_sides.include? :s3

    edges
  end

  def build_box(top_right_x, top_right_y, bottom_left_x, bottom_left_y)
    c1 = [bottom_left_x, top_right_y, 0]
    c2 = [top_right_x, top_right_y, 0]
    c3 = [top_right_x, bottom_left_y, 0]
    c4 = [bottom_left_x, bottom_left_y, 0]

    [c1, c2, c3, c4]
  end

  def draw_box(top_right_x, top_right_y, bottom_left_x, bottom_left_y, omit_sides: [], group: nil)

    c1, c2, c3, c4 = build_box(top_right_x, top_right_y, bottom_left_x, bottom_left_y)
    edges = []
    edges << draw_line(c1, c2, group: group) unless omit_sides.include? :s1
    edges << draw_line(c2, c3, group: group) unless omit_sides.include? :s2
    edges << draw_line(c3, c4, group: group) unless omit_sides.include? :s3
    edges << draw_line(c4, c1, group: group) unless omit_sides.include? :s4
    edges
  end

  def draw_line(pt1, pt2, group: nil)

    #	puts "*******> DrawLine called without Group #{self.class}" unless group
    begin
      group ? group.entities.add_line(pt1, pt2) : Sketchup.active_model.active_entities.add_line(pt1, pt2)
    rescue ArgumentError, e
      puts "Unable to make a line from #{pt1} #{pt2}"
      raise
    end
  end

  def draw_circle(center_point: nil, radius: nil, numsegs: 24, normal: nil, group: nil)
    normal ||= Geom::Vector3d.new 0,0,1
    group ? group.entities.add_circle(center_point, normal, radius, numsegs) : Sketchup.active_model.active_entities.add_circle(center_point, normal, radius, numsegs)
  end
  def draw_all_points(pts, group: nil)
    lines = []
    pts.each_with_index do |pt, index|
      if index + 1 < pts.length
        lines << draw_line(pt, pts[index + 1])
      else
        lines << draw_line(pt, pts[0])
      end
    end

    lines
  end

  def draw_points(pts, group: nil)
    lines = []
    pts.each_with_index do |pt, index|
      if index + 1 < pts.length
        lines << draw_line(pt, pts[index + 1])
      end
    end

    lines
  end

  def erase_line(pt1, pt2)
    line = draw_line(pt1, pt2)
    line.erase! if line
  end

  def add_face(lines)
    Sketchup.active_model.active_entities.add_face(lines)
  end

  def add_group(lines = nil)
    if lines
      Sketchup.active_model.active_entities.add_group(lines)
    else
      Sketchup.active_model.active_entities.add_group
    end
  end

  def add_global_group
    Sketchup.active_model.entities.add_group
  end

  def set_attribute(item, dictionary, key, value)
    item.set_attribute(dictionary, key, value)
  end

  def get_attribute(item, dictionary, key)
    item.get_attribute(dictionary, key)
  end

  def copy_group(destination_group: nil, source_group: nil)
    raise ArgumentError if destination_group.nil? || source_group.nil?
    #http://sketchucation.com/forums/viewtopic.php?f=180&t=37940#p439270
    gcopy = destination_group.entities.add_instance(source_group.entities.parent, source_group.transformation)
    gcopy.name = source_group.name
    gcopy
  end
  def nest_group(destination_group: nil, source_group: nil)
    gcopy = copy_group(destination_group: destination_group, source_group: source_group)
    source_group.erase!
    gcopy
  end

  def find_layer(name)
    Sketchup.active_model.layers.each do |layer|
      return layer if layer.name == name
    end
    nil
  end

  def create_layer(name)
    Sketchup.active_model.layers.add name
  end

  def find_or_create_layer(name: name)
    layer = find_layer(name)
    if !layer
      layer = create_layer(name)
    end
    layer
  end

  def make_layer_active_name(name: name)
    layer = find_layer(name)
    layer ? make_layer_active(layer) : raise(ArgumentError, "Unable to find the #{name} layer")
  end

  def make_layer_active(layer)
    Sketchup.active_model.active_layer = layer
  end

  def current_active_layer
    Sketchup.active_model.active_layer
  end

  def edge_count(list)
    list.find_all { |e| e.typename == "Edge" && !e.deleted? }.count
  end

  def face_count(list)
    list.find_all { |e| e.typename == "Face" && !e.deleted? }.count
  end

  def add_material(material_name, filename: nil)
    mats = Sketchup.active_model.materials
    if !mats.collect { |m| m.name }.include?(material_name)

      new_mat = mats.add material_name
      new_mat.texture = filename if filename
      return new_mat
    else
      mats.each {|m| return m if m.name == material_name}
    end

  end
  def find_group_by_name(name, match_ok: true)
    Sketchup.active_model.entities.each do |e|
      if e.typename == "Group" && e.name == name || (match_ok && e.name.match(name))
        return(e)
      end
    end
    nil
  end
end