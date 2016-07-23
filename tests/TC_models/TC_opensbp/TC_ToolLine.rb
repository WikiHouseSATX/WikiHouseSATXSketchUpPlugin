
#http://www.ruby-doc.org/stdlib-2.0.0/libdoc/minitest/rdoc/MiniTest/Assertions.html
require "testup/testcase"
describe "TC_ToolLine" do
  before do
    # @bit = Bit.new(name: "1/4 Up-cut (52-910)", diameter: 0.25)
  end
  it "can handle specs at the tomp" do
    1.must.equal 2
  end
  describe " and then if nested " do
    it "can handle nested specs" do
      1.must.equal 2
    end
    it "can handle new specs" do
      1.must.equal 2
    end
  end
end


# #http://www.ruby-doc.org/stdlib-2.0.0/libdoc/minitest/rdoc/MiniTest/Assertions.html
# require "testup/testcase"
# describe "TC_ToolLine" do
#   before do
#     @bit = Bit.new(name: "1/4 Up-cut (52-910)", diameter: 0.25)
#   end
#   it "can handle specs at the tomp" do
#     1.must.equal 2
#   end
#   describe "long_profile?" do
#     it "is false by default" do
#       @line = WikiHouse::ToolPath::ToolLine.new
#       @line.long_fillet?.must_equal false
#     end
#     it "is true if it is a profile and the length is the same as the diameter of the bit" do
#       @line = WikiHouse::ToolPath::ToolLine.new(profile_type: :fillet, start_point: [0, 0, 0], end_point: [0, @bit.diameter, 0])
#
#       @line.long_fillet?.must_equal true
#
#     end
#     it "is false if it is not a fille" do
#       @line = WikiHouse::ToolPath::ToolLine.new(profile_type: :outside)
#       @line.long_fillet?.must_equal false
#       @line = WikiHouse::ToolPath::ToolLine.new(profile_type: :inside)
#       @line.long_fillet?.must_equal false
#       @line = WikiHouse::ToolPath::ToolLine.new(profile_type: :on)
#       @line.long_fillet?.must_equal false
#     end
#     it "is false if it is a profile and not long" do
#       @line = WikiHouse::ToolPath::ToolLine.new(profile_type: :fillet, start_point: [0, 0, 0], end_point: [0, @bit.radius, 0])
#
#       @line.long_fillet?.must_equal false
#     end
#
#   end
#
# end
