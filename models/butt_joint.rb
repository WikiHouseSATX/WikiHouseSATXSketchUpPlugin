class WikiHouse::ButtJoint < WikiHouse::Joint
  def join!(face, start, finish, orientation)
    draw_line(start, finish, group: face.parent)
  end
end
