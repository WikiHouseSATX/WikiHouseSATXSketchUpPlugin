#This class handles tracking the two parts that are joined and
# which faces they are joined on,
# and the pegs used to connect them
class WikiHouse::Join
  def initialize(part_1: nil, part_1_face: nil,
                 part_2: nil, part_2_face: nil)
    @part_1 = part_1
    @part_2 = part_2
    @part_1_face = part_1_face
    @part_2_face = part_2_face
    unless @part_1.join_on?(part_1_face)
      raise ArgumentError, "You can't join on that face for #{part_1}"
    end
    unless @part_2.join_on?(part_2_face)
      raise ArgumentError, "You can't join on that face for #{part_2}"
    end
  end
end
