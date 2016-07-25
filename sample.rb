require "minitest"
require "minitest/unit"
require "minitest/spec"
require "weakref"
module TestCaseSpecHelper
  def remove_child!(child)
    @children.delete_if { |i| i == child }
  end

  def wipe_children!
    @children = []
  end

  def before _type = nil, &block
    puts "Warning before blocks cause memory leaks in this environment"
    define_method :setup do
      super()
      self.instance_eval(&block)
    end

  end

  def after _type = nil, &block
    puts "Warning after blocks cause memory leaks environment"
    define_method :teardown do
      super()
      self.instance_eval(&block)
    end

  end
end


Minitest::Spec.extend(TestCaseSpecHelper)
def filter_classes(new_classes, existing_classes)
  classes = []
  classes = (new_classes - existing_classes).collect { |klass| WeakRef.new(klass) }
  classes.delete_if { |klass| !klass.ancestors.include?(Minitest::Test) }
  classes.delete_if { |klass| klass.to_s.match(/Minitest/) }
  classes

end

def root_testcase(testcase)
  testcase.to_s.split("::").first
end
def remove_specs(spec_list)

  spec_list.each { |klass| remove_spec(klass) }

  GC.start
end
def remove_spec(testcase)

  root = root_testcase(testcase)

  puts "Using #{root} as root"

  Minitest::Runnable.runnables.each { |klass|
    if klass.to_s == root.to_s || klass.to_s.match(/^#{root.to_s}::/)
      puts "Looking at #{klass}"
      klass.nuke_test_methods!
      klass.wipe_children!

      puts "Class #{klass.to_s} #{klass.respond_to?(:before)}"
      Minitest::Spec.remove_child!(klass)

      puts "#{klass.name} Children?:", klass.children
    end
  }

  Minitest::Runnable.runnables.delete_if { |klass|
    klass.to_s == root.to_s || klass.to_s.match(/^#{root.to_s}::/)

  }

  GC.start
end

def look_for_test()
  puts "Count:  #{ObjectSpace.count_objects[:T_CLASS]}"
  puts "Runnables: #{Minitest::Runnable.runnables.join(",")}"
  puts "Spec Children: #{Minitest::Spec.children.join(",")}"
  puts "-------------------\n"
  puts "Object Space"
  puts "-------------------"
  ObjectSpace.each_object(Class) do |k|
    if k.to_s.match("TC_T")
      puts k.to_s
    end
  end
  puts "Objects"
  puts "-------------------"
  Object.constants.each do |c|

    if c.to_s.match("TC_T")
      puts c.to_s
    end
  end

  puts "#######################"
end

puts "\n\nBefore Creation:"
look_for_test
start_classes = []
ObjectSpace.each_object(Class) { |c| start_classes << WeakRef.new(c) }
file = File.expand_path(File.dirname(__FILE__)) + "/TC_ToolLine.rb"
load file
puts "\n\nAfter Creation:"
look_for_test
loaded_classes = []
ObjectSpace.each_object(Class) { |c| loaded_classes << WeakRef.new(c) }
puts "*****************************************"


puts "New Classes: #{filter_classes(loaded_classes, start_classes)}"
puts "*****************************************"
# filter_classes(loaded_classes, start_classes).each do |klass|
#   klass.public_instance_methods(true).grep(/^test_/i).each do |test_method|
#
#     test = klass.new test_method
#
#
#     test.run
#     puts "#{test_method} #{test.passed?} #{test.failures.collect{|f| f.message}}"
#
#   end
# end
#remove_specs(filter_classes(loaded_classes, start_classes))
remove_spec(root_testcase(filter_classes(loaded_classes, start_classes).first))

unloaded_classes = []
ObjectSpace.each_object(Class) { |c| unloaded_classes << WeakRef.new(c) }
puts "*****************************************"
puts "Unloaded Classes: #{filter_classes(unloaded_classes, start_classes)}"
puts "*****************************************"

puts "\n\nAfter unload:"
look_for_test