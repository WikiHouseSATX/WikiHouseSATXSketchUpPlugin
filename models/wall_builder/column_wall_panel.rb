require 'forwardable'
class WikiHouse::ColumnWallPanel

  attr_accessor :left_column, :right_column, :parent_part,
                :groups, :left_column_face, :right_column_face

  extend Forwardable
  def_delegators :@wall_panel, :parent_part, :sheet,
                 :origin, :origin=, :thickness, :drawn?, :bounds, :label
  def_delegators :parent_part, :face_label

  def initialize(label: nil, origin: nil, sheet: nil, parent_part: nil)
    @wall_panel = WikiHouse::WallPanel.new(label: label, origin: origin,
                                           sheet: sheet, parent_part: parent_part)
    @left_column = @right_column = @left_column_face = @right_column_face = nil
    @parent_part = parent_part
    @groups = []
  end

  def origin
    @wall_panel.origin
  end

  def sheet
    @wall_panel.sheet
  end

  def add_right_column(column_label: nil, face: nil, rcolumn: nil)
    unless rcolumn
      rcolumn = ColumnWithPanels.new(column_label: column_label,
                                     parent_part: parent_part)
      rcolumn.origin = origin
    end


    rcolumn.set_panel(face: face, panel: self)
    @right_column = rcolumn
    @right_column_face = face
    @right_column
  end

  def add_left_column(column_label: nil, face: nil, lcolumn: nil)
    unless lcolumn
      lcolumn = ColumnWithPanels.new(column_label: column_label,
                                     parent_part: parent_part)
    end
    lcolumn.origin = origin
    lcolumn.set_panel(face: face, panel: self)
    @left_column = lcolumn
    @left_column_face = face
    @left_column
  end

  def draw!

    #Draw left column
    @groups = []
    if left_column
      left_column.draw! unless left_column.drawn?
      @groups.concat(left_column.groups)
      @wall_panel.origin = left_column.origin
    end

    #draw the panel
    @wall_panel.draw!
    @groups.concat([@wall_panel.group])
    if left_column
      #Rotate the wall panel to line up
      if left_column_face == Orientation.south

        @wall_panel.rotate(vector: [0, 0, 1], rotation: 90.degrees).
            move_to(point: origin).
            move_by(z: -1 * thickness,
                    x: left_column.width,
                    y: left_column.width * -1).
            go!


      elsif left_column_face == Orientation.east
        @wall_panel.rotate(vector: [0, 0, 1], rotation: 180.degrees).
            move_to(point: origin).
            move_by(z: -1 * thickness,
                    x: (@wall_panel.length) * 0,
                    y: left_column.width * -1).
            go!
      elsif left_column_face == Orientation.north


        @wall_panel.rotate(vector: [0, 0, 1], rotation: 270.degrees).
            move_to(point: origin).
            move_by(z: -1 * thickness,
                    x: (@wall_panel.length) * 0,
                    y: left_column.width * 0).
            go!

      elsif left_column_face == Orientation.west
        @wall_panel.
            move_to(point: origin).
            move_by(z: -1 * thickness,
                    x: left_column.width,
                    y: left_column.width * 0).
            go!

      else
        raise ArgumentError, "Face can only be 0,1,2,3 not #{left_column_face}"
      end


    end
    #draw the right column
    wp_bounding_box = @wall_panel.bounds


    if right_column
      unless right_column.drawn?


        if right_column_face == Orientation.south
          left_front_bottom = wp_bounding_box.corner(0)
          @wall_panel.origin = [left_front_bottom.x + right_column.width,
                                left_front_bottom.y,
                                left_front_bottom.z]
          right_column.origin = [Sk.round(@wall_panel.origin.x) - right_column.width,
                                 @wall_panel.origin.y - 0 * @wall_panel.thickness - right_column.width,
                                 @wall_panel.origin.z + 1 * @wall_panel.thickness]


        elsif right_column_face == Orientation.east
          right_front_bottom = wp_bounding_box.corner(1)

          @wall_panel.origin = right_front_bottom
          right_column.origin = [Sk.round(@wall_panel.origin.x),
                                 @wall_panel.origin.y - 0 * @wall_panel.thickness,
                                 @wall_panel.origin.z + 1 * @wall_panel.thickness]
        elsif right_column_face == Orientation.north
          left_back_bottom = wp_bounding_box.corner(2)
          @wall_panel.origin = left_back_bottom

          right_column.origin = [Sk.round(@wall_panel.origin.x),
                                 @wall_panel.origin.y,
                                 @wall_panel.origin.z + 1 * @wall_panel.thickness]

        elsif right_column_face == Orientation.west
          left_front_bottom = wp_bounding_box.corner(0)

          @wall_panel.origin = left_front_bottom
          right_column.origin = [Sk.round(@wall_panel.origin.x) - right_column.width,
                                 @wall_panel.origin.y + 0 * @wall_panel.thickness,
                                 @wall_panel.origin.z + 1 * @wall_panel.thickness]
        else
          raise ArgumentError, "Face can only be 0,1,2,3 not #{right_column_face}"
        end


        right_column.draw!

      end

      @groups.concat(right_column.groups)
    end
    @groups
  end
end
