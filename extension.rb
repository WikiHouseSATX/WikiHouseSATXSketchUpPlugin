#Copyright 2015 WikiHouseSATX, Dirk Elmendorf
#This file needs to be put in the root of the Plugins Directory to handle loading
PLUGIN_DIR = "WikiHouseSATXSketchUpPlugin"


require 'sketchup.rb'
require 'extensions.rb'
SKETCHUP_CONSOLE.show

wikihouse_extension = SketchupExtension.new('WikiHouseSATX SketchUp Plugin',
    "#{PLUGIN_DIR}/wiki_house.rb")
wikihouse_extension.version = '1.0'
wikihouse_extension.creator = 'WikiHouseSATX Chapter - Dirk Elmendorf'
wikihouse_extension.copyright = "2015"
wikihouse_extension.description = "This pluging makes it easier to design and build WikiHouses in SketchUp"

Sketchup.register_extension(wikihouse_extension, true)
#UI.messagebox('Loader')
