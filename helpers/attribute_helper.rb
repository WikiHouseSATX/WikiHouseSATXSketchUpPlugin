module WikiHouse::AttributeHelper
  def self.tag_dictionary
    "WikiHouse"
  end
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def tag_dictionary
      WikiHouse::AttributeHelper.tag_dictionary
    end
  end

  def mark_cutable!
    set_tag(tag_name: "cutable", value: true)
  end

  def mark_primary_face!(face)
    Sk.set_attribute(face, tag_dictionary, "primary_face", true)
  end
  def mark_inside_edge!(edge)
    set_tag(entity: edge, tag_name: "inside_edge", value: true)
  end

  def set_tag(tag_name: nil, value: nil, entity: nil)
    return nil if entity.nil? && group.nil?

    if entity
      entity.set_attribute tag_dictionary, tag_name, value
    else
      group.set_attribute tag_dictionary, tag_name, value
    end
  end

  def get_tag(tag_name: nil, entity: nil)
    return nil if entity.nil? && group.nil?
    if entity
      entity.get_attribute tag_dictionary, tag_name
    else
      group.get_attribute tag_dictionary, tag_name
    end

  end

  def remove_tag(tag_name: nil, entity: nil)
    return nil if entity.nil? && group.nil?
    if entity
      entity.delete_attribute tag_dictionary, tag_name
    else
      group.delete_attribute tag_dictionary, tag_name
    end

  end

  def tag_dictionary
    WikiHouse::AttributeHelper.tag_dictionary
  end
end