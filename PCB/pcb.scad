////////////////////////////////////////////////////////////////////////////////
// pcb.scad
////////////////////////////////////////////////////////////////////////////////

// customizer

// PCB type (for the 'Generic' type set the values in the 'Generic PCB' section below)
type    = "NodeMcu2" ; // [NodeMcu2,ArduinoProMini,Ftdi,LonganNano,Generic]

/* [Settings for Generic PCB (mm)] */

// Length of the PCB
length  = 35   ; // [10:0.1:60]
// Width of the PCB
width   = 20   ; // [10:0.1:60]
// Height of the PCB
height  =  1.5 ; // [0.6:0.1:2]

// Thickness of the walls
wallWidth = 0.8 ; // [0.4:0.1:2]

// Space between PCB and base
railHeight = 2.0 ; // [1:0.1:8]
// Space between rails and PCB edge
railOffset = 4.0 ; // [0:0.1:10]

// Distance of the clip from the PCB edge
clipOffset = 5 ; // [0:0.1:30]
// Length of the clip
clipLength =  5 ; // [4:0.1:10]

// Finger hole present
fingerHole = 1 ; // [0:1:1]

/* [Hidden] */

module Customizer(type, length, width, height, wallWidth, railHeight, railOffset, clipOffset, clipLength, fingerHole)
{
  if      (type == "NodeMcu2"      ) { PcbNodeMcu2(true) ;                    }
  else if (type == "ArduinoProMini") { PcbArduinoProMiniWithConnector(true) ; }
  else if (type == "Ftdi"          ) { PcbFtdi(true) ;                        }
  else if (type == "LonganNano"    ) { PcbLonganNano(true) ;                  }
  else // Generic
  {
    PcbHolder(length, width, height, wallWidth, railHeight, railOffset, [], [], clipOffset=clipOffset, clipLength=clipLength, fingerHole=fingerHole, showBase=true) ;
  }   
}   

Customizer(type, length, width, height, wallWidth, railHeight, railOffset, clipOffset, clipLength, fingerHole==1) ;

////////////////////////////////////////////////////////////////////////////////

// Length: Y
// Width : X
// Height: Z


// pcbLength: pcb length
// pcbWidth:  pcb width
// pcbHeight: pcb height

// wallWidth:  wall width
// railHeight: rail height where pcb will rest
// railOffset: gap between pcb side and rail

// pins: array of (offsetX, offsetY, radius) entries
// cuts: array of (centerOffsetX, centerOffsetY, width, length, optionalOffsetH)
// clipOffset: offset clip starts from end of holder
// clipLength: length of clip
// showBase:   add a base plane
// screw:      add screw holes to the base: vector [ outer diameter, inner diameter, height, x-offset from pcb, optional y-offset ]

module PcbClip(clipLength, wallWidth, clipRight)
{
  mirror([clipRight, 0, 0])
  rotate([90, 0, 0])
  linear_extrude(height=clipLength-wallWidth/2, center=true)
  polygon(points=[ [ 0, 0], [ wallWidth, 0], [ wallWidth, wallWidth], [ 0, wallWidth ], [ -wallWidth/2, wallWidth/2] ]) ;
}

////////////////////////////////////////////////////////////////////////////////

module PcbHolder(pcbLength, pcbWidth, pcbHeight, wallWidth, railHeight, railOffset, pins, cuts, clipOffset=10, clipLength=5, showBase=false, fingerHole=true, screw=undef)
{
  module screw(lr, d, screwOuter, screwOffsetX, screwOffsetY)
  {
    offset = pcbWidth/2 + wallWidth + screwOuter/2 + screwOffsetX ;

    translate([lr*offset, lr*screwOffsetY])
      circle(d=d) ;
  }

  module base(screwOuter)
  {
    hull()
    {
      square([pcbWidth+2*wallWidth, pcbLength+2*wallWidth], center=true) ;
      screw(-1, screwOuter) ;
      screw(+1, screwOuter) ;
    }
  }

  $fa =  5 ;
  $fs =  0.4 ;
  
  frameLength = pcbLength + 2*wallWidth ;
  frameWidth  = pcbWidth  + 2*wallWidth ;
  frameHeight = railHeight + pcbHeight + wallWidth ;

  clip1 = frameLength/2 - clipOffset ;
  clip2 = clip1 - clipLength ;

  difference()
  {
    union()
    {
      translate([0, 0, frameHeight/2])
        difference()
      {
        cube([frameWidth, frameLength, frameHeight  ], center=true) ;
        cube([pcbWidth  , pcbLength  , frameHeight+1], center=true) ;

        // finger hole
        if (fingerHole)
        {
          for (x = [-(pcbWidth+wallWidth)/2, (pcbWidth+wallWidth)/2])
            translate([x, 0, frameHeight/2])
              rotate([0, 90, 0])
              scale([4*wallWidth + 2*pcbHeight,10,1])
              cylinder(h = 2*wallWidth, d=1, center=true, $fn=45) ;
        }
      }

      translate([+frameWidth/2-wallWidth, +clip1-clipLength/2, frameHeight-wallWidth]) PcbClip(clipLength, wallWidth, 0) ;
      translate([-frameWidth/2+wallWidth, +clip1-clipLength/2, frameHeight-wallWidth]) PcbClip(clipLength, wallWidth, 1) ;
      translate([+frameWidth/2-wallWidth, -clip1+clipLength/2, frameHeight-wallWidth]) PcbClip(clipLength, wallWidth, 0) ;
      translate([-frameWidth/2+wallWidth, -clip1+clipLength/2, frameHeight-wallWidth]) PcbClip(clipLength, wallWidth, 1) ;

      translate([0, 0, railHeight/2])
      {
        difference()
        {
          cube([pcbWidth-2*railOffset            , pcbLength,   railHeight  ], center=true) ;
          cube([pcbWidth-2*railOffset-2*wallWidth, pcbLength+1, railHeight+1], center=true) ;
        }    
      }

      for (pin = pins)
      {
        translate([pin[1], pin[0], 0])
          cylinder(r = pin[2], h=frameHeight) ;
      }
    }

    for (clip = [-clip2, -clip1, clip1, clip2 ])
    {
      translate([0, clip, railHeight + (pcbHeight+wallWidth+1)/2])
      cube([frameWidth*2, wallWidth/2, pcbHeight+wallWidth+1], center=true) ;
    }

 #  for (cut = cuts)
    {
      offsetH = (cut[4] != undef) ? cut[4] : 0;
      translate([cut[1], cut[0], railHeight + (pcbHeight + wallWidth+1-offsetH)/2 + offsetH])
      cube([cut[3], cut[2], pcbHeight + wallWidth+1-offsetH], center=true) ;
    }
      
  }

  if (showBase)
  {
    useScrew = (screw != undef) && (4 <= len(screw)) && (len(screw) <= 5) ; 
    screwOuter   = useScrew ? screw[0] : 0 ;
    screwInner   = useScrew ? screw[1] : 0 ;
    screwHeight  = useScrew ? screw[2] : 0 ;
    screwOffsetX = useScrew ? screw[3] : 0 ;
    screwOffsetY = (useScrew && len(screw) == 5) ? screw[4] : 0 ;
    
    difference()
    {
      union()
      {
        translate([0, 0, -wallWidth])
        linear_extrude(height=wallWidth)
        {
          if (useScrew)
          {
         
            hull()
            {
              square([pcbWidth+2*wallWidth, pcbLength+2*wallWidth], center=true) ;
              screw(-1, screwOuter, screwOuter, screwOffsetX, screwOffsetY) ;
              screw(+1, screwOuter, screwOuter, screwOffsetX, screwOffsetY) ;
            }
          }
          else
          {
            square([frameWidth, frameLength], center=true) ;
          }
        }
        if (useScrew)
        {
          translate([0, 0, -wallWidth])
          linear_extrude(height=screwHeight)
          {
            screw(-1, screwOuter, screwOuter, screwOffsetX, screwOffsetY) ;
            screw(+1, screwOuter, screwOuter, screwOffsetX, screwOffsetY) ;
          }
        }
      }
      
      for (cut = cuts)
      {
        offsetH = (cut[4] != undef) ? cut[4] : 0;
        translate([cut[1], cut[0], railHeight + (pcbHeight + wallWidth+1-offsetH)/2 + offsetH])
        cube([cut[3], cut[2], pcbHeight + wallWidth+1-offsetH], center=true) ;
      }
      if (useScrew)
      {
        translate([0, 0, -2*wallWidth])
        linear_extrude(height=screwHeight+3*wallWidth)
        {
          screw(-1, screwInner, screwOuter, screwOffsetX, screwOffsetY) ;
          screw(+1, screwInner, screwOuter, screwOffsetX, screwOffsetY) ;
        }
      }
    }
  }
}

////////////////////////////////////////////////////////////////////////////////

module PcbNodeMcu2(showBase = false)
{
  pcbLength  = 49.2 ;
  pcbWidth   = 26.2 ;
  pcbHeight  =  2   ;
  wallWidth  =  0.8 ;
  railHeight =  1.6 ;
  railOffset =  3   ;

  pinRadius = 1 ;
  pinD = 2.7 ;
  pins =
  [
    [ +pcbLength/2 - pinD, +pcbWidth/2 - pinD, pinRadius ],
    [ +pcbLength/2 - pinD, -pcbWidth/2 + pinD, pinRadius ],
    [ -pcbLength/2 + pinD, +pcbWidth/2 - pinD, pinRadius ],
    [ -pcbLength/2 + pinD, -pcbWidth/2 + pinD, pinRadius ]
  ] ;
  
  cuts =
  [
    [ -pcbLength/2, 0, 3*wallWidth, 12 ]
  ] ;

  PcbHolder(pcbLength, pcbWidth, pcbHeight, wallWidth, railHeight, railOffset, pins, cuts, showBase=showBase) ;
}

////////////////////////////////////////////////////////////////////////////////

module PcbSsd1306(showBase = false)
{
  length = 28.3 ;
  width  = 27.8 ;
  height =  3   ;
  wallWidth = 0.8 ;

  dispLength = 15 ;
  dispWidth  = 26 ;
  dispHeight =  1 ;
  dispOffset =  5 ;

  // frame
  difference()
  {
    translate([0, 0, (height+wallWidth+dispHeight)/2])
    cube([width+wallWidth*2, length+wallWidth*2, height+wallWidth+dispHeight], center=true) ;

    translate([0, 0, height])
    cube([width, length, height*3], center=true) ;

    translate([0, +4+wallWidth/2, height + dispHeight]) cube([2*length, wallWidth, 2*height], center=true) ;
    translate([0, -4-wallWidth/2, height + dispHeight]) cube([2*length, wallWidth, 2*height], center=true) ;
  }

  // clips
  translate([+width/2, 0, height+dispHeight]) PcbClip(8, wallWidth, 0) ;
  translate([-width/2, 0, height+dispHeight]) PcbClip(8, wallWidth, 1) ;

  // display frame
  translate([0, (length-dispLength)/2 - dispOffset, 0])
  difference()
  {
    translate([0, 0, dispHeight/2])
    cube([dispWidth, dispLength, dispHeight], center=true) ;

    translate([0, 0, dispHeight])
    cube([dispWidth - 2*wallWidth, dispLength - 2*wallWidth, dispHeight*3], center=true) ;
  }

  if (showBase)
  {
    difference()
    {
      translate([0, 0, -wallWidth/2])
      cube([width+2*wallWidth, length+2*wallWidth, wallWidth], center=true) ;

      translate([0, (length-dispLength)/2 - dispOffset, 0])
      translate([0, 0, dispHeight])
      cube([dispWidth - 2*wallWidth, dispLength - 2*wallWidth, 10], center=true) ;
    }
  }
}

////////////////////////////////////////////////////////////////////////////////

module PcbTouchButton(mode = "pos", showBase = false)
{
  length     = 14.8 ; // w/o wall
  width      = 10.5 ; // w/o wall
  height     =  1.3 ; // no wall
  wallWidth  =  0.8 ;
  railHeight =  0.6 ;

  $fn=60;
  
  if (mode == "pos")
  {
    // frame
    difference()
    {
      translate([0, 0, (height+railHeight+wallWidth)/2])
      cube([width+2*wallWidth, length+2*wallWidth, height+railHeight+wallWidth], center=true) ;

      cube([width, length, 3*(height+railHeight+wallWidth)], center=true) ;
    }

    translate([0, +3, railHeight/2]) cube([width, wallWidth, railHeight], center=true) ;
    translate([0, -3, railHeight/2]) cube([width, wallWidth, railHeight], center=true) ;

    translate([+width/2, 0, height + railHeight]) PcbClip(4, wallWidth, 0) ;
    translate([-width/2, 0, height + railHeight]) PcbClip(4, wallWidth, 1) ;

    if (showBase)
    {
      translate([0, 0, -wallWidth/2])
      cube([width+2*wallWidth, length+2*wallWidth, wallWidth], center=true) ;
    }
  }
  else if (mode == "neg")
  {
    dy = (length-width)/2 ;
    difference()
    {
      translate([0, dy, -wallWidth]) cylinder(h=2*wallWidth, d=width, center=true) ;    
      translate([0, dy, -wallWidth]) cylinder(h=3*wallWidth, d=width - 2*wallWidth, center=true) ;
    }
  }
}

////////////////////////////////////////////////////////////////////////////////

module PcbMyPower(showBase = false)
{
  difference()
  {
    PcbHolder(33.4, 19.7, 1.5, 0.8, 3, 6.5,
      [[33.5/2-4, -19/2+5, 1.2], [-33.5/2+4, +19/2-5, 1.2]],
      [[33.5/2, 19/4, 4, 19/2]],
      clipOffset=5,
      showBase=showBase) ;

    translate([2, 5, 3])
    cube([4, 10, 4], center=true) ;
  }
}

////////////////////////////////////////////////////////////////////////////////

module PcbArduinoProMiniWithConnector(showBase = false)
{
  difference()
  {
    PcbHolder(33.3, 18.5, 1.2, 0.8, 3, 5,
      [],
      [[33.3/2, 0, 2, 18, 0.8]],
      clipOffset=4,
      showBase=showBase) ;

    translate([0, 33.3/2-2, 3])
    cube([10, 4, 4], center=true) ;

    translate([0, -33.3/2+2, 3])
    cube([10, 4, 4], center=true) ;

    translate([3, 3-0.5, 3])
    cube([4, 6, 4], center=true) ;
  }
}

////////////////////////////////////////////////////////////////////////////////

module PcbSi4703(showBase = false)
{
  difference()
  {
    PcbHolder(22.8, 29.6, 1.9, 0.8, 3, 5,
      [],
      [[22.1/2, 8, 2, 12]],
      clipOffset=4,
      fingerHole=false,
      showBase=showBase) ;

    translate([29.6/2-5, 3.5, 3])
    cube([2,6,4], center=true) ;
  }
  
}

////////////////////////////////////////////////////////////////////////////////

module PcbWs2812(showBase = false)
{
  length = 9.4 ;
  width  = 9.4 ;
  height = 1.5 ;
  wallWidth = 0.8 ;

  ledLength = 5.7 ;
  ledWidth  = 5.7 ;
  ledHeight = 1.5 ;

  difference()
  {
    translate([0, 0, (ledHeight + height + wallWidth)/2])
    cube([width + 2*wallWidth, length + 2*wallWidth, ledHeight + height + wallWidth], center = true) ;

    cube([width, length, 3*(ledHeight + height + wallWidth)], center=true) ;
  }

  translate([0, +(length/2-0.25), ledHeight/2]) cube([width, 0.5, ledHeight], center=true) ;
  translate([0, -(length/2-0.25), ledHeight/2]) cube([width, 0.5, ledHeight], center=true) ;

  translate([+width/2, 0, ledHeight + height]) PcbClip(3, wallWidth, 0) ;
  translate([-width/2, 0, ledHeight + height]) PcbClip(3, wallWidth, 1) ;

  if (showBase)
  {
    difference()
    {
      translate([0, 0, -wallWidth/2])
      cube([width+2*wallWidth, length+2*wallWidth, wallWidth], center=true) ;

      cube([ledWidth, ledLength, 10], center=true) ;
    }
  }
}

////////////////////////////////////////////////////////////////////////////////

module PcbLcd1602(showBase=false, mode="all")
{
  // hole for screw
  lcdHH  =  6.0 ; // height
  lcdHO  =  5.0 ; // outer dia
  lcdHI  =  3.0 ; // inner dia
  lcdHDX = 75.0 ; // delta x
  lcdHDY = 31.0 ; // delta y

  lcdDIOY = 1.1 ; // offset lcd / lcdC
  
  lcdX = max(80.0, lcdHDX + lcdHO) ;
  lcdY = max(36.0, lcdHDY + lcdHO) ;

  lcdW = 0.8 ;
  
  lcdCX = 71.3 + 0.8 ;
  lcdCY = 24.4 + 0.2 ;
  
  $fn=20 ;

  module positive()
  {
    module screw()
    {
      translate([0, 0, lcdHH/2])
      difference()
      {
        cylinder(h = lcdHH, d = lcdHO, center=true) ;
        cylinder(h = 2*lcdHH, d = lcdHI, center=true) ;
      }
    }

    if (showBase)
    {
      translate([0, 0, -lcdW/2]) ;
      cube([lcdX, lcdY, lcdW], center=true) ;
    }
    
    translate([-lcdHDX/2, -lcdHDY/2, 0]) screw() ;
    translate([+lcdHDX/2, -lcdHDY/2, 0]) screw() ;
    translate([-lcdHDX/2, +lcdHDY/2, 0]) screw() ;
    translate([+lcdHDX/2, +lcdHDY/2, 0]) screw() ;

    // stabilization bars
    translate([0, -lcdDIOY/2 + lcdCY/2 + lcdW/2 + lcdW, lcdHH/2]) cube([lcdCX-3, lcdW, lcdHH], center=true) ;
    translate([0, -lcdDIOY/2 - lcdCY/2 - lcdW/2 - lcdW, lcdHH/2]) cube([lcdCX-3, lcdW, lcdHH], center=true) ;
  }

  module negative()
  {
    translate([0, -lcdDIOY/2, -lcdW/2])
    cube([lcdCX, lcdCY, 4*lcdW], center=true) ;
  }

  if (mode == "pos")
  {
    positive() ;
  }
  else if (mode == "neg")
  {
    negative() ;
  }
  else
  {
    difference()
    {
      positive() ;
      negative() ;
    }
  }
    
}

////////////////////////////////////////////////////////////////////////////////

module Pcb28BYJ(mode = "pos", showBase = false)
{
  $fn = 40 ;
  w = 0.8 ;
  d = 0.4 ;

  if (mode == "pos")
  {
    difference()
    {
      // ring outer
      translate([0, 0, w/2])
      cylinder(h = w, d = 28.8+2*w+2*d, center = true) ;

      // ring inner
      translate([0, 0, w])
      cylinder(h = 2*w, d = 28.8, center = true) ;

      // screw wing
      translate([0, 0, w/2])
      cube([35, 7.8, w], center=true) ;

      // cable box
      translate([0, -14, w/2])
      cube([15, 28, w], center=true) ;
    }
    
    if (showBase)
    {
      translate([0, 0, -w/2])
      {
        difference()
        {
          union()
          {
            // base
            cylinder(h = w, d = 28.8+2*w+2*d, center = true) ;

            // screw wing
            translate([-35/2, 0, 0]) cylinder(h = w, d = 7.8 , center=true) ;
            translate([ 35/2, 0, 0]) cylinder(h = w, d = 7.8, center=true) ;
            cube([35, 7.8, w], center=true) ;
          }

          Pcb28BYJ(mode="neg", showBase=showBase) ;
        }
      }
    }
  }
  else if (mode == "neg")
  {
    {
      // motor
      translate([0, 8, 0]) cylinder(h = 100, d = 9.9, center=true) ;

      // screw
      translate([-35/2, 0, 0]) cylinder(h = 100, d = 4.5, center=true) ;
      translate([ 35/2, 0, 0]) cylinder(h = 100, d = 4.5, center=true) ;
    }
  }
}

////////////////////////////////////////////////////////////////////////////////

module PcbUln2003(showBase = false)
{
  x = 32.5 ;
  y = 35.2 ;
  px = x/2-2.8 ;
  py = y/2-2.8 ;
  pd = 1 ;
  
  PcbHolder(x, y, 1.8, 0.8, 3, 5,
    [ [+px,+py,pd], [+px,-py,pd], [-px,+py,pd], [-px,-py,pd] ],
    [],
    clipOffset = 4, showBase=true) ;
}

////////////////////////////////////////////////////////////////////////////////

module PcbLonganNano(showBase = false)
{
  pcbLength  = 46.5 ;
  pcbWidth   = 20.5 ;
  pcbHeight  =  1.9 ;
  wallWidth  =  0.8 ;
  railHeight =  2.0 ;
  railOffset =  3.0 ;

  module MiddlePin(side)
  {
    difference()
    {
      scale([2, 2.4, 1])
      translate([0, 0, (railHeight+pcbHeight)/2]) cylinder(h = railHeight+pcbHeight, d=1, center=true, $fn=20) ;

      translate([side*10, 0, 0]) cube([20,20,20], center=true) ;
    }
  }

  // cuts: array of (centerOffsetX, centerOffsetY, width, length, optionalOffsetH)
  cuts =
    [
      [ +pcbLength/2, 0, wallWidth*3, 11, -railHeight ],
      [ -pcbLength/2, 0, wallWidth*8, 12, -railHeight-2*wallWidth ],
    ] ;
     

  translate([+pcbWidth/2, 1.5, 0]) MiddlePin(+1) ;
  translate([-pcbWidth/2, 1.5, 0]) MiddlePin(-1) ;
  PcbHolder(pcbLength, pcbWidth, pcbHeight, wallWidth, railHeight, railOffset, [], cuts, showBase=showBase, fingerHole=false) ;
}

////////////////////////////////////////////////////////////////////////////////

module PcbMy74595(showBase = false)
{
  pcbLength  = 46.2 ;
  pcbWidth   = 24.8 ;
  pcbHeight  =  1.8 ;
  wallWidth  =  0.8 ;
  railHeight =  2.0 ;
  railOffset =  0.0 ;

  cuts =
    [
      [ pcbLength/2, 0, wallWidth * 3, 21, pcbHeight-1 ]
    ] ;
  
  PcbHolder(pcbLength, pcbWidth, pcbHeight, wallWidth, railHeight, railOffset, [], cuts, showBase=showBase) ;
}

////////////////////////////////////////////////////////////////////////////////

module PcbFtdi(showBase = false)
{
  pcbLength  = 36.5 ;
  pcbWidth   = 18.6 ;
  pcbHeight  =  1.8 ;
  wallWidth  =  0.8 ;
  railHeight =  2.0 ;
  railOffset =  3.6 ;
  clipOffset =  5.0 ;

  cuts =
    [
      [ pcbLength/2-2, 0, 4, pcbWidth-railOffset, -railHeight ]
    ] ;
  
  PcbHolder(pcbLength, pcbWidth, pcbHeight, wallWidth, railHeight, railOffset, [], cuts, clipOffset=clipOffset, showBase=showBase) ;
}   

////////////////////////////////////////////////////////////////////////////////
// EOF
////////////////////////////////////////////////////////////////////////////////
