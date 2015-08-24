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

    def set_tag(tag_name: nil, value: nil, entity: nil)
      return nil if entity.nil?

      if entity
        entity.set_attribute tag_dictionary, tag_name, value
      end
    end

    def get_tag(tag_name: nil, entity: nil)
      return nil if entity.nil?
      if entity
        entity.get_attribute tag_dictionary, tag_name
      end

    end

    def remove_tag(tag_name: nil, entity: nil)
      return nil if entity.nil?
      if entity
        entity.delete_attribute tag_dictionary, tag_name
      end

    end

    def mark_cutable!(entity = nil)
      set_tag(tag_name: "cutable", value: true, entity: entity)
    end

    def mark_flattenable!(entity=nil)
      set_tag(tag_name: "flattenable", value: true, entity: entity)
    end

    def remove_flattenable!(entity=nil)
      remove_tag(tag_name: "flattenable", entity: entity)
    end

    def remove_primary_face!(entity=nil)
      remove_tag(tag_name: "primary_face", entity: entity)
    end

    def mark_primary_face!(face)
      set_tag(entity: face, tag_name: "primary_face", value: true)
    end

    def mark_inside_edge!(edge)
      set_tag(entity: edge, tag_name: "inside_edge", value: true)
    end
  end

  def mark_cutable!
    self.class.mark_cutable!(group)
  end

  def mark_flattenable!
    self.class.mark_flattenable!(group)
  end

  def mark_primary_face!(face)
    self.class.mark_primary_face!(face)
  end

  def mark_inside_edge!(edge)
    self.class.mark_inside_edge!(edge)
  end


  def set_tag(tag_name: nil, value: nil, entity: nil)
    return nil if entity.nil? && group.nil?
    self.class.set_tag(tag_name: tag_name, value: value, entity: entity ? entity : group)
  end

  def get_tag(tag_name: nil, entity: nil)
    return nil if entity.nil? && group.nil?
    self.class.get_tag(tag_name: tag_name, value: value, entity: entity ? entity : group)


  end

  def remove_tag(tag_name: nil, entity: nil)
    return nil if entity.nil? && group.nil?
    self.class.remove_tag(tag_name: tag_name, value: value, entity: entity ? entity : group)
  end

  def tag_dictionary
    self.class.tag_dictionary
  end
end