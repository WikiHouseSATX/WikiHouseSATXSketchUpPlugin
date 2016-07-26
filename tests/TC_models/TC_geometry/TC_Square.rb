#http://www.ruby-doc.org/stdlib-2.0.0/libdoc/minitest/rdoc/MiniTest/Assertions.html
require "testup/testcase"

class TC_Square < TestUp::TestCase
  #handle reload automatci code.
  def test_points
    @square = WikiHouse::Shapes::Square.new([0, 0, 0], 10)
    points = @square.points
    assert_equal points, []
  end
end