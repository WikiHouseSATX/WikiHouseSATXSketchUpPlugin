#This class handles taking a face and creating joints
class WikiHouse::Joiner
  def initialize(joint_class, sheet)
    @joint = joint_class.new(self)
    @sheet = sheet
  end

  def sheet
    @sheet
  end

  def make_joints!(edge_divisor, face)
    max_length = face.edges.collect { |e| e.length }.max
    long_edges = face.edges.collect { |e| e }.delete_if { |e| e.length < max_length }
    start_edge = long_edges.first
    end_edge = long_edges.last


    if (start_edge.end.position.x.to_inch - start_edge.start.position.x.to_inch).abs == max_length.to_inch
      puts "X is long"
      new_length = max_length.to_inch/edge_divisor.to_f.to_inch
      starting_x = start_edge.start.position.x.to_l < start_edge.end.position.x.to_l ? start_edge.start.position.x : start_edge.end.position.x
      (edge_divisor.to_i - 1).times do |index|

        new_start = [((index + 1) * new_length) + starting_x,
                     start_edge.start.position.y.to_inch,
                     0]
        new_end = [((index + 1) * new_length) + starting_x,
                   end_edge.end.position.y.to_inch,
                   0]
        @joint.join!(face, new_start, new_end, :x)

      end
    else
      puts "Y is long"
      starting_y = start_edge.start.position.y.to_l < start_edge.end.position.y.to_l ? start_edge.start.position.y : start_edge.end.position.y

      new_length = max_length.to_inch/edge_divisor.to_f.to_inch
      (edge_divisor.to_i - 1).times do |index|

        new_start = [start_edge.start.position.x.to_inch,
                     ((index + 1) * new_length) + starting_y,
                     0]
        new_end = [end_edge.end.position.x.to_inch,
                   ((index + 1) * new_length) + starting_y,
                   0]

        @joint.join!(face, new_start, new_end, :y)
      end
    end


  end
end
