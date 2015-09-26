#http://www.ruby-doc.org/stdlib-2.0.0/libdoc/minitest/rdoc/MiniTest/Assertions.html
require "testup/testcase"
# class HelloWorld
#   def say(msg)
#     return "Nope"
#   end
# end
class TC_HelloWorld < TestUp::TestCase
  def test_say
   # hello = HelloWorld.new
    result = "Nope  "
    assert_equal("Hello World", result)
  end
end