#http://www.ruby-doc.org/stdlib-2.0.0/libdoc/minitest/rdoc/MiniTest/Assertions.html
require "testup/testcase"
# class HelloWorld
#   def say(msg)
#     return "Nope"
#   end
# end
class TC_ToolLine < TestUp::TestCase
  def test_say
    # hello = HelloWorld.new
    result = "Nope  "
    assert_equal("Hello World", result)
  end
  def tool_path
    WikiHouse::ToolPath.new
  end
  def test_long_fillet?
    bit =  Bit.new(name: "1/4 Up-cut (52-910)", diameter: 0.25)
    tool_path = WikiHouse::ToolPath.new(bit: bit, depth: 0.75)
    line = WikiHouse::ToolPath::ToolLine.new(tool_path: tool_path)

    assert

  end
end