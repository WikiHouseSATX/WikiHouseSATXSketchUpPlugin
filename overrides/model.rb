Sketchup::Model.class_eval do
  #This looks for edges that have a start/end vertex at the point

  def edges_at(vertex, on_allowed: false)
    list = []
    entities.each do |entity|
      next if entity.typename != "Edge"

      list << entity if (on_allowed && entity.on?(vertex)) || entity.used_by?(vertex)
    end
    list
  end

  def path_from(start_vertex, end_vertex, forbidden_edges: [])

    starting_edges = edges_at(start_vertex, on_allowed: true)
    puts "I could start with #{starting_edges.count}"
    starting_edges.reject! { |e| forbidden_edges.include?(e) }
    puts "I have #{starting_edges.count} left"
    path_list = []
    starting_edges.each do |starting_edge|

      puts "Start #{starting_edge.entityID}"
      path_list = traverse([starting_edge],starting_edge.connected_at_other_vertex(start_vertex), starting_edge.other_point(start_vertex),
                           end_vertex, forbidden_edges: forbidden_edges.concat([starting_edge]))
      if path_list.length > 0
        break
      end
    end
    puts path_list
    return path_list
  end

  def traverse(path_list, list_edges, start_vertex, end_vertex, forbidden_edges: [])
    path_edges = list_edges.reject { |e| forbidden_edges.include?(e) }

    new_path = nil
    path_edges.each do |path_edge|
      puts "Path #{path_edge.entityID}"
      if path_edge.on?(end_vertex)
        puts "End Found"

        return path_list.concat([path_edge])
      end
      new_path  = traverse(path_list.concat([path_edge]),path_edge.connected_at_other_vertex(start_vertex), path_edge.other_point(start_vertex), end_vertex,
               forbidden_edges: forbidden_edges.concat([path_edge]))

    end
    return new_path
  end

end