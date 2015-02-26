#Copyright 2015 WikiHouseSATX
#UI.messagebox('Core')

CURRENT_PLATFORM = (Object::RUBY_PLATFORM =~ /mswin/i) ? :windows :
      ((Object::RUBY_PLATFORM =~ /darwin/i) ? :mac : :other) unless defined? CURRENT_PLATFORM
["sheets.rb", "transform.rb"].each do |filename|
  load "#{PLUGIN_DIR}/#{filename}"
end

def reload_wikihouse
  load "#{PLUGIN_DIR}/core.rb"
end
