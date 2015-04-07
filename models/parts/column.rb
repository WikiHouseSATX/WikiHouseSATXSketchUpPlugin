class WikiHouse::Column
  include WikiHouse::PartHelper


  def initialize(origin: nil, sheet: nil, label: nil, parent_part: nil, wall_panels_on: [])
    part_init(sheet: sheet, origin: origin, label: label, parent_part: parent_part)

    @column_boards = []
    4.times do |index|
      if wall_panels_on.include?(index)
        @column_boards << WikiHouse::WallColumnBoard.new(label: "#{label} Column ##{index + 1}", parent_part: self, origin: @origin, sheet: sheet)

      else
        @column_boards << WikiHouse::ColumnBoard.new(label: "#{label} Column ##{index + 1}", parent_part: self, origin: @origin, sheet: sheet)

      end
    end
    @ribs = []
    @ribs << WikiHouse::ColumnRib.new(parent_part: self, origin: [@origin.x, @origin.y + width, @origin.z], label: "#{label} Column Bottom")
    section_gap = Sk.round((length - (number_of_internal_supports * thickness))/(number_of_internal_supports.to_f + 1.0))


    number_of_internal_supports.times do |index|

      rib = WikiHouse::ColumnRib.new(label: "#{label} Column Mid ##{index + 1}", parent_part: self, origin: [@origin.x, @origin.y + width, @origin.z + ((index + 1) * section_gap) + (index * thickness)])
      @ribs << rib
    end
    rib = WikiHouse::ColumnRib.new(label: "#{label} Column Top",
                                   parent_part: self,
                                   origin: [@origin.x, @origin.y + width, @origin.z + length - thickness])
    @ribs << rib

  end

  def wall_panel_zpegs
    parent_part.wall_panel_zpegs
  end

  def number_of_internal_supports
    3
  end


  def width
    10
  end

  def length
    80
  end


  def draw!

    @column_boards.each_with_index do |board, index|

      board.draw!


      if index == 0
        alteration = board.rotate(vector: [1, 0, 0], rotation: 90.degrees).
            rotate(vector: [0, 0, 1], rotation: 0.degrees).
            move_to(point: origin)
        alteration.move_by(x: 0, y: 0, z: width * -1)
      elsif index == 1
        alteration = board.rotate(vector: [1, 0, 0], rotation: 90.degrees).
            rotate(vector: [0, 0, 1], rotation: 0.degrees).
            rotate(vector: [0, 1, 0], rotation: 90.degrees).
            move_to(point: origin).
            move_by(x: 0, y: 0, z: 0)
      elsif index == 2
        alteration = board.rotate(vector: [1, 0, 0], rotation: 90.degrees).
            rotate(vector: [0, 0, 1], rotation: 0.degrees).
            rotate(vector: [0, 1, 0], rotation: 180.degrees).
            move_to(point: origin).
            move_by(x: board.width * -1, y: 0, z: 0)
      elsif index == 3
        alteration = board.rotate(vector: [1, 0, 0], rotation: 90.degrees).
            rotate(vector: [0, 0, 1], rotation: 0.degrees).
            rotate(vector: [0, 1, 0], rotation: 270.degrees).
            move_to(point: origin).
            move_by(x: board.width * -1, y: 0 , z:  -1 * width)
      end
      alteration.go!

    end
    @ribs.each { |rib| rib.draw! }

    groups = @ribs.collect { |r| r.group }.concat(@column_boards.collect { |b| b.group }).compact


    set_group(groups)

  end
end