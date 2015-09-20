#This module is just a collection of helper methods to make it easier
#This module is just a collection of helper methods to make it easier
# to interact with SketchUp.
#All the other classes call Sk. if they want to draw or do things in the
#SketchUp model.

module Sk

  extend self

  def abs(val)
    val < 0 ? -1.0 * val : val
  end

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

  def entities
    model.entities
  end

  def erase_all!
    self.model.entities.each { |e| e.erase! }
  end

  def clear_selection
    Sketchup.active_model.selection.clear
  end

  def selection
    Sketchup.active_model.selection
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
    "X:#{point.x * 1.0} Y:#{point.y * 1.0 } Z:#{point.z * 1.0}"
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

  def slope(x1, y1, x2, y2)
    change_in_y = (y2 - y1)
    change_in_x = (x2 - x1)
    return nil if change_in_x.zero?
    return 0 if change_in_y.zero?
    change_in_y/change_in_x

  end

  #Ignores z for all calculations :(
  def point_at_distance(slope: nil, point: nil, distance: nil, direction: 1)
    if slope.nil?
      new_pt = [point.x + direction * distance, point.y, point.z]
    elsif slope.zero?
      new_pt = [point.x, point.y + direction * distance, point.z]
    else
      x = point.x + direction * (distance / Math.sqrt(1 + slope ** 2))
      y = slope * (x - point.x) + point.y
      new_pt = [x, y, point.z]
    end
    puts "Point at distance #{Sk.point_to_s(new_pt)}"
    new_pt
  end

  def midpoint(point_1: nil, point_2: nil, ignore_z: true)
    if ignore_z
      [(point_1.x + point_2.x)/2, (point_1.y + point_2.y)/2, point_1.z]
    else
      [(point_1.x + point_2.x)/2, (point_1.y + point_2.y)/2, (point_1.z + point_2.z)/2]
    end

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
    rescue ArgumentError
      puts "Unable to make a line from #{pt1} #{pt2}"
      raise
    end
  end

  def draw_circle(center_point: nil, radius: nil, numsegs: 24, normal: nil, group: nil)
    normal ||= Geom::Vector3d.new 0, 0, 1
    group ? group.entities.add_circle(center_point, normal, radius, numsegs) : Sketchup.active_model.active_entities.add_circle(center_point, normal, radius, numsegs)
  end

  def draw_arc(center_point: nil,
               zero_vector: nil,
               normal: nil,
               radius: nil,
               start_angle: nil,
               end_angle: nil,
               num_segments: nil,
               group: nil)
    normal ||= Geom::Vector3d.new 0, 0, 1
    zero_vector ||= Geom::Vector3d.new 0, 1, 0
    puts radius, center_point, zero_vector, normal, start_angle, end_angle, num_segments, group
    group ? group.entities.add_arc(center_point, zero_vector, normal, radius, start_angle, end_angle, num_segments) : Sketchup.active_model.active_entities.add_arc(center_point, zero_vector, normal, radius,
                                                                                                                                                                    start_angle, end_angle, num_segments)

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
    raise ArgumentError if destination_group.nil? || source_group.nil? || is_a_component_instance?(source_group)
    #http://sketchucation.com/forums/viewtopic.php?f=180&t=37940#p439270
    gcopy = destination_group.entities.add_instance(source_group.entities.parent, source_group.transformation)
    gcopy.name = source_group.name
    gcopy
  end

  def nest_component(destination_group: nil, source_component: nil, make_unique: false)
    raise ArgumentError if destination_group.nil? || source_component.nil? || !is_a_component_instance?(source_component)
    #http://sketchucation.com/forums/viewtopic.php?f=180&t=37940#p439270
    begin
      gcopy = destination_group.entities.add_instance(source_component.definition, source_component.transformation)
    rescue ArgumentError => e
      puts "Problemw with #{source_component.definition.name}"
      raise e
    end

    gcopy.name = source_component.name
    if make_unique
      puts "Making unique!"
      gcopy.make_unique
    end
    gcopy
  end

  def is_point_on_vertex_of_face?(face: nil, pt: nil)
    face.classify_point(pt) == Sketchup::Face::PointOnVertex
  end

  def is_an_edge?(item)
    item.is_a?(Sketchup::Edge)
  end

  def is_a_face?(item)
    item.is_a?(Sketchup::Face)
  end

  def is_a_component_definition?(item)
    item.is_a?(Sketchup::ComponentDefinition)
  end

  def is_a_component_instance?(item)
    item.is_a?(Sketchup::ComponentInstance)
  end

  def is_a_group?(item)
    item.is_a?(Sketchup::Group)
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

  def remove_layer(name: name, delete_geometry: false)
    Sketchup.active_model.layers.remove(name, delete_geometry)
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
    list.find_all { |e| is_an_edge?(e) && !e.deleted? }.count
  end

  def face_count(list)
    list.find_all { |e| is_a_face?(e) && !e.deleted? }.count
  end

  def add_material(material_name, filename: nil)
    mats = Sketchup.active_model.materials
    if !mats.collect { |m| m.name }.include?(material_name)

      new_mat = mats.add material_name
      new_mat.texture = filename if filename
      return new_mat
    else
      mats.each { |m| return m if m.name == material_name }
    end

  end

  def find_group_by_name(name, match_ok: true)
    Sketchup.active_model.entities.each do |e|
      if is_a_group?(e) && e.name == name || (is_a_group?(e) && match_ok && e.name.match(name))
        return(e)
      end
    end
    nil
  end

  def find_or_create_group(name: nil)
    g = find_group_by_name(name)
    if !g
      g = add_group
      g.name = name
    end
    g

  end

  def find_or_create_global_group(name: nil)
    g = find_group_by_name(name)
    if !g
      g = add_global_group
      g.name = name
    end
    g

  end

  def transformation_chain(entity)
    chain = []
    chain = find_entity_chain(entity, model.entities, chain)
    chain.each do |c|
      puts c.name
      puts c.bounds.corner[0]
      puts c.bounds.corner[1]
      puts c.bounds.corner[2]
      puts c.bounds.corner[3]
    end
    chain.collect { |c| c.transformation }.inject(:*)
  end

  def find_entity_chain(entity, list, chain)
    if list.include?(entity)
      chain << entity
      return chain
    end
    list.each do |sub_list|
      if sub_list.respond_to?(:entities)
        result_chain = find_entity_chain(entity, sub_list.entities, chain.clone.push(sub_list))
        if result_chain.include?(entity)
          return result_chain
        end
      end
    end
  end

  def convert_to_global_position(entity)
#based on code from Position Explorer
# Copyright 2010 Glenn Babcock
    points = entity.vertices.collect { |v| v.position }
    parent = entity.parent

    while Sk.is_a_component_definition?(parent)
      group_transformation = parent.instances[0].transformation
      points.map! { |p| p.transform! group_transformation }
      parent = parent.instances[0].parent
    end
    points
  end

  def max_bounds(group)
    max_x = max_y = max_z = nil
    bounds = group.bounds
    (0..7).each do |i|
      c = bounds.corner(i)
      max_x = c.x if max_x.nil? || c.x > max_x
      max_y = c.y if max_y.nil? || c.y > max_y
      max_z = c.z if max_z.nil? || c.z > max_z
    end
    [max_x, max_y, max_z]
  end

  def min_bounds(group)
    min_x = min_y = min_z = nil
    bounds = group.bounds
    (0..7).each do |i|
      c = bounds.corner(i)
      min_x = c.x if min_x.nil? || c.x < min_x
      min_y = c.y if min_y.nil? || c.y < min_y
      min_z = c.z if min_z.nil? || c.z < min_z
    end
    [min_x, min_y, min_z]
  end

  def min_max_bounds(group)
    {max: max_bounds(group),
     min: min_bounds(group)}
  end

  #Thanks to http://stackoverflow.com/questions/17936161/sketchup-entities-mirrored-with-flip-along-axis-not-reflected-in-transform-m
  def transformation_axes_dot_products(tr)
    [
        tr.xaxis.dot(X_AXIS),
        tr.yaxis.dot(Y_AXIS),
        tr.zaxis.dot(Z_AXIS)
    ]
  end

  def dot_matrix_flipped?(dot_x, dot_y, dot_z)
    dot_x * dot_y * dot_z < 0
  end

  def flipped_x?(entity)
    transformation = entity.transformation
    dot_x, dot_y, dot_z = transformation_axes_dot_products(transformation)
    puts "Dots- #{dot_x} #{dot_y} #{dot_z}"
    dot_x < 0 && dot_matrix_flipped?(dot_x, dot_y, dot_z)
  end

  def flipped_y?(entity)
    transformation = entity.transformation
    dot_x, dot_y, dot_z = transformation_axes_dot_products(transformation)
    dot_y < 0 && dot_matrix_flipped?(dot_x, dot_y, dot_z)
  end

  def flipped_z?(entity)
    transformation = entity.transformation
    dot_x, dot_y, dot_z = transformation_axes_dot_products(transformation)
    dot_z < 0 && dot_matrix_flipped?(dot_x, dot_y, dot_z)
  end

  def flip_x(entity)

  end

  def set_status_message(msg)
    Sketchup::set_status_text(msg)
  end


  def model_unit_options
    opts = {}
    model.options["UnitsOptions"].keys.each do |key|
      opts[key] = model.options["UnitsOptions"][key]
    end

    opts

    # {
    #    length_precision: model.options["UnitsOptions"]["LengthPrecision"],
    #    length_unit: model.options["UnitsOptions"]["LengthFormat"],
    #    length_snap_enabled: model.options["UnitsOptions"]["LengthUnit"],
    #    length_snap_length: model.options["UnitsOptions"]["LengthSnapEnabled"],
    #    angle_precision: model.options["UnitsOptions"]["LengthSnapLength"],
    #    angle_snap_enabled: model.options["UnitsOptions"]["AnglePrecision"],
    #    snap_angle: model.options["UnitsOptions"]["SnapAngle"],
    #    supress_units_display: model.options["UnitsOptions"]["SuppressUnitsDisplay"],
    #    froce_inch_display: model.options["UnitsOptions"]["ForceInchDisplay"]
    # }
  end

  def set_model_unit_options!(opt)
    if opt.has_key?("LengthFormat")
      opt["LengthFormat"] = case opt["LengthFormat"]
                              when :architectural || 1
                                1
                              when :decimal || 0
                                0
                              when :engineering || 2
                                2
                              when :fractional || 3
                                3
                              else
                                0
                            end
    end
    if opt.has_key?("LengthUnit")
      opt["LengthUnit"] = case opt["LengthUnit"]
                            when :inches || 0
                              0
                            when :feet || 1
                              1
                            when :mm || 2
                              2
                            when :cm || 3
                              3
                            when :m || 4
                              4
                            else
                              0
                          end
    end
    new_opts = model_unit_options.merge(opt)

    new_opts.keys.each do |key|
      model.options["UnitsOptions"][key] = new_opts[key]
      model.active_view.invalidate
      UI.refresh_inspectors
    end

  end

end
