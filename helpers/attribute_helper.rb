module WikiHouse::AttributeHelper
  DEFAULT_DICTIONARY = "WikiHouse" unless defined? DEFAULT_DICTIONARY

  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods

  end

  def tag_with(tag_name, value, dictionary: nil)
    dictionary = DEFAULT_DICTIONARY unless dictionary
  end


  def tag(tag_name, dictionary: nil)
    dictionary = DEFAULT_DICTIONARY unless dictionary
  end

  def remove_tag(tag_name, dictionary: nil)
    dictionary = DEFAULT_DICTIONARY unless dictionary
  end

end