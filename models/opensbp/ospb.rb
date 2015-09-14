module Osbp

  extend self
  def use_absolute_coordinates
    cmd("SA", "Use Absolute Co-Ordinates")
  end
  def cn_command(number: nil)
    #These undocumented commands occur in some files
    if number == 91
      msg = "Run file explaining unit error"
    else
      msg = "Unknown Command"
    end
    cmd("CN, #{number}", msg)
  end

  def tool_change
    cmd("C9", "Tool Change")
  end

  def spindle_on
    cmd("C6", "Spindle On")
  end

  def spindle_off
    cmd("C7", "Spindle Off")
  end

  def set_cut_speed(xy: 3.0, z: 1.0)
    cmd("MS,#{xy},#{z}")
  end

  def cut(x: nil, y: nil, z: nil)
    raise ArgumentError, "You must provide an X if you provide y & z" if y && z && !x
    if x && y && z
      cmd("M3,#{x},#{y},#{z}")
    elsif x && y
      cmd("M2,#{x},#{y}")
    elsif x
      cmd("MX,#{x}")
    elsif y
      cmd("MY,#{y}")
    elsif z
      cmd("MZ,#{z}")
    end

  end

  def set_move_speed(xy: 3.0, z: 1.0)
    cmd("JS,#{xy},#{z}")
  end

  def move(x: nil, y: nil, z: nil)
    raise ArgumentError, "You must provide an X if you provide y & z" if y && z && !x
    if x && y && z
      cmd("J3,#{x},#{y},#{z}")
    elsif x && y
      cmd("J2,#{x},#{y}")
    elsif x
      cmd("JX,#{x}")
    elsif y
      cmd("JY,#{y}")
    elsif z
      cmd("JZ,#{z}")
    end

  end

  def set_spindle_speed(speed: 14000)
    cmd("TR, #{speed}", "Set Spindle RPM")
  end

  def pause(seconds: 1)
    "PAUSE #{seconds}"
  end

  def cmd(command, comment_msg = nil)
    sprintf("%-30s%s", command, comment(comment_msg))
  end

  def comment(msg)
    msg ? "'#{msg}" : ""
  end
  def new_line
    comment("")
  end
  def dash_line
    comment("------------------------------")
  end
end

#CA - Cut Arch
#CC – Cut Circle
#CG - Cut G-code Circle
#CP - Cut Circle from Center Point
#CR - Cut Rectangle
#FC - File Conversion
#FE - File Edit
#FG - File Load in Goto/Single-Step Mode
#FP - File Load PART File
#FS - File, Set the PARTS File Directory
#HA – Help About
#HB - Help: ShopBot website Technical Bulletins
#HC - Help: Command Reference
#HE - Help: Quick Reference Page (editing)
#HN - Help: Send a request for help to ShopBot Technical Support
#HQ - Help: Quick Reference Page
#HR - Help: Quick Reference Page
#HT - Help: Troubleshooting & Maintenance
#HU - Help: ShopBot User Guide
#HW - Help ShopBot Website
#J2 - Jog 2 Dimensions
#J3 - Jog 3 Dimensions
#J4 - Jog 4 Dimensions
#J5 - Jog 5 Dimensions
#JA - Jog A axis
#JB - Jog B axis
#JS - Jog Speed
#JX - Jog X-axis
#JY - Jog - Y axis
#JZ - Jog Z-axis
#JH - Jog Home
#M2 - Move 2 Dimensions
#M3 - Move 3 Dimensions
#M4 - Move 4 Dimensions
#M5 – Move 5 Dimensions
#MA - Move A axis
#MB - Move B axis
#MD - Move Distance Move by specifying Distance and Angle
#MH - Move Home
#MO - Motors Off
#MS - Move Speed Set
#MX - Move X axis
#MY - Move Y axis
#MZ - Move Z axis
#RA - Record Activate
#RI - Record Inactivate
#RP - Record Play all Commands in Storage
#RR - Record Replay of the Last Commands
#RS - Record Save Stored Commands to a File and Optionally Edit
#RZ - Record Zero the Memory
#SA - Set to Absolute Distances
#SF - Sets File and Move Limit Checking
#SI - Send Command Line(s)
#SK - Set to Keyboard Arrows to Move Tool
#SL - Set to Clear all Variables in Memory
#SM - Set to Move/Cut Mode
#SO - Set Output Switch
#SP - Set to Preview Mode
#SR - Set to Relative Distances
#ST - Set Location to Table Base Coordinates
#SW - Set Warning Duration
#TC - Tools Copy Machine
#TD - Tools Drill Press
#TF - Tools Forney Fluter
#TH - Tools Header Writer
#TI - Tools Indexer
#TS - Tools ShopBot Setup
#TT - Tools Typesetter
#TU -Tools Tabletop Surfacer
#UD – Utilities Diagnostic Display
#UI - Utilities Install Control Box Firmware
#UL – Utilities List Variables
#UN - Utilities Name of Editor Program
#UR – Reset software to Default Settings, Load a Custom Settings File, or Clear the System Log
#US – Save Current Settings to a Default Settings File
#UU - Utilities Calculator
#UV - Utilities Values and Settings Display
#UZ - Utilities Zero all Current Locations and Table Base Coordinates
#VA - Values for Axis Locations
#VB - Values for Tabbing Feature
#VC - Value for Cutter-related Parameters
#VD - Values for Display Settings
#VH - Values for Z-axis Height Controller
#VI - Values for Communications Port and Other Addresses
#VL - Values for Limits for Table
#VN - Value Input Switch Assignment
#VP - Values for Preview Screen
#VR - Values for Ramps
#VS - Values for Speeds
#VU - Values for Calibration Units
#Z2 - Zero 2D (X & Y) axes
#Z3 - Zero 3D (X, Y & Z) axes
#Z4 - Zero 4D (X, Y, Z, & A) axes
#Z5 - Zero 5D (X, Y, Z, A, and B) axes
#ZA - Zero A axis
#ZB - Zero B axis
#ZT - Zero Table Base Coordinates
#ZX - Zero X axis
#ZY - Zero Y axis
#ZZ - Zero Z axis