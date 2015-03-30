class WikiHouse::Column
  include WikiHouse::PartHelper

  def initialize(origin: nil, sheet: nil, label: nil)
    part_init(sheet: sheet, origin: origin, label: label)
    @column_boards = []
    4.times do |index|
      @column_boards << WikiHouse::ColumnBoard.new(label: "#{label} Column ##{index + 1}", column: self, origin: [@origin.x, @origin.y , @origin.z], sheet: sheet)
    end
    @ribs = []
    @ribs << WikiHouse::ColumnRib.new(column: self, origin: @origin, label: "#{label} Column Bottom")
    number_of_internal_supports.times do |index|
      height = support_section_height * (index + 1) - thickness/2.0
      rib = WikiHouse::ColumnRib.new(label: "#{label} Column Mid ##{index + 1}", column: self, origin: [@origin.x, @origin.y, @origin.z + height])
      @ribs << rib
    end
    rib = WikiHouse::ColumnRib.new(label: "#{label} Column Top",
                                   column: self,
                                   origin: [@origin.x, @origin.y, @origin.z + left_side_length - thickness])
    @ribs << rib

  end

  def support_section_height
    left_side_length/(number_of_internal_supports.to_f + 1.0)
  end

  def number_of_internal_supports
    2
  end


  def bottom_side_length
    10
  end

  def left_side_length
    80
  end

  def tab_width
    5
  end


  def draw!

    @column_boards.each_with_index do |board, index|

      board.draw!
      alteration = board.move_to!(point: origin).
          rotate(vector: [1, 0, 0], rotation: 90.degrees).
          rotate(vector: [0, 0, 1], rotation: 0.degrees)
      if index == 0
        alteration.move_by(x: origin.x , y: origin.y, z: origin.z)
      elsif index == 1
        alteration.rotate(vector: [0, 1, 0], rotation: -90.degrees).
            move_by(x: origin.x, y: origin.y, z: -1 * bottom_side_length + origin.z)
      elsif index == 2
        alteration.rotate(vector: [0, 1, 0], rotation: -180.degrees).
            move_by(x: -1 * bottom_side_length + origin.x, y: origin.y, z: -1 * bottom_side_length + origin.z)
      elsif index == 3
        alteration.rotate(vector: [0, 1, 0], rotation: -270.degrees).
            move_by(x: -1 * bottom_side_length + origin.x, y: origin.y, z: origin.z)
      end
      alteration.go!
    end
    @ribs.each { |rib| rib.draw! }

    groups = @ribs.collect { |r| r.group }.concat(@column_boards.collect { |b| b.group })


    set_group(groups)

  end
end