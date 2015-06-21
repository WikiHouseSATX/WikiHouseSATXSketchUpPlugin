class WikiHouse::WallColumnRib < WikiHouse::ColumnRib

  attr_accessor :wall_panels_on

  def initialize(parent_part: nil, sheet: nil, group: nil, origin: nil, label: label, wall_panels_on: [])
    super(parent_part: parent_part, sheet: sheet, origin: origin, label: label)
    @wall_panels_on = wall_panels_on
    @face_connector = WikiHouse::UPegLockPocketConnector.new(thickness: thickness, orientations: wall_panels_on) unless wall_panels_on.empty?
  end

end