#edges in Sketchup are dynamic. If you modify or erase them - the objects that
#reference them change.  This class allows you to store a location to do operations on (since it appears to be an edge)
# but it won't change
#This can also be used to store a synthetic edge - one that you use for reference, but don't ever draw
class WikiHouse::EdgePosition
	include DrawingHelper
  attr_reader :start, :end
  def initialize(start_position: nil, end_position: nil)
    @start = Position.new(start_position)
    @end =  Position.new(end_position)
  	raise ArgumentError, "You must provide a start and end for this EdgePosition" unless start_position && end_position
  end
  def self.from_edge(edge)
  	EdgePosition.new(start_position: edge.start, end_position: edge.end)
  end
  def to_s
  	EdgePosition.edge_to_s(self)
  end
  class Position
    attr_reader :position
  	def initialize(position)
			if position.respond_to?(:position)
				@position = [position.position.x, position.position.y, position.position.z]
			else
  			@position = position
  		end
		end
  end
end
