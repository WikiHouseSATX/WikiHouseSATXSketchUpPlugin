require "minitest"
require "minitest/unit"
require "minitest/spec"
require 'minitest/autorun'

#This module addes in methods to make it easier to remove references to improve GC
#Because before/after use define_method - they end up creating a closure that can't be GC'd

#class TC_ToolLine < Minitest::Spec
describe "TC_ToolLine" do
  # def test_say
  #   # hello = HelloWorld.new
  #   result = "Nope  "
  #   assert_equal("Hello World", result)
  # end
  before do
    @bob = 2
    # @bit = Bit.new(name: "1/4 Up-cut (52-910)", diameter: 0.25)
  end
  after do
    @bob = 2
    # @bit = Bit.new(name: "1/4 Up-cut (52-910)", diameter: 0.25)
  end
  it do
    # puts "Bob is #{@bob}"
    # raise ScriptError, @bob
    @bob.must_equal 2
  end
  it "can handle specs at the tomp" do
    @bob.must_equal 2
  end
  describe " and then if nested " do
    before do
      @sam = 2
      # @bit = Bit.new(name: "1/4 Up-cut (52-910)", diameter: 0.25)
    end
    it "can handle nested specs" do
      @bob.must_equal @sam
    end
    it "can handle new specs" do
      @bob.must_equal @sam
    end
  end
end