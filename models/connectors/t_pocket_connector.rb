#This is a t shape pocket
#The dimentions of the top of the t anre the length_t and width_in_t
#The dimesions of the stem of the T are the stem_length_in_t and stem_width_in_t


class WikiHouse::TPocketConnector < WikiHouse::PocketConnector

  attr_reader :stem_width_in_t, :stem_length_in_t

  def initialize(length_in_t: nil, count: 1, width_in_t: nil, thickness: nil, rows: 1, stem_width_in_t: nil, stem_length_in_t: nil)
    super(length_in_t: length_in_t, count: count, width_in_t: width_in_t, thickness: thickness, rows: rows)
    @stem_length_in_t = stem_length_in_t ? stem_length_in_t : 8
    @stem_width_in_t = stem_width_in_t ? stem_width_in_t : 2
  end

  def stem_width
    thickness * stem_width_in_t
  end

  def stem_length
    thickness * stem_length_in_t
  end

  def bounding_length
    length > stem_length ? length : stem_length
  end

  def bounding_width
    width > stem_width ? width : stem_width
  end

  def draw_pocket!(location: nil)
    #assumes location is upper left corner
    c1 = location
    c2 = [c1.x + width, c1.y, c1.z]
    c3 = [c2.x, c1.y - length, c1.z]
    c8 = [c1.x, c3.y, c1.z]


    half_width_top = width/2.0
    half_width_stem = stem_width/2.0

    stem_x = c1.x + half_width_top - half_width_stem
    c4 = [stem_x + stem_width, c3.y, c1.z]
    c5 = [c4.x, c4.y - stem_length, c1.z]
    c7 = [stem_x, c3.y , c1.z]
    c6 = [c7.x, c7.y - stem_length, c1.z]

    points = [c1,c2,c3,c4,c5,c6,c7,c8]
    WikiHouse::DogBoneFillet.t_pocket_by_points(points)

    pocket_lines = Sk.draw_all_points(points)
    pocket_lines.each { |e| mark_inside_edge!(e) }
    pocket_face = Sk.add_face(pocket_lines)
    pocket_face.erase!
    pocket_lines
  end

  def pocket?
    true
  end

  def name
    :t_pocket
  end
end