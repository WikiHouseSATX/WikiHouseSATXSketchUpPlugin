#http://www.ruby-doc.org/stdlib-2.0.0/libdoc/minitest/rdoc/MiniTest/Assertions.html
require "testup/testcase"

class TC_OutSideProfile < TestUp::TestCase
  def test_say
    # hello = HelloWorld.new
    result = "Hello World"
    assert_equal("Hello World", result)
  end
end