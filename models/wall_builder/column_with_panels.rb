require 'forwardable'
class WikiHouse::ColumnWithPanels
  attr_accessor :column, :zpegs, :panels, :groups
  extend Forwardable
  def_delegators :@column, :parent_part, :sheet, :origin,
                 :thickness, :drawn?, :width, :length, :bounds, :label, :mark_wall_panel_on!

  def_delegators :parent_part, :face_label

  def initialize(column_label: nil, parent_part: nil)
    @column = WikiHouse::Column.new(label: column_label, origin: parent_part.origin,
                                    sheet: parent_part.sheet,
                                    wall_panels_on: [],
                                    parent_part: parent_part)

    @drawing = false
    @parent_part = parent_part
    @panels = {}
    @zpegs = {}
    @groups = []
  end

  def origin=(new_origin)
    @column.origin = new_origin

    zpegs.each do |key, value|
      next if value == []

      value.each do  |zp|
        zp.origin = new_origin

      end
    end
  end

  def set_panel(face: nil, panel: nil)
    raise ArgumentError, "Sorry #{face} is already in use" unless @panels[face].nil?
    @panels[face] = panel
    @column.mark_wall_panel_on!(face)
    build_zpegs(face: face, peg_label: @column.label)

  end

  def add_panel(face: nil, panel: nil)
    if panel.nil?
      panel = ColumnWallPanel.new(label: "Panel on #{face_label(face)}",
                                  origin: origin,
                                  sheet: sheet,
                                  parent_part: parent_part)
    end
    set_panel(face: face, panel: panel)
    panel.left_column = self
    panel.left_column_face = face
    panel
  end

  def draw!
    return if @drawing
    @drawing = true
    @groups = []
    unless @column.drawn?

      @column.draw!
      @groups.concat([@column.group])
      draw_zpegs!
      zpegs.keys.each do |k|
        @groups.concat(zpegs[k].collect { |v| v.group })
      end
    end
    @panels.each do |key, panel|
      unless panel.drawn?

        panel.draw!
      end

      @groups.concat(panel.groups)
    end
    @groups
  end

  def build_zpegs(face: nil, peg_label: nil)
    @zpegs ||= {}
    [0, 1, 2, 3, 4].each { |f| @zpegs[f] ||= [] }
    parent_part.wall_panel_zpegs.times do |index|

      p_label = "#{peg_label} #{face_label(face)}-#{index + 1}"

      @zpegs[face] << WikiHouse::DoubleZPeg.new(label: p_label,
                                                origin: column.origin,
                                                sheet: column.sheet)

    end
    @zpegs
  end

  private
  def draw_zpegs!
    zpegs.each do |key, value|
      next if value == []

      column_board = column.column_board(key)
      connector = column_board.face_connector
      connector.class.drawing_points(bounding_origin: column.origin,
                                     count: parent_part.wall_panel_zpegs,
                                     rows: 1,
                                     part_length: column_board.length,
                                     part_width: column_board.width,
                                     item_length: connector.top_slot_length,
                                     item_width: connector.top_slot_width) do |row, col, location|

        if key == WikiHouse::Orientation.south
          zpeg = zpegs[WikiHouse::Orientation.south][col]
          zpeg.draw!


          zpeg.rotate(vector: [1, 0, 0], rotation: 90.degrees).
              rotate(vector: [0, 1, 0], rotation: 90.degrees).
              move_to(point: zpeg.origin).
              move_by(z: -1 * zpeg.thickness + column_board.width/2.0,
                      x: column_board.width - zpeg.length + 7 * zpeg.thickness,
                      y: -1 * location.y + origin.y - zpeg.thickness * 9).
              go!

        elsif key == WikiHouse::Orientation.east
          zpeg = zpegs[WikiHouse::Orientation.east][parent_part.wall_panel_zpegs - col - 1]
          zpeg.draw!


          zpeg.rotate(vector: [1, 0, 0], rotation: 90.degrees).
              #  rotate(vector: [0, 0, 1], rotation: 180.degrees).
              rotate(vector: [0, 1, 0], rotation: 180.degrees).
              move_to(point: zpeg.origin).
              move_by(z: -1 * zpeg.thickness + column_board.width/2.0,
                      x: zpeg.thickness * -5, #Left right
                      y: -1 * location.y + column_board.origin.y - zpeg.thickness * 9).
              go!
        elsif key == WikiHouse::Orientation.north
          zpeg = zpegs[WikiHouse::Orientation.north][parent_part.wall_panel_zpegs - col - 1]
          zpeg.draw!


          zpeg.rotate(vector: [1, 0, 0], rotation: 90.degrees).
              rotate(vector: [0, 1, 0], rotation: -90.degrees).
              move_to(point: zpeg.origin).
              move_by(z: -1 * zpeg.thickness - column_board.width/2.0,
                      x: zpeg.thickness * -5, #In/Out
                      y: -1 * location.y + column_board.origin.y - zpeg.thickness * 9).
              go!

        elsif key == WikiHouse::Orientation.west

          zpeg = zpegs[WikiHouse::Orientation.west][parent_part.wall_panel_zpegs - col - 1]
          zpeg.draw!

          zpeg.rotate(vector: [1, 0, 0], rotation: 90.degrees).
              rotate(vector: [0, 0, 1], rotation: 0.degrees).
              move_to(point: column.origin).
              move_by(z: -1 * zpeg.thickness - column_board.width/2.0,
                      x:   column_board.width - zpeg.length + 7 * zpeg.thickness , #Left right
                      y:  -1 * location.y + origin.y - zpeg.thickness * 9).

              go!
        else
          raise ScriptError, "Unsupported face"
        end

      end

    end
  end


end