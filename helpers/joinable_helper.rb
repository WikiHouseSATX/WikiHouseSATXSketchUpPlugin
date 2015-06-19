module WikiHouse::JoinableHelper

  def self.included(base) # built-in Ruby hook for modules
    base.class_eval do
      original_method = instance_method(:initialize)
      define_method(:initialize) do |*args, &block|
        original_method.bind(self).call(*args, &block)
        @joins = {}
      end
    end
  end

  attr_accessor :joins

  def join_on?(face_index)
    return false unless joinable_faces.include?(face_index)
    return false if joins.keys.include?(face_index)
    true
  end

  def joinable_faces
    []
  end

  def join_with(part: nil, on_my_face: nil, to: nil, join: nil)
    if !join

      join = WikiHouse::Join.new(part_1: self,
                                 part_1_face: on_my_face,
                                 part_2: part,
                                 part_2_face: to)
    end
    @joins[join.face_for(self)] = join
    join

  end
end