class WikiHouse::Column
  include WikiHouse::PartHelper


  def initialize(origin: nil, sheet: nil, label: nil, parent_part: nil, wall_panels_on: [])
    part_init(sheet: sheet, origin: origin, label: label, parent_part: parent_part)

    @column_boards = []
    4.times do |index|
      if wall_panels_on.include?(index)
        @column_boards << WikiHouse::WallColumnBoard.new(label: "#{label} Column ##{index + 1}", parent_part: self, origin: [@origin.x, @origin.y, @origin.z], sheet: sheet)

      else
        @column_boards << WikiHouse::ColumnBoard.new(label: "#{label} Column ##{index + 1}", parent_part: self, origin: [@origin.x, @origin.y, @origin.z], sheet: sheet)

      end
    end
    @ribs = []
    @ribs << WikiHouse::ColumnRib.new(parent_part: self, origin: @origin, label: "#{label} Column Bottom")
    section_gap = Sk.round((length - (number_of_internal_supports * thickness))/(number_of_internal_supports.to_f + 1.0))


    number_of_internal_supports.times do |index|

      rib = WikiHouse::ColumnRib.new(label: "#{label} Column Mid ##{index + 1}", parent_part: self, origin: [@origin.x, @origin.y, @origin.z + ((index + 1) * section_gap) + (index * thickness)])
      @ribs << rib
    end
    rib = WikiHouse::ColumnRib.new(label: "#{label} Column Top",
                                   parent_part: self,
                                   origin: [@origin.x, @origin.y, @origin.z + length - thickness])
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

      alteration = board.move_to!(point: origin).
          rotate(vector: [1, 0, 0], rotation: 90.degrees).
          rotate(vector: [0, 0, 1], rotation: 0.degrees)
      if index == 0
        alteration.move_by(x: origin.x, y: origin.y, z: origin.z)
      elsif index == 1
        alteration.rotate(vector: [0, 1, 0], rotation: -90.degrees).
            move_by(x: origin.x, y: origin.y, z: -1 * width + origin.z)
      elsif index == 2
        alteration.rotate(vector: [0, 1, 0], rotation: -180.degrees).
            move_by(x: -1 * width + origin.x, y: origin.y, z: -1 * width + origin.z)
      elsif index == 3
        alteration.rotate(vector: [0, 1, 0], rotation: -270.degrees).
            move_by(x: -1 * width + origin.x, y: origin.y, z: origin.z)
      end
      alteration.go!
    end
     @ribs.each { |rib| rib.draw! }

     groups = @ribs.collect { |r| r.group }.concat(@column_boards.collect { |b| b.group }).compact


    set_group(groups)

  end
end