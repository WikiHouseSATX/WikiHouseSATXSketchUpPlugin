=begin
(c) TIG 2014
Permission to use, copy, modify, and distribute this software for 
any purpose and without fee is hereby granted, provided that the above
copyright notice appear in all copies.
THIS SOFTWARE IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR
IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
___________________________________________________________________________

  WorkPlane.rb >>> Plugins Folder
___________________________________________________________________________
Usage:

'WorkPlane Tools' Toolbar button
[which can be activated from Views > Toolbars]

or 'Menu' > 'Tools' > 'WorkPlane...' > 'New Plane'

or right-click context-menu 'WorkPlane...' submenu 'New Plane'.

or type 'wp' in the Ruby Console.

The VCB gives prompts...

You are prompted to pick the 1st Point on the WorkPlane.
This will determine the 'center' of the WorkPlane.
The default is 'Center-Alignment'.
If you press <Tab> before picking the 1st Point the WorkPlane's alignment 
will become 'Corner'.
Pressing <Tab> toggles between 'Center' and 'Corner' 
alignments.

You are prompted to pick the 2nd Point on the WorkPlane.
This determines the alignment of the top/bottom edges of the WorkPlane.

You are prompted to pick the 3rd Point on the WorkPlane.
This determines the WorkPlane's 'plane' and the alignment of its other 
side-edges.

At any time you can right-click in empty space to change the WorkPlane's 
Settings.  These are remembered within the model across sessions.

The Settings are:
Width [in direction of pt1 >> pt2] = feet/meters, depending on unit-type.
default=50'/10m
Height [in direction of pt1 >> pt3] = feet/meters, depending on unit-type.
default=50'/10m
Grid? = true/false
default=true
OK to confirm, Cancel to skip changing any Settings.

If you have the Grid? option as 'true' then a second dialog opens where you 
can change the WorkPlane's Grid Spacing.
The Grid Settings are:
Width [in direction of pt1 >> pt2] = feet/meters, depending on unit-type
default=5'/1m
Height [in direction of pt1 >> pt3] = feet/meters, depending on unit-type
default=5'/1m
OK to confirm, Cancel to skip changing ALL Settings.

After picking the 3rd Point a 'WorkPlane' group is added to the model's 
active entities.
It is sized according to the current Settings and it is oriented to the 
selected 'plane' of the three picked points.
Its center is located on the 1st Point picked.

The group contains a face with a very transparent material.
[called 'WorkPlaneMaterial' - which is added to the model's materials if it 
doesn't exist].

The face has hidden edges.
Guides [clines] are added to its four edges.
If the 'Grid?' was set a grid of guides [clines] is added across the 
WorkPlane's face.
To make a grid with only one orientation you can enter a grid-spacing that 
is greater than the overall Workplane's size in that direction.

To 'Confirm' the WorkPlane 'double-click' or press <Enter>.
Alternatively press the 'Tab' key to toggle the WorkPlane between 
'planar to the three picked points' and 
'perpendicular to the plane of the three picked points' 
[where the 1st and 2nd points set the axial alignment] 
before you 'Confirm'.

Pressing <Esc> or selecting another Tool at any point will exit without 
keeping the changes.

The WorkPlane does not cast or receive shadows.

The WorkPlane is put onto a layer called 'WORKPLANE'; it is made if it 
doesn't already exist, and it is switched 'on' if it was 'off'.

A Workplane is 'locked'.***
Therefore a WorkPlane cannot be erased or moved or rotated or edited etc.
To 'unlock' it you must Select it and then use 'Entity Info' or the 
right-click context-menu...

The full list of right-click context-menu submenu items "WorkPlane..." is:

Always available options:

"New Plane"
 [also available on the 'WorkPlane' Toolbar and the 
 'Menu' > 'Tools' > 'WorkPlane...' > 'New Plane']
 It makes a new rectangular WorkPlane as explained above.

"New Disk"
 [also available on the 'WorkPlane' Toolbar and the 
 'Menu' > 'Tools' > 'WorkPlane...' > 'New Disk']
 It make a new WorkPlane that is circular - 'disk shaped'.
 Like the rectangular WorkPlane you then pick three points to determine the 
 disk's location and plane.  
 The Disk is centered on the 1st point picked.
 The 2nd point sets its radius.
 The 3rd point sets its plane.
 Right-clicking in empty space runs a dialog that lets you change the Disk's 
 Settings - the defaultsa are 24 Segments(=15degrees) and 4 Rings]
 - these are settings remembered with the model.
 The number of Segments must be >= 3 and the number of Rings >= 1.
 
 "New Protractor"
 [also available on the 'WorkPlane' Toolbar and the 
 'Menu' > 'Tools' > 'WorkPlane...' > 'New Protractor']
 It makes a 'protractor' of three concentric wp-disks arranged at right-angles 
 to each other in 3D.
 The Protractor is centered on the 1st point picked.
 The 2nd point sets its radius/X-axis.
 The 3rd point sets its plane/Y-axis.
 Its Z-axis is claculated from the X/Y-axis.
 
"Lock All"
 [also available on the 'Menu' > 'Tools' > 'WorkPlane...' > 'Lock All']
 It 'locks' ALL WorkPlanes in the Model.

"UnLock All"
 [also available on the 'Menu' > 'Tools' > 'WorkPlane...' > 'UnLock All']
 It 'unlocks' ALL WorkPlanes in the Model.
 
"Delete All"
 [also available on the 'Menu' > 'Tools' > 'WorkPlane...' > 'Delete All']
 It deletes ALL WorkPlanes in the Model - so use with care.***

"Hide/UnHide All"
 [also available on the 'Menu' > 'Tools' > 'WorkPlane...' > 'Hide/UnHide All']
 Toggles the visibility of the layer 'WORKPLANE', to hide/unhide WorkPlanes.
 
These additional items are available if just one WorkPlane is selected:

"Adjust" [only available if WorkPlane is 'rectangular']
 It brings up a 'Settings' dialog similar to the one used for a 
 'New Plane' WorkPlane, you can enter different values for width/height in 
 meters/feet etc: if 'Grids?' is set 'true' then a second dialog opens to 
 let you adjust the grid width/height.  The original WorkPlane is then 
 replaced with a new one using the Settings you have entered - its 
 transformation [location/rotation/scaling] matches the original's.  
 If the original's placement - 'by center' or 'by corner' - is remembered 
 and the adjustment is made accordingly.

"Toggle Center:Corner" [only available if WorkPlane is 'rectangular']
 It toggles between the selected WorkPlane being aligned by 'center' and by 
 'corner'.  Its 'axes' in X/Y/Z are considered relocated to suit should a 
 'Rotate on...' option be used later on.

"Rotate on X"
 It brings up a 'Rotation' dialog, where you can enter an Angle in degrees 
 [positive or negative].
 The WorkPlane will rotate by that Angle about its X-axis
 [as originally picked 1st point to 2nd point] 
 The WorkPlane remains 'locked'.

"Rotate on Y"
 As above, but it rotates about the WorkPlane's Y-axis 
 [from picked 1st point to pt3 - perpendicular to pt1-pt2 on plane].
 
"Rotate on Z"
 As above, but it rotates about the WorkPlane's Z-axis 
 [i.e. the plane's normal at it's alignment point - center/corner].

"Move"
 It lets you Move the selected [locked] WorkPlane from the 1st point you 
 pick to the 2nd point you pick [or a typed dimension in the direction of 
 the cursor].  The WorkPlane remains 'locked'.
 The WorkPlane moves with the cursor until the 2nd point is picked.
 A temporary cline outline is drawn where the original WorkPlane was located. 
 Pressing <Esc> or starting another Tool will undo any move so far.

"Rotate"
 It 'unlocks' the selected WorkPlane and then runs the built-in 'Rotate' tool.
 You must 're-lock' the WorkPlane using the right-click context-menu 'Lock'

"Scale"
 It 'unlocks' the selected WorkPlane and then runs the built-in 'Scale' tool.
 You must 're-lock' the WorkPlane using the right-click context-menu 'Lock'

These additional items are available if one or more WorkPlanes are selected:
 
"Lock Selected"
 It 'locks' the selected WorkPlanes.

"UnLock Selected"
 It 'unlocks' the selected WorkPlanes.

"Delete Selected"
 It deletes the selected WorkPlanes.***

The creation, deletion, adjustment, rotation, move, scale etc of a 
WorkPlane can be 'Undone' in one step [locking/unlocking cannot].

Several WorkPlanes can be added to a Model as desired.

Tips:
Use a Style which has transparency 'on' and guides 'visible': as these are 
forced 'on' anyway.
Use 'Intersect' with model/selected to 'slice' objects at the WorkPlane.
Do not use 'Edit > Delete Guides' [which is 'global'] unless you want them 
all to vanish in your WorkPlane too...
Use in conjunction with 'Clines Normal at Point' [clinesaxes.rb] to add 
'Normals' to the WorkPlane... [if this separate script is loaded there will 
be additional toolbar buttons too]

___________________________________________________________________________
Donations:
by PayPal to info @ revitrev.org
___________________________________________________________________________
Version:
1.0 20100925 First release.
1.1 20100925 Glitch with Plugins item fixed.
1.2 20100925 WorkPlane is now centered on 1st point.
1.3 20100925 WorkPlaneMaterial made 0.5% opaque and pale-yellow as default, 
             but premade 'WorkPlaneMaterial' remains unchanged.
1.4 20100925 Button icons brought in line with point picking etc.
1.5 20100926 Cosmetic tweaks.  Guide/Transparency forced 'on'.
1.6 20100928 The 'Tab' key toggles new WorkPlane between 'planar to the 3 
             picked points' and 'perpendicular to plane of the 3 picked 
             points [pt1/pt2 set alignment], then press Enter or 
             double-click to confirm.  Zero sizes trapped in dialog.
1.7 20100930 'New' and 'Adjust Selected' options added to context-menu.
             Cline rectangle and axes drawn whilst picking the points.
             The WorkPlane Grid is now always centered on pt-1.
1.8 20100930 'Rounding' glitch with some Adjusted WorkPlanes Grids fixed.
1.9 20100930 'Rotate Selected' option added to context-menu.
2.0 20100930 'Rotate Selected X/Y/Z' options now added for the group's 3 axes.
             'Move Selected' added to context-menu.
2.1 20101001 Notes generally revised.  Menu items renamed.  Toolbar updated.
             Main 'Tools' menu items added [allowing use of shortcut-keys].
             'New Disk' option added: makes circular WorkPlane + radial lines.
             'Toggle Center:Corner' option added: realigns rectangular WorkPlane.
             'Rotate' option added: unlocks and rotates WorkPlane. 
             'Scale' option added: unlocks and scales WorkPlane.
             'Lock Selected', 'UnLock Selected', 'Lock All' and 'Unlock All' 
             options added.
             'Delete Selected' and 'Delete All' options added.
             When making a 'New Plane' pressing <Tab> before picking the 
             1st point sets WorkPlane to align by corner rather than center.
2.2 20101003 'New Protractor' option added.
             'Adjust' now applies to plane or disk - with different dialogs.
             'New Disk' now has 'Segment' and 'Ring' options.
2.3 20101004 Glitch with 'Adjust'ing Disk  more than once now fixed,
             'Hide/UnHide All' toggle option in context-menu/tools-menu.
2.4 20140218 Module-ized. Inputs now as 1'6", 1 1/2", 1000mm, 100cm, 10m etc.
2.5 20140310 Minor cosmetic enhancements.
2.6 20140324 Glitch with 'Adjust' settings resolved.
2.7 20140325 Glitch when reusing 'old-style' 'float' dim WorkPlanes resolved.
________________________________________________________________________________
=end
###
require('sketchup.rb')


module TIG

###
begin
	SCFapi.store_event('T87GcvasDHDa432hBgfP', 'WorkPlane', 'Load')
rescue
end

class WorkPlane

def initialize()
    @ip=Sketchup::InputPoint.new
    @ip1=Sketchup::InputPoint.new
	begin
		SCFapi.store_event('T87GcvasDHDa432hBgfP', 'WorkPlane', 'WorkPlane', 'Run')
		SCFapi.send_events('T87GcvasDHDa432hBgfP')
	rescue
	end
end

def reset()
    @model=Sketchup.active_model
    @ents=@model.active_entities
    @pts=[]
    @state=0
    @ip.clear
    @ip1.clear
    @drawn=false
    @group=nil
    @cen=true ### center v. corner
    @tab=true ### planar v. 90deg
    @temp_clines=[]
    @rot=90.degrees
    ### check if remembered
    @wp_width=@model.get_attribute("WorkPlane","wp_width",nil)
    @wp_height=@model.get_attribute("WorkPlane","wp_height",nil)
    @grid_width=@model.get_attribute("WorkPlane","grid_width",nil)
    @grid_height=@model.get_attribute("WorkPlane","grid_height",nil)
	###
	@wp_width=@wp_width.to_l if @wp_width.is_a?(Float)
	@wp_height=@wp_height.to_l if @wp_height.is_a?(Float)
	@grid_width=@grid_width.to_l if @grid_width.is_a?(Float)
	@grid_height=@grid_height.to_l if @grid_height.is_a?(Float)
	###
    @grid=@model.get_attribute("WorkPlane","grid",nil)
    ###
    if @model.options["UnitsOptions"]["LengthUnit"]<=1 ### it's '/"
      @wp_width=50.0.feet unless @wp_width
      @wp_height=50.0.feet unless @wp_height
      @grid_width=5.0.feet unless @grid_width
      @grid_height=5.0.feet unless @grid_height
    else ### it's metric
      @wp_width=10.0.m unless @wp_width
      @wp_height=10.0.m unless @wp_height
      @grid_width=1.0.m unless @grid_width
      @grid_height=1.0.m unless @grid_height
    end#if
    @grid="true" unless @grid
    if @grid=="true"
      @grid_boolean=true
    else
      @grid_boolean=false
    end
    ### force guides/transparncy 'on'
    @model.rendering_options["MaterialTransparency"]=true
    @model.rendering_options["HideConstructionGeometry"]=false
    ###
    Sketchup::set_status_text("", SB_VCB_LABEL)
    Sketchup::set_status_text("", SB_VCB_VALUE)
    @set="Size=#{@wp_width}x#{@wp_height}"
    if @grid_boolean
      @set << ",Grid=#{@grid_width}x#{@grid_height}"
    else
      @set << ",No Grid"
    end#if
    @msg0="WorkPlane: Click 1st Point: Center-Alignment, <Tab>=Corner, Right_Click [in empty space] to change Settings [#{@set}]..."
    @msg0x="WorkPlane: Click 1st Point: Corner-Alignment, <Tab>=Center, Right_Click [in empty space] to change Settings [#{@set}]..."
    @msg1="WorkPlane: Click 2nd Point: Right_Click [in empty space] to change Settings [#{@set}]..."
    @msg2="WorkPlane: Click 3rd Point: Right_Click [in empty space] to change Settings [#{@set}]..."
    @msg3="WorkPlane: <Enter>/Double_Click=Confirm, OR <Tab>=Perpendicular, OR <Esc>=Abort ..."
    @msg4="WorkPlane: <Enter>/Double_Click=Confirm, OR <Tab>=Planar, OR <Esc>=Abort ..."
    @msg=@msg0
    Sketchup::set_status_text(@msg)###
    @shift_down_time=Time.now
end

def activate
    self.reset()
end

def deactivate(view=nil)
    @group.erase! if @group && @group.valid? && @state==4
    self.commit(view)
end

def set_current_point(x, y, view)
    unless @ip.pick(view, x, y, @ip1)
        return false
    end
    need_draw=true
    view.tooltip=@ip.tooltip   
    # Compute points
    case @state
      when 0
        @pts[0]=@ip.position
        @pts[4]=@pts[0]
        need_draw=@ip.display? || @drawn
        @msg=@msg0
        Sketchup::set_status_text(@msg)###
      when 1
        @pts[1]=@ip.position
        @width=@pts[0].distance(@pts[1])
        Sketchup::set_status_text(@width.to_s, SB_VCB_VALUE)
        @msg=@msg1
        Sketchup::set_status_text(@msg)###
      when 2
        ###
        @temp_clines[1..-1].each{|e|e.erase! if e.valid?}if @temp_clines && @temp_clines[1]
        @temp_clines=[@temp_clines[0]]
        ###
        pt1=@ip.position
        pt2=pt1.project_to_line @pts
        vec=pt1 - pt2
        @height=vec.length
        if @height > 0
            # test for a square
            square_point=pt2.offset(vec, @width)
            if( view.pick_helper.test_point(square_point, x, y) )
                @height=@width
                @pts[2]=@pts[1].offset(vec, @height)
                @pts[3]=@pts[0].offset(vec, @height)
                #view.tooltip="= 'Square'"
            else
                @pts[2]=@pts[1].offset(vec)
                @pts[3]=@pts[0].offset(vec)
            end
            if @cen ### add vert center line
              p0=@pts[0].offset(@pts[3].vector_to(@pts[0]),@wp_height/2)
              p3=@pts[0].offset(@pts[0].vector_to(@pts[3]),@wp_height/2)
              cl=@ents.add_cline(p0,p3)
              cl.stipple="-.-"
              @temp_clines << cl              
            #else ### corner no cl needed
              ###
            end#if
            if @cen
              cl=@ents.add_cline(p0.offset(@pts[1].vector_to(@pts[0]),@wp_width/2), p0.offset(@pts[0].vector_to(@pts[1]),@wp_width/2))
              @temp_clines << cl
              cl=@ents.add_cline(p3.offset(@pts[1].vector_to(@pts[0]),@wp_width/2), p3.offset(@pts[0].vector_to(@pts[1]),@wp_width/2))
              @temp_clines << cl
              ###
              p0a=@pts[0].offset(@pts[1].vector_to(@pts[0]),@wp_width/2)
              cl=@ents.add_cline(p0a.offset(@pts[3].vector_to(@pts[0]),@wp_height/2),p0a.offset(@pts[0].vector_to(@pts[3]),@wp_height/2))
              @temp_clines << cl
              p1a=@pts[0].offset(@pts[0].vector_to(@pts[1]),@wp_width/2)
              cl=@ents.add_cline(p1a.offset(@pts[3].vector_to(@pts[0]),@wp_height/2),p1a.offset(@pts[0].vector_to(@pts[3]),@wp_height/2))
              @temp_clines << cl
            else ### corner
              p0=@pts[0].clone
              p1=p0.offset(p0.vector_to(@pts[1]), @wp_width)
              p2=p1.offset(p0.vector_to(@pts[3]), @wp_height)
              p3=p0.offset(p0.vector_to(@pts[3]), @wp_height)
              ###
              cl=@ents.add_cline(p0, p1)
              @temp_clines << cl ### drawn in first step
              cl=@ents.add_cline(p1, p2)
              @temp_clines << cl
              cl=@ents.add_cline(p2, p3)
              @temp_clines << cl
              cl=@ents.add_cline(p3, p0)
              @temp_clines << cl
            end#if
        end#if
        Sketchup::set_status_text(@height.to_s, SB_VCB_VALUE)
        @msg=@msg2
        Sketchup::set_status_text(@msg)###
    end
    view.invalidate if need_draw
end

def onMouseMove(flags, x, y, view)
    self.set_current_point(x, y, view)
end

def make_workplane()
    if @pts[0] != @pts[3]# check for zero height
        ### we make wp flat && move && rotate it into place
        pts=[] ### we now center the wp at @pts[0]
        if @cen
          pts[0]=ORIGIN.offset(X_AXIS,@wp_width/-2)
          pts[0].offset!(Y_AXIS,@wp_height/-2)
          pts[1]=pts[0].offset(X_AXIS,@wp_width)
          pts[2]=pts[1].offset(Y_AXIS,@wp_height)
          pts[3]=pts[0].offset(Y_AXIS,@wp_height)
        else ### corner
          pts[0]=Geom::Point3d.new(0,0,0)
          pts[1]=pts[0].offset(X_AXIS,@wp_width)
          pts[2]=pts[1].offset(Y_AXIS,@wp_height)
          pts[3]=pts[0].offset(Y_AXIS,@wp_height)
        end#if
        @group=@ents.add_group()
        @group.name="WorkPlane"
        wplayer=@model.layers.add("WORKPLANE")
        wplayer.visible=true
        @group.layer=wplayer
        @group.casts_shadows=false
        @group.receives_shadows=false
        ###
        unless mat=@model.materials["WorkPlaneMaterial"]
          mat=@model.materials.add("WorkPlaneMaterial") 
          mat.alpha=0.1
          mat.color=[255,123,0] ### warm yellow
        end#if
        ###
        gents=@group.entities
        ###
        face=gents.add_face(pts)
        face.material=mat
        face.back_material=mat
        ###
        gents.grep(Sketchup::Edge).each{|e|e.hidden=true}
        gents.add_cline(pts[0],pts[1])
        gents.add_cline(pts[1],pts[2])
        gents.add_cline(pts[2],pts[3])
        gents.add_cline(pts[3],pts[0])
        if @grid_boolean ## add clines
          ### horiz
          p0=pts[0].offset(pts[0].vector_to(pts[3]), @wp_height/2)
          p1=pts[1].offset(pts[0].vector_to(pts[3]), @wp_height/2)
          ###
          num=(pts[0].distance(pts[3])/@grid_height/2).ceil
          num.times{|i|
            gents.add_cline(p0,p1)
            p0.offset!(pts[0].vector_to(pts[3]),@grid_height)
            p1.offset!(pts[0].vector_to(pts[3]),@grid_height)
          }
          p0=pts[0].offset(pts[0].vector_to(pts[3]), @wp_height/2)
          p1=pts[1].offset(pts[0].vector_to(pts[3]), @wp_height/2)
          ###
          num.times{|i|
            gents.add_cline(p0,p1)
            p0.offset!(pts[3].vector_to(pts[0]),@grid_height)
            p1.offset!(pts[3].vector_to(pts[0]),@grid_height)
          }
          ### vert
          p0=pts[0].offset(pts[0].vector_to(pts[1]), @wp_width/2)
          p3=pts[3].offset(pts[0].vector_to(pts[1]), @wp_width/2)
          ###
          num=(pts[0].distance(pts[1])/@grid_width/2).ceil
          num.times{|i|
            gents.add_cline(p0,p3)
            p0.offset!(pts[0].vector_to(pts[1]),@grid_width)
            p3.offset!(pts[0].vector_to(pts[1]),@grid_width)
          }
          p0=pts[0].offset(pts[0].vector_to(pts[1]), @wp_width/2)
          p3=pts[3].offset(pts[0].vector_to(pts[1]), @wp_width/2)
          ###
          num.times{|i|
            gents.add_cline(p0,p3)
            p0.offset!(pts[1].vector_to(pts[0]),@grid_width)
            p3.offset!(pts[1].vector_to(pts[0]),@grid_width)
          }
        end
        ### rotate to axes
        xaxis=@pts[0].vector_to(@pts[1])
        yaxis=@pts[0].vector_to(@pts[3])
        zaxis=xaxis.cross(yaxis)
        tr=Geom::Transformation.new(xaxis,yaxis,zaxis,ORIGIN)
        @group.transform!(tr)
        ### group is at ORIGIN - relocate it to 1st picked point
        tr=Geom::Transformation.new(@pts[0])
        @group.transform!(tr)
        ###
        @group.locked=true
        ###
        ### remember
        @group.set_attribute("WorkPlane","cen",@cen)
        ###
        @model.set_attribute("WorkPlane","wp_width",@wp_width)
        @model.set_attribute("WorkPlane","wp_height",@wp_height)
        @model.set_attribute("WorkPlane","grid_width",@grid_width)
        @model.set_attribute("WorkPlane","grid_height",@grid_height)
        @model.set_attribute("WorkPlane","grid",@grid)
        ###
        @msg=@msg3 ### tab
        Sketchup::set_status_text(@msg)###
        ###
    else ### can't make a wp
        UI.beep()
        puts "WorkPlane: Colinear Points can't define a Plane!"
        puts "Retry..."
        self.onCancel()
        return nil
    end
end

def increment_state()
    @state += 1
    case @state
      when 1
        @ip1.copy! @ip
        @msg=@msg1
        Sketchup::set_status_text(@msg)###
        Sketchup::set_status_text "Distance", SB_VCB_LABEL
        @msg=@msg1
        Sketchup::set_status_text(@msg)###
      when 2
        @ip1.clear
        @msg=@msg2
        Sketchup::set_status_text(@msg)###
        Sketchup::set_status_text "Distance", SB_VCB_LABEL
        @msg=@msg2
        Sketchup::set_status_text(@msg)###
      when 3
        self.make_workplane()
        @state=4
    end
end

def onLButtonDown(flags, x, y, view)
    self.set_current_point(x, y, view)
    if @state==2 && ! @pts[3]
      UI.beep
      return nil
    end#if
    self.increment_state()
    if @state==2
      @model.start_operation("New WorkPlane")
      if @cen # draw horiz center line first
        cl=@ents.add_cline(@pts[0].offset(@pts[1].vector_to(@pts[0]),@wp_width/2), @pts[0].offset(@pts[0].vector_to(@pts[1]),@wp_width/2))
        cl.stipple="-.-"
        @temp_clines << cl
      else # corner draw base line first
        cl=@ents.add_cline(@pts[0], @pts[0].offset(@pts[0].vector_to(@pts[1]),@wp_width))
        @temp_clines << cl
      end#if
    end#if
    view.lock_inference
end

def onRButtonDown(flags, x, y, view)
    ### [re]set options dialog
    #units="meters"
    #units="feet" if @model.options["UnitsOptions"]["LengthUnit"]<=1 ### it's '/"
    prompts=["Width: ","Height: ","Grid?: "]
    values=[@wp_width, @wp_height, @grid]
    grids="true|false"
    pops=["","",grids]
    title="WorkPlane Settings"# ["+units+"]"
    results=inputbox(prompts, values, pops, title)
    return nil unless results
    ### trap zero
    if results[0]==0 || results[1]==0
      UI.messagebox("WorkPlane dimension can't be zero!")
      self.onRButtonDown(flags, x, y, view)
      return nil
    end#if
    ###
    @wp_width=results[0]
    @wp_height=results[1]
    @grid=results[2]
    if @grid=="true"
      @grid_boolean=true
    else
      @grid_boolean=false
    end
    if @grid_boolean
      prompts=["Grid Width: ","Grid Height: "]
      values=[@grid_width, @grid_height]
      pops=["",""]
      title="WorkPlane Grid Settings"# ["+units+"]"
      results=inputbox(prompts,values,pops,title)
      return nil unless results
      ### trap zero
      if results[0]==0 || results[1]==0
        UI.messagebox("Grid dimension can't be zero!")
        self.onRButtonDown(flags, x, y, view)
        return nil
      end#if
      ###
      @grid_width=results[0]
      @grid_height=results[1]
    end
    @set="Size=#{@wp_width}x#{@wp_height}"
    if @grid_boolean
      @set << ",Grid=#{@grid_width}x#{@grid_height}"
    else
      @set << ",No Grid"
    end#if
    @msg0="WorkPlane: Click 1st Point: Center-Alignment, <Tab>=Corner, Right_Click [in empty space] to change Settings [#{@set}]..."
    @msg0x="WorkPlane: Click 1st Point: Corner-Alignment, <Tab>=Center, Right_Click [in empty space] to change Settings [#{@set}]..."
    @msg1="WorkPlane: Click 2nd Point: Right_Click [in empty space] to change Settings [#{@set}]..."
    @msg2="WorkPlane: Click 3rd Point: Right_Click [in empty space] to change Settings [#{@set}]..."
    Sketchup::set_status_text(@msg)###
end

def onCancel(flag=nil, view=nil)
    @group.erase! if @group && @group.valid?
    self.commit(view)
end

def resume(view=nil)
    Sketchup::set_status_text(@msg)
end

# This is called when the user types a value into the VCB
def onUserText(text, view)
    # The user may type in something that we can't parse as a length
    # so we set up some exception handling to trap that
    begin
        value=text.to_l
    rescue
        # Error parsing the text
        UI.beep
        puts "Can't make that into a length!"
        value=nil
        Sketchup::set_status_text("", SB_VCB_VALUE)
    end
    return unless value
    ###
    case @state
      when 1 # update the width
        vec=@pts[1] - @pts[0]
        if vec.length > 0.0
            vec.length=value
            @pts[1]=@pts[0].offset(vec)
            view.invalidate
            self.increment_state()
        end
        @msg=@msg1
        Sketchup::set_status_text(@msg)###
      when 2 # update the height
        vec=@pts[3] - @pts[0]
        if vec.length > 0.0
            vec.length=value
            @pts[2]=@pts[1].offset(vec)
            @pts[3]=@pts[0].offset(vec)
            self.increment_state()
        end
        @msg=@msg2
        Sketchup::set_status_text(@msg)###
    end
end

def getExtents
    bb=Geom::BoundingBox.new
    case @state
      when 0 # We are getting the first point
        if @ip.valid? && @ip.display?
            bb.add(@ip.position)
        end
      when 1
        bb.add(@pts[0]) if @pts[0]
        bb.add(@pts[1]) if @pts[1]
      when 2
        @pts.each{|p|bb.add(p) if p && p.is_a?(Geom::Point3d)} if @pts
    end
    bb
end

def draw(view)
    @drawn=false
    view.line_width=3
    ###
    if @state==0
        if @ip.valid? && @ip.display?
            @ip.draw(view)
            @drawn=true
        end
    elsif @state==1
        if @ip.valid? && @ip.display?
            @ip.draw(view)
            @drawn=true
        end
        # just draw a line from the start to the end point
        view.set_color_from_line(@ip1, @ip)
        view.draw(GL_LINE_STRIP, @pts[0], @pts[1])
        @drawn=true
    elsif @state==2
        if @ip.valid? && @ip.display?
            @ip.draw(view)
            @drawn=true
        end
        # draw the rectangle
        view.drawing_color="orange"
        view.draw(GL_LINE_STRIP, @pts[0], @pts[1])
        view.draw(GL_LINE_STRIP, @pts[0], @pts[3])
        @drawn=true
    else
        # draw axis/plane line only
        view.drawing_color="orange"
        view.draw(GL_LINE_STRIP, @pts[0], @pts[1])
        view.draw(GL_LINE_STRIP, @pts[0], @pts[3])
        @drawn=true
        view.tooltip="Double_Click=Confirm"
    end
end

def onKeyDown(key, rpt, flags, view)
    if( key == CONSTRAIN_MODIFIER_KEY && rpt == 1 )
        @shift_down_time=Time.now
        # if we already have an inference lock, then unlock it
        if( view.inference_locked? )
            view.lock_inference
        elsif( @state == 0 )
            view.lock_inference @ip
        elsif( @state == 1 )
            view.lock_inference @ip, @ip1
        end
    end
end

def onKeyUp(key, rpt, flags, view)
    if( key == CONSTRAIN_MODIFIER_KEY &&
        view.inference_locked? &&
        (Time.now - @shift_down_time) > 0.5 )
        view.lock_inference
    end
    ### tab to toggle plane...
    if key==9 || key==15 ### TAB =9 for PC, MAC 15 for some locales ?
      if @state==0 # befor 1st point toggle center/corner
        if @cen ### center
          @cen=false ### corner
          @msg=@msg0x
        else ### corner
          @cen=true ### center
          @msg=@msg0
        end#if
      elsif @state==4 # wp made
        if @tab ### planar
          @rot=@rot*-1
          tr=Geom::Transformation.rotation(@pts[0],(@pts[0].vector_to(@pts[1])),@rot)
          @group.transform!(tr)
          @msg=@msg4
          @tab=false ### perp
        else
          @rot=@rot*-1
          tr=Geom::Transformation.rotation(@pts[0],(@pts[0].vector_to(@pts[1])),@rot)
          @group.transform!(tr)
          @msg=@msg3
          @tab=true ### planar
       end#if
       view.invalidate if @ip.display? || @ip1.display?
     end#if
    end#if
    ###
    Sketchup::set_status_text(@msg)
end

def onLButtonDoubleClick(flags, x, y, view)
    if @state>3
      self.commit(view)
    end#if
end

def onReturn(view)
    if @state>3
      self.commit(view)
    end#if
end

def commit(view=nil)
    @temp_clines.each{|e|e.erase! if e.valid?} if @temp_clines
    @model.commit_operation
    Sketchup::set_status_text("",SB_PROMPT)
    Sketchup::set_status_text("",SB_VCB_LABEL)
    Sketchup::set_status_text("",SB_VCB_VALUE)
    view.invalidate if view && @drawn
    @state=5
    Sketchup.send_action("selectSelectionTool:")
    return nil
end

def WorkPlane::selected()
    Sketchup.active_model.selection.grep(Sketchup::Group).each{|e|
      if e.name=="WorkPlane"
        return true
        break
      end#if
    }
    return false
end

def WorkPlane::delete(all=false)
    model=Sketchup.active_model
    model.start_operation("WorkPlane Delete")
    wps=[]
    if all
      model.entities.grep(Sketchup::Group).each{|e|
        if e.name=="WorkPlane"
          wps << e
        end#if
      }
      model.definitions.each{|d|
        d.entities.grep(Sketchup::Group).each{|e|
          if e.name=="WorkPlane"
            wps << e
          end#if
        }
      }
    else ### just selected
      model.selection.grep(Sketchup::Group).each{|e|
      if e.name=="WorkPlane"
        wps << e
      end#if
      }
    end#if
    wps.each{|w|
      next unless w.valid?
      w.erase!
    }
    model.commit_operation
end

def WorkPlane::lock(lock=false, all=false)
    model=Sketchup.active_model
    if lock
       model.start_operation("WorkPlane Lock")
    else
       model.start_operation("WorkPlane Unlock")
    end#if
    wps=[]
    if all
      model.entities.grep(Sketchup::Edge).each{|e|
        if e.name=="WorkPlane"
          wps << e
        end#if
      }
      model.definitions.each{|d|
        d.entities.grep(Sketchup::Edge).each{|e|
          if e.name=="WorkPlane"
            wps << e
          end#if
        }
      }
    else ### just selected
      model.selection.grep(Sketchup::Group).each{|e|
      if e.name=="WorkPlane"
        wps << e
      end#if
      }
    end#if
    wps.each{|w|
      next unless w.valid?
      if lock
        w.locked=true
      else
        w.locked=false
      end#if
    }
    model.commit_operation
end

def WorkPlane::hide?
    model=Sketchup.active_model
    layers=model.layers
    return nil unless wpl=layers["WORKPLANE"]
    model.active_layer=nil if model.active_layer==wpl
    if wpl.visible?
      wpl.visible=false
    else
      wpl.visible=true
    end#if
end

def WorkPlane::alone?()
    model=Sketchup.active_model
    ss=model.selection
    return false if ss[1]
    return true if ss[0].is_a?(Sketchup::Group) && ss[0].name=="WorkPlane"
    return false
end

def WorkPlane::plane?()
    model=Sketchup.active_model
    ss=model.selection
    return false if ss[1]
    return false unless ss[0].is_a?(Sketchup::Group)
    return false unless ss[0].name=="WorkPlane"
    return false if ss[0].get_attribute("WorkPlane","prot",false)
    return true
end

def WorkPlane::adjust()
  @msg="WorkPlane: Adjust Settings..."
  Sketchup::set_status_text(@msg)###
  @model=Sketchup.active_model
  @model.start_operation("Adjust WorkPlane")
  @ents=@model.active_entities
  ss=@model.selection
  wp=ss[0]
  return nil unless wp
  tr=wp.transformation
  ###
  if wp.get_attribute("WorkPlane","disk",false) ### it's a wp disk
    @div=@model.get_attribute("WorkPlane","div",15.0)
    seg=(360.0/@div).to_i
    @seg=@model.get_attribute("WorkPlane","seg",seg)
    @ring=@model.get_attribute("WorkPlane","ring",4)
    ###
    prompts=["Number of Segments: ","Number of Rings: "]
    values=[@seg,@ring]
    pops=["",""]
    title="WorkPlaneDisk Settings"
    results=inputbox(prompts,values,pops,title)
    return nil unless results
    ### trap unacceptablke values
    if results[0]<3
      UI.messagebox("WorkPlaneDisk Segments can't be less than 3!")
      WorkPlane::adjust()
      return nil
    end#if
    if results[1]<1
      UI.messagebox("WorkPlaneDisk Rings can't be less than 1!")
      WorkPlane::adjust()
      return nil
    end#if
    ###
    @seg=results[0]
    @ring=results[1]
    ###
    def WorkPlane::acircle(center,normal,radius,numseg=24)
      # Get the x && y axes
      axes=Geom::Vector3d.new(normal).axes
      center=Geom::Point3d.new(center)
      xaxis=axes[0]
      yaxis=axes[1]
      xaxis.length=radius
      yaxis.length=radius
      # compute the points
      da=360.degrees / numseg
      pts=[]
      for i in 0...numseg do
        angle=i * da
        cosa=Math.cos(angle)
        sina=Math.sin(angle)
        vec=Geom::Vector3d.linear_combination(cosa,xaxis,sina,yaxis)
        pts << (center + vec)
      end
      # close the circle
      pts << (pts[0].clone) ### close the loop
      return pts
    end#def
    num=@seg
      @rad=wp.bounds.width/2
        pts=acircle(ORIGIN, Z_AXIS, @rad, num)
        ### add circle points based on divn ####################
        @group=@ents.add_group()
        @group.name="WorkPlane"
        wplayer=@model.layers.add("WORKPLANE")
        wplayer.visible=true
        @group.layer=wplayer
        @group.casts_shadows=false
        @group.receives_shadows=false
        ###
        unless mat=@model.materials["WorkPlaneMaterial"]
          mat=@model.materials.add("WorkPlaneMaterial") 
          mat.alpha=0.1
          mat.color=[255,123,0] ### warm yellow
        end#if
        ###
        gents=@group.entities
        ###
        face=gents.add_face(pts)
        face.material=mat
        face.back_material=mat
        ###
        gents.grep(Sketchup::Edge).each{|e|e.hidden=true}
        ###
        ### add seg grids
        num.times{|i|gents.add_cline(ORIGIN, pts[i])}
        ### add cline circle && any sub rings
        @ring.times{|i|
          pts=acircle(ORIGIN, Z_AXIS, (i+1)*@rad/(@ring), num)
          (pts.length-1).times{|i|gents.add_cline(pts[i],pts[i+1])}
        }
        ### match wp tr
        @group.transform!(tr)
        ###
        @group.locked=true
        ###
        @group.set_attribute("WorkPlane","disk",true)
        @model.set_attribute("WorkPlane","seg",@seg)
        @model.set_attribute("WorkPlane","ring",@ring)
      ### remove original wp
      wp.erase!
      ### reset ss as it was
      ss.clear
      ss.add(@group)
      ###
  elsif ! wp.get_attribute("WorkPlane","prot",false)
    ### it's a plane ### else it's a protrcator
    @cen=wp.get_attribute("WorkPlane","cen",true)
    ### dialog info
    @wp_width=@model.get_attribute("WorkPlane","wp_width",nil)
    @wp_height=@model.get_attribute("WorkPlane","wp_height",nil)
    @grid_width=@model.get_attribute("WorkPlane","grid_width",nil)
    @grid_height=@model.get_attribute("WorkPlane","grid_height",nil)
    @grid=@model.get_attribute("WorkPlane","grid",nil)
    if @model.options["UnitsOptions"]["LengthUnit"]<=1 ### it's '/"
      @wp_width=50.0.feet unless @wp_width
      @wp_height=50.0.feet unless @wp_height
      @grid_width=5.0.feet unless @grid_width
      @grid_height=5.0.feet unless @grid_height
    else ### it's metric
      @wp_width=10.0.m unless @wp_width
      @wp_height=10.0.m unless @wp_height
      @grid_width=1.0.m unless @grid_width
      @grid_height=1.0.m unless @grid_height
    end#if
    ###
    #units="meters"
    #units="feet" if @model.options["UnitsOptions"]["LengthUnit"]<=1 ### it's '/"
    prompts=["Width: ","Height: ", "Grid?: "]
    values=[@wp_width, @wp_height, @grid]
    grids="true|false"
    pops=["", "", grids]
    title="Adjust WorkPlane"# ["+units+"]"
    results=inputbox(prompts, values, pops, title)
    return nil unless results
    ### trap zero
    if results[0]==0 || results[1]==0
      UI.messagebox("WorkPlane dimension can't be zero!")
      WorkPlane::adjust()
      return nil
    end#if
    ###
    @wp_width=results[0]
    @wp_height=results[1]
    @grid=results[2]
    if @grid=="true"
      @grid_boolean=true
    else
      @grid_boolean=false
    end
    if @grid_boolean
      prompts=["Grid Width: ", "Grid Height: "]
      values=[@grid_width, @grid_height]
      pops=["", ""]
      title="Adjust WorkPlane Grid"# ["+units+"]"
      results=inputbox(prompts, values, pops, title)
      return nil unless results
      ### trap zero
      if results[0]==0 || results[1]==0
        UI.messagebox("Grid dimension can't be zero!")
        WorkPlane::adjust()
        return nil
      end#if
      ###
      @grid_width=results[0]
      @grid_height=results[1]
    end
    ### got past dialog
    ss.clear
    ### make new wp
        ents=@model.active_entities
        ### we make wp flat && move && rotate it into place
        pts=[] ### we now center/corner the wp at @pts[0]
        if @cen
          pts[0]=ORIGIN.offset(X_AXIS,@wp_width/-2)
          pts[0].offset!(Y_AXIS,@wp_height/-2)
          pts[1]=pts[0].offset(X_AXIS,@wp_width)
          pts[2]=pts[1].offset(Y_AXIS,@wp_height)
          pts[3]=pts[0].offset(Y_AXIS,@wp_height)
        else # corner
          pts[0]=Geom::Point3d.new(0,0,0)
          pts[1]=pts[0].offset(X_AXIS,@wp_width)
          pts[2]=pts[1].offset(Y_AXIS,@wp_height)
          pts[3]=pts[0].offset(Y_AXIS,@wp_height)
        end#if
        @group=ents.add_group()
        @group.name="WorkPlane"
        wplayer=@model.layers.add("WORKPLANE")
        wplayer.visible=true
        @group.layer=wplayer
        @group.casts_shadows=false
        @group.receives_shadows=false
        ###
        unless mat=@model.materials["WorkPlaneMaterial"]
          mat=@model.materials.add("WorkPlaneMaterial") 
          mat.alpha=0.1
          mat.color=[255,123,0] ### warm yellow
        end#if
        ###
        gents=@group.entities
        ###
        face=gents.add_face(pts)
        face.material=mat
        face.back_material=mat
        ###
        gents.grep(Sketchup::Edge).each{|e|e.hidden=true}
        gents.add_cline(pts[0],pts[1])
        gents.add_cline(pts[1],pts[2])
        gents.add_cline(pts[2],pts[3])
        gents.add_cline(pts[3],pts[0])
        if @grid_boolean ## add clines
          ### horiz
          p0=pts[0].offset(pts[0].vector_to(pts[3]), @wp_height/2)
          p1=pts[1].offset(pts[0].vector_to(pts[3]), @wp_height/2)
          ###
          num=(pts[0].distance(pts[3])/@grid_height/2).ceil
          num.times{|i|
            gents.add_cline(p0,p1)
            p0.offset!(pts[0].vector_to(pts[3]),@grid_height)
            p1.offset!(pts[0].vector_to(pts[3]),@grid_height)
          }
          p0=pts[0].offset(pts[0].vector_to(pts[3]), @wp_height/2)
          p1=pts[1].offset(pts[0].vector_to(pts[3]), @wp_height/2)
          ###
          num.times{|i|
            gents.add_cline(p0,p1)
            p0.offset!(pts[3].vector_to(pts[0]),@grid_height)
            p1.offset!(pts[3].vector_to(pts[0]),@grid_height)
          }
          ### vert
          p0=pts[0].offset(pts[0].vector_to(pts[1]), @wp_width/2)
          p3=pts[3].offset(pts[0].vector_to(pts[1]), @wp_width/2)
          ###
          num=(pts[0].distance(pts[1])/@grid_width/2).ceil
          num.times{|i|
            gents.add_cline(p0,p3)
            p0.offset!(pts[0].vector_to(pts[1]),@grid_width)
            p3.offset!(pts[0].vector_to(pts[1]),@grid_width)
          }
          p0=pts[0].offset(pts[0].vector_to(pts[1]), @wp_width/2)
          p3=pts[3].offset(pts[0].vector_to(pts[1]), @wp_width/2)
          ###
          num.times{|i|
            gents.add_cline(p0,p3)
            p0.offset!(pts[1].vector_to(pts[0]),@grid_width)
            p3.offset!(pts[1].vector_to(pts[0]),@grid_width)
          }
        end
        ### use tr of wp
        @group.transform!(tr)
        ###
        @group.locked=true
        ###
    ### remember settings
    @group.set_attribute("WorkPlane","cen",@cen)
    ###
    @model.set_attribute("WorkPlane","wp_width",@wp_width)
    @model.set_attribute("WorkPlane","wp_height",@wp_height)
    @model.set_attribute("WorkPlane","grid_width",@grid_width)
    @model.set_attribute("WorkPlane","grid_height",@grid_height)
    @model.set_attribute("WorkPlane","grid",@grid)
    ###
    ### delete old wp && reselct new wp @group
    wp.erase!
    ss.add(@group)
    ###
    @model.commit_operation
  end#if seg
  ###
  Sketchup::set_status_text("",SB_PROMPT)
  Sketchup::set_status_text("",SB_VCB_LABEL)
  Sketchup::set_status_text("",SB_VCB_VALUE)
  @model.active_view.invalidate
  Sketchup.send_action("selectSelectionTool:")
  return nil
end

def WorkPlane::rotate(opt=0)
    @msg="WorkPlane: Rotation Angle..."
    Sketchup::set_status_text(@msg)###
    @model=Sketchup.active_model
    @model.start_operation("Rotate WorkPlane")
    ss=@model.selection
    wp=ss[0]
    return nil unless wp
    ### dialog
    prompts=["Angle: "]
    values=[15.0]
    pops=[""]
    title="Rotate WorkPlane [Degrees]"
    results=inputbox(prompts, values, pops, title)
    return nil unless results
    ### trap zero
    return nil if results[0]==0
    ###
    angle=results[0].degrees
    ###
    ### see if centered
    wptrans=wp.transformation
    case opt
      when 1 #y
        axis = wptrans.yaxis
      when 2 #z
        axis = wptrans.zaxis
      else #0 = x
        axis = wptrans.xaxis
    end#case
    if wp.get_attribute("WorkPlane","cen",true)
      pt=wptrans.origin
    else ### by corner
      pt=wp.bounds.min
    end#if
    tr=Geom::Transformation.rotation(pt, axis, angle)
    wp.transform!(tr)
    ###
    @model.commit_operation
    ###
    Sketchup::set_status_text("",SB_PROMPT)
    Sketchup::set_status_text("",SB_VCB_LABEL)
    Sketchup::set_status_text("",SB_VCB_VALUE)
    @model.active_view.invalidate
    Sketchup.send_action("selectSelectionTool:")
    return nil
end

end#class WorkPlane


#####################------------------------------------------

class WorkPlaneMove

def initialize()
    @ip1 = nil
    @ip2 = nil
    @xdown = 0
    @ydown = 0
	begin
		SCFapi.store_event('T87GcvasDHDa432hBgfP', 'WorkPlane', 'WorkPlaneMove', 'Run')
		SCFapi.send_events('T87GcvasDHDa432hBgfP')
	rescue
	end
end

def activate
    @model=Sketchup.active_model
    @ents=@model.active_entities
    @ip1=Sketchup::InputPoint.new
    @ip2=Sketchup::InputPoint.new
    @ip=Sketchup::InputPoint.new
    ss=@model.selection
    @wp=ss[0]
    return nil unless @wp
    @tra=@wp.transformation.to_a
    self.reset()
end

def deactivate(view)
    @temp_clines.erase! if @temp_clines && @temp_clines.valid?
    @wp.transformation=@tra if @state != 2
    view.invalidate if @drawn
    return nil
end

def reset(view=nil)
    @msg1="WorkPlane Move: Pick 1st Point..."
    @msg2="WorkPlane Move: Pick 2nd Point, or Type Distance..."
    @msg=@msg1
    Sketchup::set_status_text(@msg)###
    @state=0
    @ip1.clear
    @ip2.clear
    if view
      view.tooltip=nil
      view.invalidate if @drawn
    end
    @drawn=false
    @dragging=false
    @model.start_operation("Move WorkPlane")
    bb=@wp.bounds
    pts=[]
    8.times{|i|pts[i]=bb.corner(i)}
    pts.compact!
    @temp_clines=@ents.add_group()
    tents=@temp_clines.entities
    tents.add_cline(pts[0],pts[1])
    tents.add_cline(pts[1],pts[3])
    tents.add_cline(pts[3],pts[2])
    tents.add_cline(pts[2],pts[0])
    tents.add_cline(pts[0],pts[4])
    tents.add_cline(pts[1],pts[5])
    tents.add_cline(pts[3],pts[7])
    tents.add_cline(pts[2],pts[6])
    tents.add_cline(pts[4],pts[5])
    tents.add_cline(pts[5],pts[7])
    tents.add_cline(pts[7],pts[6])
    tents.add_cline(pts[6],pts[4])
end

def onMouseMove(flags, x, y, view)
    if @state==0
        @ip.pick(view, x, y)
        if @ip != @ip1
          view.invalidate if( @ip.display? || @ip1.display? )
          @ip1.copy!(@ip)
          view.tooltip=@ip1.tooltip
        end
    else
        @ip2.pick(view, x, y, @ip1)
        view.tooltip=@ip2.tooltip if @ip2.valid?
        view.invalidate
        if @ip2.valid?
          length=@ip1.position.distance(@ip2.position)
          Sketchup::set_status_text(length.to_s, SB_VCB_VALUE)
        end
        if (x-@xdown).abs > 10 || (y-@ydown).abs > 10
          @dragging=true
        end
        self.move(@po, @ip2.position, view) if @ip2.valid?
        @po=@ip2.position
    end
end

def onLButtonDown(flags, x, y, view)
    if @state==0
        @ip1.pick(view, x, y)
        if @ip1.valid?
          @state=1
          Sketchup::set_status_text(@msg2)
          @xdown=x
          @ydown=y
          @po=@ip1.position
        end
    else
        if @ip2.valid? && @ip1.position!=@ip2.position
          @state=2
          self.commit(@po, @ip2.position, view)
        else
          UI.beep
        end
    end
    view.lock_inference
end

def onLButtonUp(flags, x, y, view)
    if @dragging && @ip2.valid?
      @state=2
      self.commit(@po, @ip2.position, view)
    end
end

def onKeyDown(key, repeat, flags, view)
    if key==CONSTRAIN_MODIFIER_KEY && repeat==1
      @shift_down_time = Time.now
      if view.inference_locked?
        view.lock_inference
      elsif @state == 0 && @ip1.valid?
        view.lock_inference @ip1
      elsif @state == 1 && @ip2.valid?
        view.lock_inference @ip2, @ip1
      end
    end
end

def onKeyUp(key, repeat, flags, view)
    if key==CONSTRAIN_MODIFIER_KEY && view.inference_locked? && (Time.now - @shift_down_time) > 0.5
      view.lock_inference
    end
end

def onUserText(text, view)
    return unless @state==1
    return unless @ip2.valid?
    begin
        value = text.to_l
    rescue # Error parsing the text
        UI.beep
        puts "Cannot convert #{text} to a Length"
        value = nil
        Sketchup::set_status_text("", SB_VCB_VALUE)
    end
    return unless value
    pt1 = @po
    vec = @ip2.position - pt1
    if vec.length == 0.0
      UI.beep
      return
    end
    vec.length = value
    pt2 = pt1 + vec
    @state=2
    self.commit(pt1, pt2, view)
end

def draw(view)
    if @ip1.valid?
      if @ip1.display?
        @ip1.draw(view)
        @drawn=true
      end
      if @ip2.valid?
        @ip2.draw(view) if @ip2.display?
        view.set_color_from_line(@ip1, @ip2)
        self.draw_geometry(@ip1.position, @ip2.position, view)
        @drawn=true
      end
    end
end

def onCancel(flag=nil, view=nil)
    @wp.transformation=@tra if @state != 2
    @temp_clines.erase! if @temp_clines && @temp_clines.valid?
    Sketchup.send_action("selectSelectionTool:")
    return nil
end

def resume(view=nil)
    Sketchup::set_status_text(@msg)
end

def draw_geometry(pt1, pt2, view)
    view.draw_line(pt1, pt2)
end

def move(pt1, pt2, view=nil)
    tr=Geom::Transformation.new(pt1.vector_to(pt2))
    @wp.transform!(tr)
    view.invalidate if view
end#move

def commit(pt1, pt2, view=nil)
    @temp_clines.erase! if @temp_clines && @temp_clines.valid?
    view.invalidate if view
    @model.commit_operation
    self.onCancel()
    return nil
end


end#class

#####################------------------------------------------

class WorkPlaneToggle

def initialize()
	begin
		SCFapi.store_event('T87GcvasDHDa432hBgfP', 'WorkPlane', 'WorkPlaneToggle', 'Run')
		SCFapi.send_events('T87GcvasDHDa432hBgfP')
	rescue
	end
end

def activate
    @model=Sketchup.active_model
    ss=@model.selection
    return nil unless ss[0]
    wp=ss[0]
    if wp.get_attribute("WorkPlane","prot",false)
      UI.beep
      puts "It's a Protrcator!"
      return nil
    end#if
    tr=wp.transformation
    ents=wp.entities
    enta=ents.to_a
    cen=wp.bounds.center
    min=wp.bounds.min
    ori=tr.origin
    @cen=wp.get_attribute("WorkPlane","cen",true)
    @model.start_operation("WorkPlane Toggle Center:Corner")
    if @cen ### move to corner
      vec=min.vector_to(ori)
      tr=Geom::Transformation.translation(vec)
      wp.transform!(tr)
      wp.set_attribute("WorkPlane","cen",false)
    else ### move to center
      vec=ori.vector_to(min)
      tr=Geom::Transformation.translation(vec)
      wp.transform!(tr)
      wp.set_attribute("WorkPlane","cen",true)
    end#if
    @model.commit_operation
    Sketchup.send_action("selectSelectionTool:")
    return nil
end

end#class

########################


class WorkPlaneDisk #######################################

def initialize()
    @ip=Sketchup::InputPoint.new
    @ip1=Sketchup::InputPoint.new
	begin
		SCFapi.store_event('T87GcvasDHDa432hBgfP', 'WorkPlane', 'WorkPlaneDisk', 'Run')
		SCFapi.send_events('T87GcvasDHDa432hBgfP')
	rescue
	end
end

def reset()
    @model=Sketchup.active_model
    @ents=@model.active_entities
    @pts=[]
    @state=0
    @ip.clear
    @ip1.clear
    @drawn=false
    @group=nil
    @tab=true ### planar v. 90deg
    @temp_clines=[]
    @rot=90.degrees
    ### check if remembered
    @div=@model.get_attribute("WorkPlane","div",15.0)
    seg=(360/@div).to_i
    @seg=@model.get_attribute("WorkPlane","seg",seg)
    @ring=@model.get_attribute("WorkPlane","ring",4)
    @rad=0.0
    ### force guides/transparncy 'on'
    @model.rendering_options["MaterialTransparency"]=true
    @model.rendering_options["HideConstructionGeometry"]=false
    ###
    Sketchup::set_status_text("", SB_VCB_LABEL)
    Sketchup::set_status_text("", SB_VCB_VALUE)
    @set="Segs=#{@seg}, Rings=#{@ring}"
    @msg0="WorkPlaneDisk: Click 1st Point [Center]: Right_Click [in empty space] to change Settings [#{@set}]..."
    @msg1="WorkPlaneDisk: Click 2nd Point [Radius]: Right_Click [in empty space] to change Settings [#{@set}]..."
    @msg2="WorkPlaneDisk: Click 3rd Point [Plane]: Right_Click [in empty space] to change Settings [#{@set}]..."
    @msg3="WorkPlaneDisk: <Enter>/Double_Click=Confirm, OR <Tab>=Perpendicular, OR <Esc>=Abort ..."
    @msg4="WorkPlaneDisk: <Enter>/Double_Click=Confirm, OR <Tab>=Planar, OR <Esc>=Abort ..."
    @msg=@msg0
    Sketchup::set_status_text(@msg)###
    @shift_down_time=Time.now
end

def activate
    self.reset()
end

def deactivate(view=nil)
    @group.erase! if @group && @group.valid? && @state==4
    self.commit(view)
end

def set_current_point(x, y, view)
    unless @ip.pick(view, x, y, @ip1)
        return false
    end
    need_draw=true
    view.tooltip=@ip.tooltip   
    # Compute points
    case @state
      when 0
        @pts[0]=@ip.position
        @pts[4]=@pts[0]
        need_draw=@ip.display? || @drawn
        @msg=@msg0
        Sketchup::set_status_text(@msg)###
      when 1
        @pts[1]=@ip.position
        @rad=@pts[0].distance(@pts[1])
        Sketchup::set_status_text(@rad.to_s, SB_VCB_VALUE)
        @msg=@msg1
        Sketchup::set_status_text(@msg)###
      when 2
        ###
        @temp_clines[1..-1].each{|e|e.erase! if e.valid?}if @temp_clines && @temp_clines[1]
        @temp_clines=[@temp_clines[0]]
        ###
        pt1=@ip.position
        pt2=pt1.project_to_line @pts
        vec=pt1 - pt2
        @height=vec.length
        if @height > 0
            # test for a square
            square_point=pt2.offset(vec, @rad)
            if view.pick_helper.test_point(square_point, x, y)
                @height=@rad
                @pts[2]=@pts[1].offset(vec, @height)
                @pts[3]=@pts[0].offset(vec, @height)
                #view.tooltip="= 'Square'"
            else
                @pts[2]=@pts[1].offset(vec)
                @pts[3]=@pts[0].offset(vec)
            end
            ### temp vert center line
            p0=@pts[0].offset(@pts[3].vector_to(@pts[0]),@rad)
            p3=@pts[0].offset(@pts[0].vector_to(@pts[3]),@rad)
            cl=@ents.add_cline(p0,p3)
            cl.stipple="-.-"
            @temp_clines << cl            
            ### temp circle #########################
            norm=(@pts[0].vector_to(@pts[1])).cross(@pts[0].vector_to(@pts[3]))
            pts=self.circle(@pts[0],norm,@rad,@seg)
            (pts.length-1).times{|i|
              cl=@ents.add_cline(pts[i],pts[i+1])
              @temp_clines << cl    
            }
            ###
        end#if
        Sketchup::set_status_text(@height.to_s, SB_VCB_VALUE)
        @msg=@msg2
        Sketchup::set_status_text(@msg)###
    end
    view.invalidate if need_draw
end

def onMouseMove(flags, x, y, view)
    self.set_current_point(x, y, view)
end

def circle(center,normal,radius,numseg=24)
    # Get the x && y axes
    axes=Geom::Vector3d.new(normal).axes
    center=Geom::Point3d.new(center)
    xaxis=axes[0]
    yaxis=axes[1]
    xaxis.length=radius
    yaxis.length=radius
    # compute the points
    da=360.degrees / numseg
    pts=[]
    for i in 0...numseg do
        angle=i * da
        cosa=Math.cos(angle)
        sina=Math.sin(angle)
        vec=Geom::Vector3d.linear_combination(cosa,xaxis,sina,yaxis)
        pts << (center + vec)
    end
    # close the circle
    pts << (pts[0].clone) ### close the loop
    return pts
end#def

def make_workplane() ### disk
    if @pts[0] != @pts[3]# check for zero height
        ### we make wp flat && move && rotate it into place
        ### we now center the wp at @pts[0]
        num=@seg
        pts=self.circle(ORIGIN, Z_AXIS, @rad, num)
        ### add circle points based on divn ####################
        ###
        @group=@ents.add_group()
        @group.name="WorkPlane"
        wplayer=@model.layers.add("WORKPLANE")
        wplayer.visible=true
        @group.layer=wplayer
        @group.casts_shadows=false
        @group.receives_shadows=false
        ###
        unless mat=@model.materials["WorkPlaneMaterial"]
          mat=@model.materials.add("WorkPlaneMaterial") 
          mat.alpha=0.1
          mat.color=[255,123,0] ### warm yellow
        end#if
        ###
        gents=@group.entities
        ###
        face=gents.add_face(pts)
        face.material=mat
        face.back_material=mat
        ###
        gents.grep(Sketchup::Edge).each{|e|e.hidden=true}
        ###
        ### add seg grids
        num.times{|i|gents.add_cline(ORIGIN, pts[i])}
        ### add cline circle && any sub rings
        @ring.times{|i|
          pts=self.circle(ORIGIN, Z_AXIS, (i+1)*@rad/(@ring), num)
          (pts.length-1).times{|i|gents.add_cline(pts[i],pts[i+1])}
        }
        ### rotate to axes
        xaxis=@pts[0].vector_to(@pts[1])
        yaxis=@pts[0].vector_to(@pts[3])
        zaxis=xaxis.cross(yaxis)
        tr=Geom::Transformation.new(xaxis,yaxis,zaxis,ORIGIN)
        @group.transform!(tr)
        ### group is at ORIGIN - relocate it to 1st picked point
        tr=Geom::Transformation.new(@pts[0])
        @group.transform!(tr)
        ###
        @group.locked=true
        ###
        ### set for wp
        @group.set_attribute("WorkPlane","disk",true)               
        @model.set_attribute("WorkPlane","seg",@seg)
        @model.set_attribute("WorkPlane","ring",@ring)
        ###
        @msg=@msg3 ### tab
        Sketchup::set_status_text(@msg)###
        ###
    else ### can't make a wp
        UI.beep()
        puts "WorkPlaneDisk: Colinear Points can't define a Plane!"
        puts "Retry..."
        self.onCancel()
        return nil
    end
end

def increment_state()
    @state += 1
    case @state
      when 1
        @ip1.copy! @ip
        @msg=@msg1
        Sketchup::set_status_text(@msg)###
        Sketchup::set_status_text "Distance", SB_VCB_LABEL
        @msg=@msg1
        Sketchup::set_status_text(@msg)###
      when 2
        @ip1.clear
        @msg=@msg2
        Sketchup::set_status_text(@msg)###
        Sketchup::set_status_text "Distance", SB_VCB_LABEL
        @msg=@msg2
        Sketchup::set_status_text(@msg)###
      when 3
        self.make_workplane()
        @state=4
    end
end

def onLButtonDown(flags, x, y, view)
    self.set_current_point(x, y, view)
    if @state==2 && ! @pts[3]
      UI.beep
      return nil
    end#if
    self.increment_state()
    if @state==2
      @model.start_operation("New WorkPlaneDisk")
        # draw horiz center line first
        cl=@ents.add_cline(@pts[0].offset(@pts[1].vector_to(@pts[0]),@rad), @pts[0].offset(@pts[0].vector_to(@pts[1]),@rad))
        cl.stipple="-.-"
        @temp_clines << cl
    end#if
    view.lock_inference
end

def onRButtonDown(flags, x, y, view)
    ### [re]set options dialog
    prompts=["Number of Segments: ", "Number of Rings: "]
    values=[@seg, @ring]
    pops=["", ""]
    title="WorkPlaneDisk Settings"
    results=inputbox(prompts, values, pops, title)
    return nil unless results
    ### trap unacceptable values
    if results[0]<3
      UI.messagebox("WorkPlaneDisk Segments can't be less than 3!")
      self.onRButtonDown(flags, x, y, view)
      return nil
    end#if
    if results[1]<1
      UI.messagebox("WorkPlaneDisk Rings can't be less than 1!")
      self.onRButtonDown(flags, x, y, view)
      return nil
    end#if
    ###
    @seg=results[0]
    @ring=results[1]
    ###
    @set="Segs=#{@seg}, Rings=#{@ring}"
    @msg0="WorkPlaneDisk: Click 1st Point [Center]: Right_Click [in empty space] to change Settings [#{@set}]..."
    @msg1="WorkPlaneDisk: Click 2nd Point [Radius]: Right_Click [in empty space] to change Settings [#{@set}]..."
    @msg2="WorkPlaneDisk: Click 3rd Point [Plane]: Right_Click [in empty space] to change Settings [#{@set}]..."
    @msg3="WorkPlaneDisk: <Enter>/Double_Click=Confirm, OR <Tab>=Perpendicular, OR <Esc>=Abort ..."
    @msg4="WorkPlaneDisk: <Enter>/Double_Click=Confirm, OR <Tab>=Planar, OR <Esc>=Abort ..."
    Sketchup::set_status_text(@msg)###
end

def onCancel(flag=nil, view=nil)
    @group.erase! if @group && @group.valid?
    self.commit(view)
end

def resume(view=nil)
    Sketchup::set_status_text(@msg)
end

# This is called when the user types a value into the VCB
def onUserText(text, view)
    # The user may type in something that we can't parse as a length
    # so we set up some exception handling to trap that
    begin
        value=text.to_l
    rescue
        # Error parsing the text
        UI.beep
        puts "Can't make that into a length!"
        value=nil
        Sketchup::set_status_text("", SB_VCB_VALUE)
    end
    return unless value
    ###
    case @state
      when 1 # update the width
        vec=@pts[1] - @pts[0]
        if vec.length > 0.0
            vec.length=value
            @pts[1]=@pts[0].offset(vec)
            view.invalidate
            self.increment_state()
        end
        @msg=@msg1
        Sketchup::set_status_text(@msg)###
      when 2 # update the height
        vec=@pts[3] - @pts[0]
        if vec.length > 0.0
            vec.length=value
            @pts[2]=@pts[1].offset(vec)
            @pts[3]=@pts[0].offset(vec)
            self.increment_state()
        end
        @msg=@msg2
        Sketchup::set_status_text(@msg)###
    end
end

def getExtents
    bb=Geom::BoundingBox.new
    case @state
      when 0 # We are getting the first point
        if @ip.valid? && @ip.display?
            bb.add(@ip.position)
        end
      when 1
        bb.add(@pts[0]) if @pts[0]
        bb.add(@pts[1]) if @pts[1]
      when 2
        @pts.each{|p|bb.add(p) if p && p.is_a?(Geom::Point3d)} if @pts
    end
    bb
end

def draw(view)
    @drawn=false
    view.line_width=3
    ###
    if @state==0
        if @ip.valid? && @ip.display?
            @ip.draw(view)
            @drawn=true
        end
    elsif @state==1
        if @ip.valid? && @ip.display?
            @ip.draw(view)
            @drawn=true
        end
        # just draw a line from the start to the end point
        view.set_color_from_line(@ip1, @ip)
        view.draw(GL_LINE_STRIP, @pts[0], @pts[1])
        @drawn=true
    elsif @state==2
        if @ip.valid? && @ip.display?
            @ip.draw(view)
            @drawn=true
        end
        # draw the rectangle
        view.drawing_color="orange"
        view.draw(GL_LINE_STRIP, @pts[0], @pts[1])
        view.draw(GL_LINE_STRIP, @pts[0], @pts[3])
        @drawn=true
    else
        # draw axis/plane line only
        view.drawing_color="orange"
        view.draw(GL_LINE_STRIP, @pts[0], @pts[1])
        view.draw(GL_LINE_STRIP, @pts[0], @pts[3])
        @drawn=true
        view.tooltip="Double_Click=Confirm"
    end
end

def onKeyDown(key, rpt, flags, view)
    if( key == CONSTRAIN_MODIFIER_KEY && rpt == 1 )
        @shift_down_time=Time.now
        # if we already have an inference lock, then unlock it
        if( view.inference_locked? )
            view.lock_inference
        elsif( @state == 0 )
            view.lock_inference @ip
        elsif( @state == 1 )
            view.lock_inference @ip, @ip1
        end
    end
end

def onKeyUp(key, rpt, flags, view)
    if( key == CONSTRAIN_MODIFIER_KEY &&
        view.inference_locked? &&
        (Time.now - @shift_down_time) > 0.5 )
        view.lock_inference
    end
    ### tab to toggle plane...
    if key==9 || key==15 ### TAB =9 for PC, MAC 15 for some locales ?
      if @state==0 # befor 1st point toggle center/corner
        if @cen ### center
          @cen=false ### corner
        else ### corner
          @cen=true ### center
        end#if
      elsif @state==4 # wp made
        if @tab ### planar
          @rot=@rot*-1
          tr=Geom::Transformation.rotation(@pts[0],(@pts[0].vector_to(@pts[1])),@rot)
          @group.transform!(tr)
          @msg=@msg4
          @tab=false ### perp
        else
          @rot=@rot*-1
          tr=Geom::Transformation.rotation(@pts[0],(@pts[0].vector_to(@pts[1])),@rot)
          @group.transform!(tr)
          @msg=@msg3
          @tab=true ### planar
       end#if
       view.invalidate if @ip.display? || @ip1.display?
     end#if
    end#if
    ###
    Sketchup::set_status_text(@msg)
end

def onLButtonDoubleClick(flags, x, y, view)
    if @state>3
      self.commit(view)
    end#if
end

def onReturn(view)
    if @state>3
      self.commit(view)
    end#if
end

def commit(view=nil)
    @temp_clines.each{|e|e.erase! if e && e.valid?} if @temp_clines
    @model.commit_operation
    Sketchup::set_status_text("",SB_PROMPT)
    Sketchup::set_status_text("",SB_VCB_LABEL)
    Sketchup::set_status_text("",SB_VCB_VALUE)
    view.invalidate if view && @drawn
    @state=5
    Sketchup.send_action("selectSelectionTool:")
    return nil
end

end#class WorkPlaneDisk

#####################------------------------------------------
class WorkPlaneScale
  
  def initialize()
	begin
		SCFapi.store_event('T87GcvasDHDa432hBgfP', 'WorkPlane', 'WorkPlaneScale', 'Run')
		SCFapi.send_events('T87GcvasDHDa432hBgfP')
	rescue
	end
  end
  
  def activate()
    @model=Sketchup.active_model
    ss=@model.selection
    return nil unless ss[0]
    return nil unless ss[0].is_a?(Sketchup::Group)
    return nil unless ss[0].name=="WorkPlane"
    @wp=ss[0]
    @wp.locked=false
    ss.clear
    ss.add(@wp)
    Sketchup.send_action("selectScaleTool:")
  end
  
  def deactivate(view=nil)
    view.invalidate if view
  end
  
  def onCancel(flag=nil, view=nil)
    Sketchup.send_action("selectSelectionTool:")
    return nil
  end
  
end#class


#####################------------------------------------------
class WorkPlaneRotate
  
  def initialize()
	begin
		SCFapi.store_event('T87GcvasDHDa432hBgfP', 'WorkPlane', 'WorkPlaneRotate', 'Run')
		SCFapi.send_events('T87GcvasDHDa432hBgfP')
	rescue
	end
  end
  
  def activate()
    @model=Sketchup.active_model
    ss=@model.selection
    return nil unless ss[0]
    return nil unless ss[0].is_a?(Sketchup::Group)
    return nil unless ss[0].name=="WorkPlane"
    @wp=ss[0]
    @wp.locked=false
    ss.clear
    ss.add(@wp)
    Sketchup.send_action("selectRotateTool:")
  end
  
  def deactivate(view=nil)
    view.invalidate if view
  end
  
  def onCancel(flag=nil, view=nil)
    Sketchup.send_action("selectSelectionTool:")
    return nil
  end
  
end#class

#########################=========================
class WorkPlaneProtractor

def initialize()
    @ip=Sketchup::InputPoint.new
    @ip1=Sketchup::InputPoint.new
	begin
		SCFapi.store_event('T87GcvasDHDa432hBgfP', 'WorkPlane', 'WorkPlaneProtractor', 'Run')
		SCFapi.send_events('T87GcvasDHDa432hBgfP')
	rescue
	end
end

def reset()
    @model=Sketchup.active_model
    @ents=@model.active_entities
    @pts=[]
    @state=0
    @ip.clear
    @ip1.clear
    @drawn=false
    @group=nil
    @tab=true ### planar v. 90deg
    @temp_clines=[]
    @seg=24
    @ring=2
    @rad=0.0
    ### force guides/transparncy 'on'
    @model.rendering_options["MaterialTransparency"]=true
    @model.rendering_options["HideConstructionGeometry"]=false
    ###
    Sketchup::set_status_text("", SB_VCB_LABEL)
    Sketchup::set_status_text("", SB_VCB_VALUE)
    @msg0="WorkPlaneProtractor: Click 1st Point [Center]..."
    @msg1="WorkPlaneProtractor: Click 2nd Point [Radius]..."
    @msg2="WorkPlaneProtractor: Click 3rd Point [Plane]..."
    @msg=@msg0
    Sketchup::set_status_text(@msg)###
    @shift_down_time=Time.now
end

def activate
    self.reset()
end

def deactivate(view=nil)
    @group.erase! if @group && @group.valid? && @state==4
    self.commit(view)
end

def set_current_point(x, y, view)
    unless @ip.pick(view, x, y, @ip1)
        return false
    end
    need_draw=true
    view.tooltip=@ip.tooltip   
    # Compute points
    case @state
      when 0
        @pts[0]=@ip.position
        @pts[4]=@pts[0]
        need_draw=@ip.display? || @drawn
        @msg=@msg0
        Sketchup::set_status_text(@msg)###
      when 1
        @pts[1]=@ip.position
        @rad=@pts[0].distance(@pts[1])
        Sketchup::set_status_text(@rad.to_s, SB_VCB_VALUE)
        @msg=@msg1
        Sketchup::set_status_text(@msg)###
      when 2
        ###
        @temp_clines[1..-1].each{|e|e.erase! if e.valid?}if @temp_clines && @temp_clines[1]
        @temp_clines=[@temp_clines[0]]
        ###
        pt1=@ip.position
        pt2=pt1.project_to_line @pts
        vec=pt1 - pt2
        @height=vec.length
        if @height > 0
            # test for a square
            square_point=pt2.offset(vec, @rad)
            if view.pick_helper.test_point(square_point, x, y)
                @height=@rad
                @pts[2]=@pts[1].offset(vec, @height)
                @pts[3]=@pts[0].offset(vec, @height)
                #view.tooltip="= 'Square'"
            else
                @pts[2]=@pts[1].offset(vec)
                @pts[3]=@pts[0].offset(vec)
            end
            ### temp vert center line
            p0=@pts[0].offset(@pts[3].vector_to(@pts[0]),@rad)
            p3=@pts[0].offset(@pts[0].vector_to(@pts[3]),@rad)
            cl=@ents.add_cline(p0,p3)
            cl.stipple="-.-"
            @temp_clines << cl            
            ### temp circle #########################
            norm=(@pts[0].vector_to(@pts[1])).cross(@pts[0].vector_to(@pts[3]))
            pts=self.circle(@pts[0],norm,@rad,@seg)
            (pts.length-1).times{|i|
              cl=@ents.add_cline(pts[i],pts[i+1])
              @temp_clines << cl    
            }
            ###
        end#if
        Sketchup::set_status_text(@height.to_s, SB_VCB_VALUE)
        @msg=@msg2
        Sketchup::set_status_text(@msg)###
    end
    view.invalidate if need_draw
end

def onMouseMove(flags, x, y, view)
    self.set_current_point(x, y, view)
end

def circle(center,normal,radius,numseg=24)
    # Get the x && y axes
    axes=Geom::Vector3d.new(normal).axes
    center=Geom::Point3d.new(center)
    xaxis=axes[0]
    yaxis=axes[1]
    xaxis.length=radius
    yaxis.length=radius
    # compute the points
    da=360.degrees / numseg
    pts=[]
    for i in 0...numseg do
        angle=i * da
        cosa=Math.cos(angle)
        sina=Math.sin(angle)
        vec=Geom::Vector3d.linear_combination(cosa,xaxis,sina,yaxis)
        pts << (center + vec)
    end
    # close the circle
    pts << (pts[0].clone) ### close the loop
    return pts
end#def

def make_workplane() ### disk
    if @pts[0] != @pts[3]# check for zero height
        ### we make wp flat && move && rotate it into place
        ### we now center the wp at @pts[0]
        num=@seg
        pts=self.circle(ORIGIN, Z_AXIS, @rad, num)
        ### add circle points based on divn ####################
        ###
        @group=@ents.add_group()
        @group.name="WorkPlane"
        wplayer=@model.layers.add("WORKPLANE")
        wplayer.visible=true
        @group.layer=wplayer
        @group.casts_shadows=false
        @group.receives_shadows=false
        ###
        unless mat=@model.materials["WorkPlaneMaterial"]
          mat=@model.materials.add("WorkPlaneMaterial") 
          mat.alpha=0.1
          mat.color=[255,123,0] ### warm yellow
        end#if
        ###
        gents=@group.entities
        ###
        face=gents.add_face(pts)
        face.material=mat
        face.back_material=mat
        ###
        gents.grep(Sketchup::Edge).each{|e|e.hidden=true}
        ###
        ### add seg grids
        num.times{|i|gents.add_cline(ORIGIN, pts[i])}
        ### add cline circle && any sub rings
        @ring.times{|i|
          pts=self.circle(ORIGIN, Z_AXIS, (i+1)*@rad/(@ring), num)
          (pts.length-1).times{|i|gents.add_cline(pts[i],pts[i+1])}
        }
        ### repeat for perp disks X
        pts=self.circle(ORIGIN, X_AXIS, @rad, num)
        face=gents.add_face(pts)
        face.material=mat
        face.back_material=mat
        ###
        gents.grep(Sketchup::Edge).each{|e|e.hidden=true}
        ### add seg grids
        num.times{|i|gents.add_cline(ORIGIN, pts[i])}
        ### add cline circle && any sub rings
        @ring.times{|i|
          pts=self.circle(ORIGIN, X_AXIS, (i+1)*@rad/(@ring), num)
          (pts.length-1).times{|i|gents.add_cline(pts[i],pts[i+1])}
        }
        ###  repeat for perp disks Y
        pts=self.circle(ORIGIN, Y_AXIS, @rad, num)
        face=gents.add_face(pts)
        face.material=mat
        face.back_material=mat
        ###
        gents.grep(Sketchup::Edge).each{|e|e.hidden=true}
        ### add seg grids
        num.times{|i|gents.add_cline(ORIGIN, pts[i])}
        ### add cline circle && any sub rings
        @ring.times{|i|
          pts=self.circle(ORIGIN, Y_AXIS, (i+1)*@rad/(@ring), num)
          (pts.length-1).times{|i|gents.add_cline(pts[i],pts[i+1])}
        }
        ### rotate to axes
        xaxis=@pts[0].vector_to(@pts[1])
        yaxis=@pts[0].vector_to(@pts[3])
        zaxis=xaxis.cross(yaxis)
        tr=Geom::Transformation.new(xaxis,yaxis,zaxis,ORIGIN)
        @group.transform!(tr)
        ### group is at ORIGIN - relocate it to 1st picked point
        tr=Geom::Transformation.new(@pts[0])
        @group.transform!(tr)
        ###
        @group.locked=true
        ### set 'prot' for wp
        @group.set_attribute("WorkPlane","prot",true)
        ###
    else ### can't make a wp
        UI.beep()
        puts "WorkPlaneDisk: Colinear Points can't define a Plane!"
        puts "Retry..."
        self.onCancel()
        return nil
    end
end

def increment_state()
    @state += 1
    case @state
      when 1
        @ip1.copy! @ip
        @msg=@msg1
        Sketchup::set_status_text(@msg)###
        Sketchup::set_status_text "Distance", SB_VCB_LABEL
        @msg=@msg1
        Sketchup::set_status_text(@msg)###
      when 2
        @ip1.clear
        @msg=@msg2
        Sketchup::set_status_text(@msg)###
        Sketchup::set_status_text "Distance", SB_VCB_LABEL
        @msg=@msg2
        Sketchup::set_status_text(@msg)###
      when 3
        self.make_workplane()
        @state=4
        self.commit()
    end
end

def onLButtonDown(flags, x, y, view)
    self.set_current_point(x, y, view)
    if @state==2 && ! @pts[3]
      UI.beep
      return nil
    end#if
    self.increment_state()
    if @state==2
      @model.start_operation("New WorkPlaneDisk")
        # draw horiz center line first
        cl=@ents.add_cline(@pts[0].offset(@pts[1].vector_to(@pts[0]),@rad), @pts[0].offset(@pts[0].vector_to(@pts[1]),@rad))
        cl.stipple="-.-"
        @temp_clines << cl
    end#if
    view.lock_inference
end

def onRButtonDown(flags, x, y, view)
    ### [re]set options dialog
    prompts=["Number of Segments: ", "Number of Rings: "]
    values=[@seg, @ring]
    pops=["", ""]
    title="WorkPlaneDisk Settings"
    results=inputbox(prompts, values, pops, title)
    return nil unless results
    ### trap unacceptable values
    if results[0]<3
      UI.messagebox("WorkPlaneDisk Segments can't be less than 3!")
      self.onRButtonDown(flags, x, y, view)
      return nil
    end#if
    if results[1]<1
      UI.messagebox("WorkPlaneDisk Rings can't be less than 1!")
      self.onRButtonDown(flags, x, y, view)
      return nil
    end#if
    ###
    @seg=results[0]
    @ring=results[1]
    ###
    @set="Segs=#{@seg}, Rings=#{@ring}"
    @msg0="WorkPlaneDisk: Click 1st Point [Center]: Right_Click [in empty space] to change Settings [#{@set}]..."
    @msg1="WorkPlaneDisk: Click 2nd Point [Radius]: Right_Click [in empty space] to change Settings [#{@set}]..."
    @msg2="WorkPlaneDisk: Click 3rd Point [Plane]: Right_Click [in empty space] to change Settings [#{@set}]..."
    @msg3="WorkPlaneDisk: <Enter>/Double_Click=Confirm, OR <Tab>=Perpendicular, OR <Esc>=Abort ..."
    @msg4="WorkPlaneDisk: <Enter>/Double_Click=Confirm, OR <Tab>=Planar, OR <Esc>=Abort ..."
    Sketchup::set_status_text(@msg)###
end

def onCancel(flag=nil, view=nil)
    @group.erase! if @group && @group.valid?
    self.commit(view)
end

def resume(view=nil)
    Sketchup::set_status_text(@msg)
end

# This is called when the user types a value into the VCB
def onUserText(text, view)
    # The user may type in something that we can't parse as a length
    # so we set up some exception handling to trap that
    begin
        value=text.to_l
    rescue
        # Error parsing the text
        UI.beep
        puts "Can't make that into a length!"
        value=nil
        Sketchup::set_status_text("", SB_VCB_VALUE)
    end
    return unless value
    ###
    case @state
      when 1 # update the width
        vec=@pts[1] - @pts[0]
        if vec.length > 0.0
            vec.length=value
            @pts[1]=@pts[0].offset(vec)
            view.invalidate
            self.increment_state()
        end
        @msg=@msg1
        Sketchup::set_status_text(@msg)###
      when 2 # update the height
        vec=@pts[3] - @pts[0]
        if vec.length > 0.0
            vec.length=value
            @pts[2]=@pts[1].offset(vec)
            @pts[3]=@pts[0].offset(vec)
            self.increment_state()
        end
        @msg=@msg2
        Sketchup::set_status_text(@msg)###
    end
end

def getExtents
    bb=Geom::BoundingBox.new
    case @state
      when 0 # We are getting the first point
        if @ip.valid? && @ip.display?
            bb.add(@ip.position)
        end
      when 1
        bb.add(@pts[0]) if @pts[0]
        bb.add(@pts[1]) if @pts[1]
      when 2
        @pts.each{|p|bb.add(p) if p && p.is_a?(Geom::Point3d)} if @pts
    end
    bb
end

def draw(view)
    @drawn=false
    view.line_width=3
    ###
    if @state==0
        if @ip.valid? && @ip.display?
            @ip.draw(view)
            @drawn=true
        end
    elsif @state==1
        if @ip.valid? && @ip.display?
            @ip.draw(view)
            @drawn=true
        end
        # just draw a line from the start to the end point
        view.set_color_from_line(@ip1, @ip)
        view.draw(GL_LINE_STRIP, @pts[0], @pts[1])
        @drawn=true
    elsif @state==2
        if @ip.valid? && @ip.display?
            @ip.draw(view)
            @drawn=true
        end
        # draw the rectangle
        view.drawing_color="orange"
        view.draw(GL_LINE_STRIP, @pts[0], @pts[1])
        view.draw(GL_LINE_STRIP, @pts[0], @pts[3])
        @drawn=true
    else
        # draw axis/plane line only
        view.drawing_color="orange"
        view.draw(GL_LINE_STRIP, @pts[0], @pts[1])
        view.draw(GL_LINE_STRIP, @pts[0], @pts[3])
        @drawn=true
        view.tooltip="Double_Click=Confirm"
    end
end

def onKeyDown(key, rpt, flags, view)
    if( key == CONSTRAIN_MODIFIER_KEY && rpt == 1 )
        @shift_down_time=Time.now
        # if we already have an inference lock, then unlock it
        if( view.inference_locked? )
            view.lock_inference
        elsif( @state == 0 )
            view.lock_inference @ip
        elsif( @state == 1 )
            view.lock_inference @ip, @ip1
        end
    end
end

def onKeyUp(key, rpt, flags, view)
    if( key == CONSTRAIN_MODIFIER_KEY &&
        view.inference_locked? &&
        (Time.now - @shift_down_time) > 0.5 )
        view.lock_inference
    end
end

def onLButtonDoubleClick(flags, x, y, view)
    ###
end

def onReturn(view)
    ###
end

def commit(view=nil)
    @temp_clines.each{|e|e.erase! if e && e.valid?} if @temp_clines
    @model.commit_operation
    Sketchup::set_status_text("",SB_PROMPT)
    Sketchup::set_status_text("",SB_VCB_LABEL)
    Sketchup::set_status_text("",SB_VCB_VALUE)
    view.invalidate if view && @drawn
    @state=5
    Sketchup.send_action("selectSelectionTool:")
    return nil
end

end# class


#####################------------------------------------------
# menu/toolbar
unless file_loaded?(__FILE__)
    ### toolbar
    text10 = "WorkPlane Tools"
    text11 = "New WorkPlane"
    text12 = "WorkPlane - makes a work-plane, with/without a grid"+"..."
    cmd1=UI::Command.new(text11){Sketchup.active_model.select_tool(WorkPlane.new())}
    cmd1.tooltip=text11
    cmd1.status_bar_text=text12
    cmd1.small_icon=File.join(File.dirname(__FILE__), "WorkPlane/WorkPlane16x16.png")
    cmd1.large_icon=File.join(File.dirname(__FILE__), "WorkPlane/WorkPlane24x24.png")
    ###
    text21 = "New WorkPlaneDisk"
    text22 = "WorkPlaneDisk - makes a work-plane-disk, with radial grid"+"..."
    cmd2=UI::Command.new(text21){Sketchup.active_model.select_tool(WorkPlaneDisk.new())}
    cmd2.tooltip=text21
    cmd2.status_bar_text=text22
    cmd2.small_icon=File.join(File.dirname(__FILE__), "WorkPlane/WorkPlaneDisk16x16.png")
    cmd2.large_icon=File.join(File.dirname(__FILE__), "WorkPlane/WorkPlaneDisk24x24.png")
    ###
    text31 = "New WorkPlaneProtractor"
    text32 = "WorkPlaneProtractor - makes a work-plane-protractor"+"..."
    cmd3=UI::Command.new(text31){Sketchup.active_model.select_tool(WorkPlaneProtractor.new())}
    cmd3.tooltip=text31
    cmd3.status_bar_text=text32
    cmd3.small_icon=File.join(File.dirname(__FILE__), "WorkPlane/WorkPlaneProtractor16x16.png")
    cmd3.large_icon=File.join(File.dirname(__FILE__), "WorkPlane/WorkPlaneProtractor24x24.png")
    ###
    $workPlaneToolbar=UI::Toolbar.new(text10)
    $workPlaneToolbar.add_item(cmd1)
    $workPlaneToolbar.add_item(cmd2)
    $workPlaneToolbar.add_item(cmd3)
    ###
    $workPlaneToolbar.restore if $workPlaneToolbar.get_last_state==TB_VISIBLE
    ### context menu
    UI.add_context_menu_handler{|cmenu|
      sub=cmenu.add_submenu("WorkPlane...")
      sub.add_item("New Plane"){Sketchup.active_model.select_tool(WorkPlane.new())}
      sub.add_item("New Disk"){Sketchup.active_model.select_tool(WorkPlaneDisk.new())}
      sub.add_item("New Protractor"){Sketchup.active_model.select_tool(WorkPlaneProtractor.new())}
      sub.add_item("Lock All"){WorkPlane::lock(true,true)}
      sub.add_item("UnLock All"){WorkPlane::lock(false,true)}
      sub.add_item("Hide/UnHide All"){WorkPlane::hide?()}
      if WorkPlane.alone?()
        sub.add_separator()
        if WorkPlane::plane?() ### NOT prot
          sub.add_item("Adjust"){WorkPlane::adjust()}
           sub.add_item("Toggle Center:Corner"){Sketchup.active_model.select_tool(WorkPlaneToggle.new())}
        end#if
        sub.add_item("Rotate on its X"){WorkPlane::rotate(0)}
        sub.add_item("Rotate on its Y"){WorkPlane::rotate(1)}
        sub.add_item("Rotate on its Z"){WorkPlane::rotate(2)}
        sub.add_item("Move"){Sketchup.active_model.select_tool(WorkPlaneMove.new())}
        sub.add_item("Rotate"){Sketchup.active_model.select_tool(WorkPlaneRotate.new())}
        sub.add_item("Scale"){Sketchup.active_model.select_tool(WorkPlaneScale.new())}
      end#if
      if WorkPlane.selected()
        sub.add_item("Lock Selected"){WorkPlane::lock(true,false)}
        sub.add_item("UnLock Selected"){WorkPlane::lock(false,false)}
        sub.add_item("Delete Selected"){WorkPlane::delete(false)}
        sub.add_separator()
      end#if
      sub.add_item("Delete All"){WorkPlane::delete(true)}
    }#do
    ### Tools menu
    smenu=UI.menu("Tools").add_submenu("WorkPlane...")
    smenu.add_item("New Plane"){Sketchup.active_model.select_tool(WorkPlane.new())}
    smenu.add_item("New Disk"){Sketchup.active_model.select_tool(WorkPlaneDisk.new())}
    smenu.add_item("New Protractor"){Sketchup.active_model.select_tool(WorkPlaneProtractor.new())}
    smenu.add_separator
    smenu.add_item("Lock All"){WorkPlane::lock(true,true)}
    smenu.add_item("UnLock All"){WorkPlane::lock(false,true)}
    smenu.add_item("Hide/UnHide All"){WorkPlane::hide?()}
    smenu.add_separator
    smenu.add_item("Delete All"){WorkPlane::delete(true)}
end
###
file_loaded(__FILE__)
###

###

end#module TIG

#####################------------------------------------------
def wp() ### shortcut command
    Sketchup.active_model.select_tool(TIG::WorkPlane.new())
    return ""
end
def wd() ### shortcut command
    Sketchup.active_model.select_tool(TIG::WorkPlaneDisk.new())
    return ""
end
def wpp() ### shortcut command
    Sketchup.active_model.select_tool(vWorkPlaneProtractor.new())
    return ""
end
###
