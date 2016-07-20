class WikiHouse::ParametricUniqueVerticalSlats
  include WikiHouse::AttributeHelper
  include WikiHouse::PartHelper


  class Board
    include WikiHouse::AttributeHelper
    include WikiHouse::PartHelper
    include WikiHouse::BoardPartHelper

    def initialize(parent_part: nil, sheet: nil, group: nil, origin: nil,
                   label: label, width_method_sym: nil)
      part_init(origin: origin, sheet: sheet, label: label, parent_part: parent_part)
      @length_method = :length
      @width_method = width_method_sym
      thickness = sheet.thickness
      init_board(right_connector: WikiHouse::NoneConnector.new(),
                 top_connector: WikiHouse::NoneConnector.new(),
                 bottom_connector: WikiHouse::NoneConnector.new(),
                 left_connector: WikiHouse::NoneConnector.new(),
                 face_connector: WikiHouse::NoneConnector.new())

    end

  end


  def initialize(origin: nil, sheet: nil, label: nil)
    part_init(sheet: sheet, origin: origin, label: label)
    @unit_width = 18
    @slats = []
    @slat_boards = []
    # @left_zpeg = WikiHouse::ZPeg.new(sheet: @sheet, origin: @origin, label: "#{label} Left", parent_part: self)
    # @right_zpeg = WikiHouse::ZPeg.new(sheet: @sheet, origin: [@origin.x, @origin.y, @origin.z + thickness], label: "#{label} right", parent_part: self)
  end

  def origin=(new_origin)
    @origin = new_origin
    #@left_zpeg.origin = new_origin
    #@right_zpeg.origin = [new_origin.x, new_origin.y, new_origin.z + thickness]
  end

  def length
    10 * 12
  end

  def width
    40 * 12
  end

  def depth
    thickness * 2
  end

  def total_slat_width
    @slats.inject(0) { |sum, x| sum + x }
  end

  def valid?(val)
    if val == 0
      return false
    end
    if val == 1
      return true
    end
    return false
  end

  def pattern_count(val, count = 2)
    pattern_num = 0
    @slats.each_with_index do |slat, index|

      if count == 2 && index > 0 && slat == val && slat == @slats[index - 1]
        pattern_num += 1
      end

      if count == 3 && index > 1 && slat == val && slat == @slats[index - 1] && slat == @slats[index - 2]
        pattern_num += 1
      end
    end
    pattern_num
  end

  def little_slat_width
    @unit_width
  end

  def middle_slat_width
    @unit_width * 2
  end

  def large_slat_width
    @unit_width * 4
  end

  def build_units
    little_slat = @unit_width
    middle_slat = @unit_width * 2
    large_slat = @unit_width * 4

    while total_slat_width <= width
      val = 1 + rand(3)
      last_slat_size = @slats.last ? @slats.last/@unit_width : 0

      if val == 3
        if last_slat_size == 4
          val = 1 + rand(2)
        end
      elsif val == 2 && last_slat_size == 2
        ctr = pattern_count(middle_slat, 2)
        if ctr > 3
          val = (1 + rand(2)) == 1 ? 1 : 3

        end
      elsif val == 1 && last_slat_size == 1
        ctr_2 = pattern_count(little_slat, 2)
        ctr_3 = pattern_count(little_slat, 3)

        if ctr_2 > 5
          val = (1 + rand(2)) == 1 ? 2 : 3
        end

      end

      if val == 1
        @slats << little_slat
      elsif val == 2
        @slats << middle_slat
      elsif val == 3
        @slats << large_slat

      end
      #  @slats << little_slat
    end
    puts @slats.join(",")

  end

  def build_slats
    @slats.each do |slat|
      if slat == little_slat_width
        @slat_boards << Board.new(parent_part: self,
                                  sheet: sheet,
                                  origin: origin,
                                  label: "Slat", width_method_sym: :little_slat_width)


      elsif slat == middle_slat_width

        @slat_boards << Board.new(parent_part: self,
                                  sheet: sheet,
                                  origin: origin,
                                  label: "Slat", width_method_sym: :middle_slat_width)

      elsif slat == large_slat_width
        @slat_boards << Board.new(parent_part: self,
                                  sheet: sheet,
                                  origin: origin,
                                  label: "Slat", width_method_sym: :large_slat_width)

      end
    end
  end

  def draw!

    Sk.find_or_create_layer(name: self.class.name)
    Sk.make_layer_active_name(name: self.class.name)

    build_units
    build_slats

    current_origin = origin
    @slat_boards.each do |slat|
      slat.origin = current_origin
      slat.draw!
      current_origin = [current_origin.x + slat.width + 1, current_origin.y , current_origin.z]
    end
    groups = @slat_boards.collect { |sb| sb.group }.compact
    set_group(groups)

  end


end