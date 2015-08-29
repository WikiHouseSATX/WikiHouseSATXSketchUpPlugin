=begin
(c) TIG 2010
Permission to use, copy, modify, and distribute this software for
any purpose and without fee is hereby granted, provided that the above
copyright notice appear in all copies.
THIS SOFTWARE IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR
IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
___________________________________________________________________________
You need this file
  #FlattenToPlane.rb >>> Plugins Folder
You must also have this file
  #WorkPlane.rb >>> Plugins Folder
___________________________________________________________________________
Usage:
  Make or choose a 'WorkPlane' that is located on the 'plane' onto which
you want to project your 'flattened' Geometry.
Select the 'WorkPlane' and the required Geometry [Edges etc, note that
Faces etc will be ignored], and/or Groups, and/or Component_Instances.
Run this Tool from the menu 'Plugins' > 'Flatten to Plane'
or type 'flattentoplane' in the Ruby Console.
If there is no 'WorkPlane' and/or other objects in the Selection you get an
error message.
Assuming it runs...
All Edges in the Selection that are not 'hidden' or not on 'off layers' are
projected onto that 'plane'.
The new 'flattened' Edges are put into a new Group named 'FLAT_123456.789'
[it has a 'date/time' suffix].
Each new Edge takes the original Edge's layer.
If an Edge is in a Group it is put into a new Group made inside the new
'FLAT_123456.789' Group that is named after the original Group's name +
'_FLAT'.  This nested Group takes the original Group's layer.
If an Edge is in a Component_Instance it is put into a new Group made
inside the new 'FLAT_123456.789' Group that is named after the original
Component Definition's name + '_FLAT'.  This nested Group takes the
original Instance's layer.
On completion the new Group ['FLAT_123456.789'] is left highlighted.
___________________________________________________________________________
Donations:
by PayPal to info @ revitrev.org
___________________________________________________________________________
Version:
1.0 20101022 First release.
1.1 20101022 Nested groups/instances now included.
1.2 20101023 The correct Plane of a 'WorkPlane' is now used even if it has
             been Transformed inside its own Group.
___________________________________________________________________________
=end
###
require 'sketchup.rb'
require 'WorkPlane.rb'
###
class FlattenToPlane
  def activate
    @model=Sketchup.active_model
    @ss=@model.selection
    @workplane=nil
    @ss.each{|e|
      if e.class==Sketchup::Group and e.name=="WorkPlane"
        @workplane=e
        break
      end#if
    }
    if not @workplane or @ss.length==1
      UI.messagebox("There must be a 'WorkPlane' and other Objects in the Selection!")
      Sketchup.send_action("selectSelectionTool:")
      return nil
    end#if
    ###
    @model.start_operation("Flatten to Plane")
    @mid=true
    ###
    norm=[]
    cent=[]
    @workplane.entities.each{|e|
      if e.class==Sketchup::Face
        norm=e.normal
        cent=e.bounds.center
        break
      end#if
    }
    cent.transform!(@workplane.transformation)
    norm.transform!(@workplane.transformation)
    @plane=[cent,norm]
    ###
    ents=@model.active_entities
    @group=ents.add_group()
    tag=Time.now.to_f
    @group.name="FLAT_"+tag.to_s
    @ents=@group.entities
    ###
    tr=nil
    tr=@ss[0].parent.transformation if @ss[0].parent != @model
    ###
    (@ss.to_a-[@workplane]).each{|e|
      if e.class==Sketchup::Edge
          self.project_edge(e,tr,@ents)
      elsif e.class==Sketchup::Group
          self.project_group(e,tr,@ents)
      elsif e.class==Sketchup::ComponentInstance
          self.project_instance(e,tr,@ents)
      end#case
    }
    ###
    @ss.clear
    @ss.add(@group)
    ###
    @model.active_view.invalidate
    ###
    @mid=false
    @model.commit_operation
    Sketchup.send_action("selectSelectionTool:")
  end
  ###
  def project_edge(edge,tr,ents)
    return nil if edge.hidden? or not edge.layer.visible?
    pos=edge.start.position
    poe=edge.end.position
    if tr
      pos.transform!(tr)
      poe.transform!(tr)
    end#if
    ps=pos.project_to_plane(@plane)
    pe=poe.project_to_plane(@plane)
    nedge=nil
    nedge=ents.add_line(ps,pe) if ps!=pe
    nedge.layer=edge.layer if nedge
  end
  ###
  def project_group(group,to,ents)
    return nil if group.hidden? or not group.layer.visible?
    gents=group.entities
    tr=group.transformation
    tr=tr * to if to
    gp=ents.add_group
    gp.name=group.name+"_FLAT"
    gp.layer=group.layer
    nents=gp.entities
    gents.each{|e|
      next if e.hidden? or not e.layer.visible?
      if e.class==Sketchup::Edge
        self.project_edge(e,tr,nents)
      elsif e.class==Sketchup::Group
        self.project_group(e,tr,nents)
      elsif e.class==Sketchup::ComponentInstance
        self.project_instance(e,tr,nents)
      end#if
    }
  end
  ###
  def project_instance(inst,to,ents)
    return nil if inst.hidden? or not inst.layer.visible?
    dents=inst.definition.entities
    tr=inst.transformation
    tr=tr * to if to
    gp=ents.add_group
    gp.name=inst.definition.name+"_FLAT"
    gp.layer=inst.layer
    nents=gp.entities
    dents.each{|e|
      next if e.hidden? or not e.layer.visible?
      if e.class==Sketchup::Edge
        self.project_edge(e,tr,nents)
      elsif e.class==Sketchup::Group
        self.project_group(e,tr,nents)
      elsif e.class==Sketchup::ComponentInstance
        self.project_instance(e,tr,nents)
      end#if
    }
  end
  ###
  def onCancel()
    @group.erase! if @group and @group.valid? and @mid
    Sketchup.send_action("selectSelectionTool:")
    return nil
  end
  ###
  def deactivate(view=nil)
    @group.erase! if @group and @group.valid? and @mid
    return nil
  end
end#class
############
### shortcut
def flattentoplane()
  Sketchup.active_model.select_tool(FlattenToPlane.new)
  return nil
end#def
########
### menu
if not file_loaded?(File.basename(__FILE__))
  menu=UI.menu("Plugins").add_item("Flatten to Plane"){flattentoplane()}
end
file_loaded(File.basename(__FILE__))
###########################################################################
