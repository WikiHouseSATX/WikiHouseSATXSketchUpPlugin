#Copyright 2015 WikiHouseSATX, Dirk Elmendorf
#This file needs to be put in the root of the Plugins Directory to handle loading
PLUGIN_DIR = "WikiHouseSATXSketchUpPlugin"
if Dir.exists?("C:/Ruby200-x64/lib/ruby/gems/2.0.0")
  $LOAD_PATH << "C:/Ruby200-x64/lib/ruby/gems/2.0.0"
end
require 'rubygems'
require 'sketchup.rb'
require 'extensions.rb'
SKETCHUP_CONSOLE.show

#Adds in a the cloned version of the testup library
if Dir.exists?(File.expand_path(File.dirname(__FILE__) + "/../testup-2/src"))
  puts "Loading the testup testing ext"
  begin
    gem 'minitest'
  rescue Gem::LoadError
    Gem.install('minitest')
    gem 'minitest'
  end


  require 'minitest'

  puts "Minitest Version #{Minitest::VERSION}"
  $LOAD_PATH << File.expand_path(File.dirname(__FILE__) + "/../testup-2/src")
  require "testup.rb"
end
wikihouse_extension = SketchupExtension.new('WikiHouseSATX SketchUp Plugin',
                                            "#{PLUGIN_DIR}/wiki_house.rb")
wikihouse_extension.version = '1.0'
wikihouse_extension.creator = 'WikiHouseSATX Chapter - Dirk Elmendorf'
wikihouse_extension.copyright = "2015"
wikihouse_extension.description = "This pluging makes it easier to design and build WikiHouses in SketchUp"

Sketchup.register_extension(wikihouse_extension, true)
#UI.messagebox('Loader')
