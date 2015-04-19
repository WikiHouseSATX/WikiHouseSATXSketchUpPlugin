class WikiHouse::WallCorner < WikiHouse::Wall


  LEFT_COLUMN_BOARD_PEG_FACES = [3]
  MIDDLE_COLUMN_BOARD_PEG_FACES = [0, 1, 2, 3]
  RIGHT_COLUMN_BOARD_PEG_FACES = [1]
  class ColumnWithPanels
    attr :column,:zpegs, :panels

    def initialize(column_label: nil, wall_panels_on: [], parent_part: nil)
      @column = WikiHouse::Column.new(label: column_label, origin: parent_part.origin,
                                      sheet: parent_part.sheet,
                                      wall_panels_on: wall_panels_on,
                                      parent_part: parent_part)

       build_zpegs(faces: faces, peg_label: column_label)
      @panels = {}
    end
    def set_panel(face:nil, panel: nil)
      @panels[face] = panel
    end
    private
    def build_zpegs(faces: nil, peg_label: nil)
      @zpegs = {}
      faces.each { |f| zpegs[f] = [] }
      wall_panel_zpegs.times do |index|
        faces.each do |f|
          p_label = "#{peg_label} #{f+1}-#{index + 1}"
          #puts "#{p_label}"
          @zpegs[f] << WikiHouse::DoubleZPeg.new(label: p_label,
                                                origin: column.origin, sheet: column.sheet)
        end
      end
      @zpegs
    end
  end

  def initialize(origin: nil, sheet: nil, label: nil)
    origin = [27, 100, 0]
    part_init(sheet: sheet, origin: origin)
    @columns_with_panels = []


    # @left_column = WikiHouse::Column.new(label: "Left", origin: @origin,
    #                                      sheet: @sheet,
    #                                      wall_panels_on: LEFT_COLUMN_BOARD_PEG_FACES, parent_part: self)
    # @left_wall_panel = WikiHouse::WallPanel.new(label: "Left Wall Panel",
    #                                             origin: [@origin.x + @left_column.width, @origin.y, @origin.z],
    #                                             sheet: @sheet, parent_part: self)
    # @middle_column = WikiHouse::Column.new(label: "Middle",
    #                                        origin: [@origin.x + @left_column.width + @left_wall_panel.width, @origin.y, @origin.z],
    #                                        sheet: @sheet,
    #                                        wall_panels_on: MIDDLE_COLUMN_BOARD_PEG_FACES, parent_part: self)
    # @right_wall_panel = WikiHouse::WallPanel.new(label: "Right Wall Panel",
    #                                              origin: [@origin.x + @left_column.width + @left_wall_panel.width + @middle_column.width, @origin.y, @origin.z],
    #                                              sheet: @sheet, parent_part: self)
    #
    # @right_column = WikiHouse::Column.new(label: "Right",
    #                                       origin: [@origin.x + @left_column.width + @left_wall_panel.width + @middle_column.width + @right_wall_panel.width,
    #                                                @origin.y, @origin.z],
    #                                       wall_panels_on: RIGHT_COLUMN_BOARD_PEG_FACES, sheet: @sheet, parent_part: self)
    # @left_column_zpegs = build_zpegs(faces: LEFT_COLUMN_BOARD_PEG_FACES, peg_label: "Left Column",
    #                                  column: @left_column)
    # @right_column_zpegs = build_zpegs(faces: RIGHT_COLUMN_BOARD_PEG_FACES, peg_label: "Right Column", column: @right_column)
    # @middle_column_zpegs = build_zpegs(faces: MIDDLE_COLUMN_BOARD_PEG_FACES, peg_label: "Middle Column",
    #                                    column: @middle_column)

  end

  def add_column(wall_panels_on: [], column_label: nil)

    @columns_with_panels << ColumnWithPanels.new(column_label: column_label,
                                               wall_panels_on: wall_panels_on,
                                               parent_part: self)
  end
  def add_wall_panel(column_1_index, column_1_face, column_2_index, column_2_face)
    panel =

        @columns_with_panels[column_1_index].set_panel(face: column_1_face, panel: panel)
        @columns_with_panels[column_2_index].set_panel(face: column_2_face, panel: panel)
  end

  def draw!
    # Sk.find_or_create_layer(name: self.class.name)
    # Sk.make_layer_active_name(name: self.class.name)
    # @left_column.draw!
    # @left_wall_panel.draw!
    # @middle_column.draw!
    # @right_wall_panel.draw!
    # @right_column.draw!
    #
    # draw_zpegs!(column: @left_column, zpegs: @left_column_zpegs)
    # draw_zpegs!(column: @right_column, zpegs: @right_column_zpegs)
    #
    # draw_zpegs!(column: @middle_column, zpegs: @middle_column_zpegs)
    #
    #
    # groups = [@left_column.group, @left_wall_panel.group, @middle_column.group, @right_wall_panel.group, @right_column.group]
    #
    # @left_column_zpegs.keys.each do |k|
    #   groups.concat(@left_column_zpegs[k].collect { |v| v.group })
    # end
    # @right_column_zpegs.keys.each do |k|
    #   groups.concat(@right_column_zpegs[k].collect { |v| v.group })
    # end
    # @middle_column_zpegs.keys.each do |k|
    #   groups.concat(@middle_column_zpegs[k].collect { |v| v.group })
    # end
    #
    # groups = groups.compact
    # set_group(groups)
  end
end