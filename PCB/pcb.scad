////////////////////////////////////////////////////////////////////////////////
// pcb.scad
////////////////////////////////////////////////////////////////////////////////

// customizer

// PCB type (for the 'Generic' type set the values in the 'Generic PCB' section below)
type    = "NodeMcu2" ; // [28BYJ,ArduinoProMiniWithConnector,BuckConv_1V25_5V_3A,Esp01Breakout,Esp32C5DevKitChina,Esp32C5qszntec,Esp32C5Xiao,Ftdi,GpsWithAntenna,Lcd1602,LonganNano,My74595,MyPower,NodeMcu2,SdCard,Si4703,Ssd1306,Tja1050,TouchButton,UbloxNeo6Mblue,UbloxNeo6Mred,Uln2003,Ws2812,Generic]

/* [Add Screw to base (mm)] */

// Add screw to base
screwEnable = false ;
// Screw outer diameter
screwOuter = 5 ; // [2:0.1:10]
// Screw inner diameter
screwInner = 3 ; // [2:0.1:8]
// Screw height
screwHeight = 4 ; // [0:0.1:8]
// Screw offset from pcb edge
screwOffsetX = 1 ; // [0:0.1:10]
// Screw offset from center
screwOffsetY = 0 ; // [-15:0.1:15]

/* [Add Lid (mm)] */

// Add lid, only supported by a few modules
lidEnable = false ;
// top and bottom combined or next to each other
lidSplit = true ;

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

// Add clip
clipEnable = true ;
// Distance of the clip from the PCB edge
clipOffset = 7 ; // [0:0.1:30]
// Length of the clip
clipLength =  3 ; // [4:0.1:10]

// Finger hole present
fingerHoleEnable = true ; // [0:1:1]

// Lid height
lidHeight = 2 ; // [1:0.1:20]
//
lidOffset = 3 ; // [1:0.1:30]
//
lidLength = 2 ; // [1:0.1:6]

/* [Hidden] */

module PcbCustomizer(type, length, width, height, wallWidth, railHeight, railOffset,
                     clipEnable, clipOffset, clipLength, fingerHoleEnable,
                     screwEnable, screwOuter, screwInner, screwHeight, screwOffsetX, screwOffsetY,
                     lidEndable, lidSplit, lidHeight, lidOffset, lidLength)
{
  screw = screwEnable ? [ screwOuter, screwInner, screwHeight, screwOffsetX, screwOffsetY ] : undef ;
  lid = lidEnable ? [ lidSplit, lidHeight, lidOffset, lidLength ] : undef ;

  if      (type == "28BYJ"                      ) { Pcb28BYJ("pos", true) ;                       }
  else if (type == "ArduinoProMiniWithConnector") { PcbArduinoProMiniWithConnector(true, screw) ; }
  else if (type == "BuckConv_1V25_5V_3A"        ) { PcbBuckConv_1V25_5V_3A(true, screw) ;         }
  else if (type == "Esp01Breakout"              ) { PcbEsp01Breakout(true, screw) ;               }
  else if (type == "Esp32C5DevKitChina"         ) { PcbEsp32C5DevKitChina(true, screw, lid) ;     }
  else if (type == "Esp32C5qszntec"             ) { PcbEsp32C5qszntec(true, screw, lid) ;         }
  else if (type == "Esp32C5Xiao"                ) { PcbEsp32C5Xiao(true, screw, lid) ;            }
  else if (type == "Ftdi"                       ) { PcbFtdi(true, screw) ;                        }
  else if (type == "GpsWithAntenna"             ) { PcbGpsWithAntenna(true, screw) ;              }
  else if (type == "Lcd1602"                    ) { PcbLcd1602(true, mode="all") ;                }
  else if (type == "LonganNano"                 ) { PcbLonganNano(true, screw) ;                  }
  else if (type == "My74595"                    ) { PcbMy74595(true, screw) ;                     }
  else if (type == "MyPower"                    ) { PcbMyPower(true, screw) ;                     }
  else if (type == "NodeMcu2"                   ) { PcbNodeMcu2(true, screw) ;                    }
  else if (type == "SdCard"                     ) { PcbSdCard(true, screw, lid) ;                 }
  else if (type == "Si4703"                     ) { PcbSi4703(true, screw) ;                      }
  else if (type == "Ssd1306"                    ) { PcbSsd1306(true) ;                            }
  else if (type == "Tja1050"                    ) { PcbTja1050(true, screw) ;                     }
  else if (type == "TouchButton"                ) { PcbTouchButton("pos", true) ;                 }
  else if (type == "UbloxNeo6Mblue"             ) { PcbUbloxNeo6Mblue(true, screw) ;              }
  else if (type == "UbloxNeo6Mred"              ) { PcbUbloxNeo6Mred(true, screw) ;               }
  else if (type == "Uln2003"                    ) { PcbUln2003(true, screw) ;                     }
  else if (type == "Ws2812"                     ) { PcbWs2812(true) ;                             }
  else // Generic
  {
    clip  = clipEnable  ? [ clipOffset, clipLength ] : undef ;

    PcbHolder(length, width, height, wallWidth, railHeight, railOffset,
              clip=clip, fingerHoleEnable=fingerHoleEnable, baseEnable=true, screw=screw, lid=lid) ;
  }
}

PcbCustomizer(type, length, width, height, wallWidth, railHeight, railOffset,
              clipEnable, clipOffset, clipLength, fingerHoleEnable,
              screwEnable, screwOuter, screwInner, screwHeight, screwOffsetX, screwOffsetY,
              lidEnable, lidSplit, lidHeight, lidOffset, lidLength) ;

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
// cuts: array of (centerOffsetX, centerOffsetY, width, length, optionalOffsetH, optionaHeight) // offsetH == top of pcb, height == top of frame
// clip: array of (offset clip starts from end of holder, length of clip)
// baseEnable:   add a base plane
// screw:        add screw holes to the base: vector [ outer diameter, inner diameter, height, x-offset from pcb, optional y-offset ]
// lid:          add lid: vector [ lidSplit, lidHeight, lidOffset, lidLength ]

// two children supported: 1st adds to PCB, 2nd subtracs from PCB

module PcbClip(clipLength, wallWidth, clipRight)
{
  mirror([clipRight, 0, 0])
  rotate([90, 0, 0])
  linear_extrude(height=clipLength-wallWidth/2-0.1, center=true)
  polygon(points=[ [ 0, 0], [ wallWidth, 0], [ wallWidth, wallWidth], [ 0, wallWidth ], [ -wallWidth/2, wallWidth/2] ]) ;
}

////////////////////////////////////////////////////////////////////////////////

module PcbHolder(pcbLength, pcbWidth, pcbHeight, wallWidth, railHeight, railOffset,
                 pins=undef, cuts=undef, clip=undef, fingerHoleEnable=false,
                 baseEnable=false, screw=undef, lid=undef)
{
  $fa =  5 ;
  $fs =  0.4 ;

  frameLength = pcbLength + 2*wallWidth ;
  frameWidth  = pcbWidth  + 2*wallWidth ;
  frameHeight = railHeight + pcbHeight + wallWidth ;

  clip1 = clip ? frameLength/2 - clip[0] : 0 ;
  clip2 = clip ? clip1 - clip[1] : 0 ;

  lidSplit = lid ? lid[0] : undef ;
  lidHeight = lid ? max(lid[1], railHeight + pcbHeight + 2*wallWidth) : undef ;
  lidOffset = lid ? lid[2] : undef ;
  lidLength = lid ? lid[3] : undef ;

  lidD = 0.05 ;

  module trapez(d = 0)
  {
    height = min(lidHeight/2, frameHeight) ;
    rotate([0, -90, 0])
    linear_extrude(height=wallWidth+2*d, center=true)
    polygon(points=[[0,-lidLength/2-d],[0,lidLength/2+d],[height+d, lidLength/2+height/25+d],[height+d, -lidLength/2-height/25-d]]);
  }

  module negative()
  {
    if (cuts != undef)
    {
      for (cut = cuts)
      {
        offsetH = (cut[4] != undef) ? cut[4] : 0;
        height = (cut[5] != undef) ? cut[5] : (wallWidth - offsetH);
        translate([cut[1], cut[0], railHeight + pcbHeight + (height+0.1)/2 + offsetH])
          cube([cut[3], cut[2], height+0.1], center=true) ;
      }
    }
  }

  module bottom()
  {
    module screw(lr, d, screwOuter, screwOffsetX, screwOffsetY)
    {
      offset = pcbWidth/2 + wallWidth + screwOuter/2 + screwOffsetX ;

      translate([lr*offset, lr*screwOffsetY])
        circle(d=d) ;
    }

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
          if (fingerHoleEnable)
          {
            for (x = [-(pcbWidth+wallWidth)/2, (pcbWidth+wallWidth)/2])
              translate([x, 0, frameHeight/2])
                rotate([0, 90, 0])
                scale([4*wallWidth + 2*pcbHeight,10,1])
                cylinder(h = 2*wallWidth, d=1, center=true, $fn=45) ;
          }
        }

        if (clip != undef)
        {
          translate([+frameWidth/2-wallWidth, +clip1-clip[1]/2, frameHeight-wallWidth]) PcbClip(clip[1], wallWidth, 0) ;
          translate([-frameWidth/2+wallWidth, +clip1-clip[1]/2, frameHeight-wallWidth]) PcbClip(clip[1], wallWidth, 1) ;
          translate([+frameWidth/2-wallWidth, -clip1+clip[1]/2, frameHeight-wallWidth]) PcbClip(clip[1], wallWidth, 0) ;
          translate([-frameWidth/2+wallWidth, -clip1+clip[1]/2, frameHeight-wallWidth]) PcbClip(clip[1], wallWidth, 1) ;
        }

        translate([0, 0, railHeight/2])
        {
          difference()
          {
            cube([pcbWidth-2*railOffset            , pcbLength,   railHeight  ], center=true) ;
            cube([pcbWidth-2*railOffset-2*wallWidth, pcbLength+1, railHeight+1], center=true) ;
          }
        }

        if (pins != undef)
        {
          for (pin = pins)
          {
            translate([pin[1], pin[0], 0])
              cylinder(r = pin[2], h=railHeight + pcbHeight) ;
          }
        }

        children(0) ;
      }

      negative() ;
      children(1) ;

      if (clip != undef)
      {
        for (c = [-clip2, -clip1, clip1, clip2 ])
        {
          translate([+frameWidth/2-wallWidth/2, c, railHeight + (pcbHeight+wallWidth+1)/2]) cube([2*wallWidth, wallWidth/2, pcbHeight+wallWidth+1], center=true) ;
          translate([-frameWidth/2+wallWidth/2, c, railHeight + (pcbHeight+wallWidth+1)/2]) cube([2*wallWidth, wallWidth/2, pcbHeight+wallWidth+1], center=true) ;
        }
      }
    }

    if (baseEnable)
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
            width = frameWidth + (lidHeight ? 2*(wallWidth+lidD) : 0) ;
            if (useScrew)
            {
              hull()
              {
                square([width, frameLength], center=true) ;
                screw(-1, screwOuter, screwOuter, screwOffsetX, screwOffsetY) ;
                screw(+1, screwOuter, screwOuter, screwOffsetX, screwOffsetY) ;
              }
            }
            else
            {
              square([width, frameLength], center=true) ;
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
          if (lid)
          {
            offsetW = frameWidth/2+wallWidth/2 ;
            offsetL = frameLength/2-lidOffset-lidLength/2 ;
            translate([+offsetW, +offsetL, 0]) trapez();
            translate([+offsetW, -offsetL, 0]) trapez();
            translate([-offsetW, +offsetL, 0]) trapez();
            translate([-offsetW, -offsetL, 0]) trapez();
          }
        }

        negative() ;
        children(1) ;

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

  module top()
  {
    difference()
    {
      union()
      {
        translate([0, 0, lidHeight/2])
        cube([frameWidth + 2*wallWidth + 2*lidD, frameLength, lidHeight], center=true);

        children(0) ;
      }

      union()
      {
        translate([0, 0, lidHeight/2-wallWidth])
        cube([frameWidth + 2*lidD, frameLength-2*wallWidth , lidHeight], center=true);

        translate([0, 0, (pcbHeight + railHeight + wallWidth) / 2 - 0.5])
        cube([frameWidth + 2*lidD, frameLength + 4*wallWidth, pcbHeight + railHeight + wallWidth + 1], center=true) ;

        negative() ;

        if (lid)
        {
          offsetW = frameWidth/2+wallWidth/2+lidD/2 ;
          offsetL = frameLength/2-lidOffset-lidLength/2 ;
          translate([+offsetW, +offsetL, 0])  trapez(lidD);
          translate([+offsetW, -offsetL, 0])  trapez(lidD);
          translate([-offsetW, +offsetL, 0])  trapez(lidD);
          translate([-offsetW, -offsetL, 0])  trapez(lidD);
        }

        children(1) ;
      }
    }
  }

  translate([0, 0, wallWidth])
  bottom()
  {
    if ($children > 0) children(0) ;
    if ($children > 1) children(1) ;
  }

  if (lid)
  {
    if (lidSplit)
    {
      offsetX = frameWidth + wallWidth + 5 + (screw ? (screwOuter + screwOffsetX) : 0) ;
      translate([offsetX, 0, lidHeight])
      rotate([0, 180, 0])
      top()
      {
        if ($children > 0) children(0) ;
        if ($children > 1) children(1) ;
      }
    }
    else
    {
      top()
      {
        if ($children > 0) children(0) ;
        if ($children > 1) children(1) ;
      }
    }
  }
}

////////////////////////////////////////////////////////////////////////////////

module PcbNodeMcu2(baseEnable = false, screw = undef)
{
  pcbLength  = 49.2 ;
  pcbWidth   = 26.2 ;
  pcbHeight  =  2   ;
  wallWidth  =  0.8 ;
  railHeight =  1.6 ;
  railOffset =  3   ;

  clip = [ 10, 5 ] ;

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
    [ -pcbLength/2-wallWidth/2, 0, wallWidth+0.01, 12 ]
  ] ;

  PcbHolder(pcbLength, pcbWidth, pcbHeight, wallWidth, railHeight, railOffset,
            clip=clip, pins=pins, cuts=cuts, fingerHoleEnable=true, baseEnable=baseEnable, screw = screw, lid = lid) ;
}

////////////////////////////////////////////////////////////////////////////////

module PcbSsd1306(baseEnable = false)
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

  if (baseEnable)
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

module PcbTouchButton(mode = "pos", baseEnable = false)
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

    if (baseEnable)
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

module PcbMyPower(baseEnable = false, screw = undef)
{
  pcbLength  = 33.4 ;
  pcbWidth   = 19.7 ;
  pcbHeight  =  1.5 ;
  wallWidth  =  0.8 ;
  railHeight =  3.0 ;
  railOffset =  6.5 ;

  clip = [ 5, 5 ] ;

  pins =
    [
      [33.5/2-4, -19/2+5, 1.2],
      [-33.5/2+4, +19/2-5, 1.2]
    ] ;

  cuts =
    [
      [ pcbLength/2+wallWidth/2, 19/4, wallWidth+0.01, 19/2],
      [ 5, pcbWidth/2-railOffset-wallWidth/2, 10, wallWidth+0.01, -pcbHeight-railHeight ]
    ] ;

  difference()
  {
    PcbHolder(pcbLength, pcbWidth, pcbHeight, wallWidth, railHeight, railOffset,
              pins=pins,
              cuts=cuts,
              clip=clip,
              fingerHoleEnable=true,
              baseEnable=baseEnable,
              screw=screw,
              lid=lid) ;

    translate([2, 5, 3]) cube([4, 10, 4], center=true) ;
  }
}

////////////////////////////////////////////////////////////////////////////////

module PcbArduinoProMiniWithConnector(baseEnable = false, screw = undef)
{
  pcbLength  = 33.3 ;
  pcbWidth   = 18.5 ;
  pcbHeight  =  1.2 ;
  wallWidth  =  0.8 ;
  railHeight =  3.0 ;
  railOffset =  5.0 ;

  clip = [ 5, 4 ] ;

  cuts =
    [
      [ pcbLength/2+wallWidth/2, 0, wallWidth+0.01, 18, wallWidth ],
      [ +pcbLength/2-2, 0, 4, 10, -pcbHeight-railHeight ],
      [ -pcbLength/2+2, 0, 4, 10, -pcbHeight-railHeight ],
      [ 3-0.5, pcbWidth/2-railOffset-wallWidth/2, 6, wallWidth+0.01, -pcbHeight-railHeight ]
    ] ;

  PcbHolder(pcbLength, pcbWidth, pcbHeight, wallWidth, railHeight, railOffset,
            cuts=cuts,
            clip=clip,
            fingerHoleEnable=true,
            baseEnable=baseEnable,
            screw = screw) ;
}

////////////////////////////////////////////////////////////////////////////////

module PcbSi4703(baseEnable = false, screw = undef)
{
  pcbLength  = 22.8 ;
  pcbWidth   = 29.6 ;
  pcbHeight  =  1.9 ;
  wallWidth  =  0.8 ;
  railHeight =  3.0 ;
  railOffset =  5.0 ;

  clip = [ 4,5 ] ;

  cuts =
    [
      [ pcbLength/2+wallWidth/2, 8, 2*wallWidth, 12 ],
      [ 3.5, pcbWidth/2-railOffset-wallWidth/2, 6, 2*wallWidth, -pcbHeight-railHeight ]
    ] ;

  PcbHolder(pcbLength, pcbWidth, pcbHeight, wallWidth, railHeight, railOffset,
            cuts=cuts,
            clip=clip,
            baseEnable=baseEnable,
            screw = screw) ;
}

////////////////////////////////////////////////////////////////////////////////

module PcbWs2812(baseEnable = false)
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

  if (baseEnable)
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

module PcbLcd1602(baseEnable=false, mode="all")
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

    if (baseEnable)
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

module Pcb28BYJ(mode = "pos", baseEnable = false)
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

    if (baseEnable)
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

          Pcb28BYJ(mode="neg", baseEnable=baseEnable) ;
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

module PcbUln2003(baseEnable = false, screw = undef)
{
  pcbLength  = 32.5 ;
  pcbWidth   = 35.2 ;
  pcbHeight  =  1.8 ;
  wallWidth  =  0.8 ;
  railHeight =  3.0 ;
  railOffset =  5.0 ;

  clip = [ 4, 5 ] ;

  px = pcbLength/2 - 2.8 ;
  py = pcbWidth /2 - 2.8 ;
  pd = 1 ;
  pins=[
    [+px,+py,pd],
    [+px,-py,pd],
    [-px,+py,pd],
    [-px,-py,pd]
  ] ;

  PcbHolder(pcbLength, pcbWidth, pcbHeight, wallWidth, railHeight, railOffset,
            pins=pins, clip=clip, fingerHoleEnable=true, baseEnable=true, screw=screw) ;
}

////////////////////////////////////////////////////////////////////////////////

module PcbLonganNano(baseEnable = false, screw = undef)
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

  clip = [ 10, 5 ] ;

  cuts =
    [
      [ +pcbLength/2+wallWidth/2, 0, wallWidth+0.01, 11, -pcbHeight-railHeight ],
      [ -pcbLength/2, 0, wallWidth*8, 12, -pcbHeight-railHeight-2*wallWidth ],
    ] ;

  translate([+pcbWidth/2+0.01, 1.5, 0]) MiddlePin(+1) ;
  translate([-pcbWidth/2-0.01, 1.5, 0]) MiddlePin(-1) ;
  PcbHolder(pcbLength, pcbWidth, pcbHeight, wallWidth, railHeight, railOffset,
            clip=clip, cuts=cuts, baseEnable=baseEnable, screw = screw) ;
}

////////////////////////////////////////////////////////////////////////////////

module PcbMy74595(baseEnable = false, screw=undef)
{
  pcbLength  = 46.2 ;
  pcbWidth   = 24.8 ;
  pcbHeight  =  1.8 ;
  wallWidth  =  0.8 ;
  railHeight =  2.0 ;
  railOffset =  0.0 ;

  clip = [ 10, 5 ] ;

  cuts =
    [
      [ pcbLength/2, 0, wallWidth * 3, 21 ]
    ] ;

  PcbHolder(pcbLength, pcbWidth, pcbHeight, wallWidth, railHeight, railOffset,
            clip=clip, cuts=cuts, fingerHoleEnable=true, baseEnable=baseEnable, screw=screw) ;
}

////////////////////////////////////////////////////////////////////////////////

module PcbBuckConv_1V25_5V_3A(showBase=false, screw=undef)
{
  pcbLength  = 30.5 ;
  pcbWidth   = 20.5 ;
  pcbHeight  =  1.5 ;
  wallWidth  =  0.8 ;
  baseHeight =  2   ;
  baseOffset =  5   ;
  pins       =  [ ] ;
  cuts       =  [ ] ;
  clip       = [ 3, 5 ] ;
  PcbHolder(pcbLength, pcbWidth, pcbHeight, wallWidth, railHeight, railOffset,
            pins, cuts, clip, fingerHoleEnable=true, baseEnable=showBase, screw=screw) ;
}

////////////////////////////////////////////////////////////////////////////////

module PcbFtdi(baseEnable = false, screw = undef)
{
  pcbLength  = 36.5 ;
  pcbWidth   = 18.6 ;
  pcbHeight  =  1.8 ;
  wallWidth  =  0.8 ;
  railHeight =  2.0 ;
  railOffset =  3.6 ;

  clip = [ 5, 5 ] ;

  cuts =
    [
      [ pcbLength/2-2, 0, 4, pcbWidth-railOffset, -pcbHeight-railHeight ]
    ] ;

  PcbHolder(pcbLength, pcbWidth, pcbHeight, wallWidth, railHeight, railOffset,
            cuts=cuts, clip=clip, fingerHoleEnable=true, baseEnable=baseEnable, screw=screw) ;
}

////////////////////////////////////////////////////////////////////////////////

module PcbTja1050(baseEnable = false, screw=undef)
{
  pcbLength  = 22.5 ;
  pcbWidth   = 11.7 ;
  pcbHeight  =  1.8 ;
  wallWidth  =  0.8 ;
  railHeight =  2.0 ;
  railOffset =  3.0 ;

  clip = [ 3, 2.5 ] ;

  pins =
    [
      [ pcbLength/2 - 1.5, +pcbWidth/2 - 1.5, 0.6 ],
      [ pcbLength/2 - 1.5, -pcbWidth/2 + 1.5, 0.6 ]
    ] ;

  cuts =
    [
      [ pcbLength/2-2, 0, 4, pcbWidth-2*railOffset+0.01, -pcbHeight-railHeight ],
      [-pcbLength/2+2, 0, 4, pcbWidth-2*railOffset+0.01, -pcbHeight-railHeight ]
    ] ;

  PcbHolder(pcbLength, pcbWidth, pcbHeight, wallWidth, railHeight, railOffset,
            pins=pins, cuts=cuts, clip=clip, fingerHoleEnable=true, baseEnable=baseEnable, screw=screw) ;
}

////////////////////////////////////////////////////////////////////////////////

module PcbEsp01Breakout(baseEnable = false, screw=undef)
{
  pcbLength  = 19.2 ;
  pcbWidth   = 16.0 ;
  pcbHeight  =  1.8 ;
  wallWidth  =  0.8 ;
  railHeight =  2.0 ;
  railOffset =  3.0 ;

  clip = [ 2.5, 2 ] ;

  cuts =
    [
      [ pcbLength/2-2.5, 0, 5, pcbWidth-2*railOffset+0.1, -pcbHeight-railHeight ],
    ] ;

  PcbHolder(pcbLength, pcbWidth, pcbHeight, wallWidth, railHeight, railOffset,
            cuts=cuts, clip=clip, fingerHoleEnable=true, baseEnable=baseEnable, screw=screw) ;
}

////////////////////////////////////////////////////////////////////////////////

module PcbUbloxNeo6Mred(baseEnable = false, screw=undef)
{
  pcbLength  = 24.0 + 0.8 ;
  pcbWidth   = 36.2 + 0.8 ;
  pcbHeight  =  1.2 ;
  wallWidth  =  0.8 ;
  railHeight =  2.0 ;
  railOffset =  8.0 ;

  clip = [ 3, 3.5 ] ;
  pins =
    [
      [ +pcbLength/2 - 3.5, +pcbWidth/2 - 3.5, 1.1 ],
      [ -pcbLength/2 + 3.5, +pcbWidth/2 - 3.5, 1.1 ]
    ] ;

  PcbHolder(pcbLength, pcbWidth, pcbHeight, wallWidth, railHeight, railOffset,
            clip=clip, fingerHoleEnable=true, baseEnable=baseEnable, screw=screw) ;
}

////////////////////////////////////////////////////////////////////////////////
module PcbUbloxNeo6Mblue(baseEnable = false, screw=undef)
{
  pcbLength  = 26.6 + 0.8 ;
  pcbWidth   = 35.8 + 0.8 ;
  pcbHeight  =  1.2 ;
  wallWidth  =  0.8 ;
  railHeight =  2.0 ;
  railOffset =  8.0 ;

  clip = [ 3, 3.5 ] ;
  pins =
    [
      [ +pcbLength/2 - 3.5, +pcbWidth/2 - 3.5, 1.1 ],
      [ -pcbLength/2 + 3.5, +pcbWidth/2 - 3.5, 1.1 ]
    ] ;

  PcbHolder(pcbLength, pcbWidth, pcbHeight, wallWidth, railHeight, railOffset,
            clip=clip, fingerHoleEnable=true, baseEnable=baseEnable, screw=screw) ;
}

////////////////////////////////////////////////////////////////////////////////
module PcbEsp32C5DevKitChina(baseEnable = false, screw=undef, lid=undef)
{
  pcbLength  = 47.2 + 0.4 ;
  pcbWidth   = 25.5 + 0.4 ;
  pcbHeight  =  1.6 ;
  wallWidth  =  0.8 ;
  railHeight =  1.0 ;
  railOffset =  5.0 ;

  clip = [ 9, 6 ] ;

  cuts =
  [
    [ -pcbLength/2,   0, 5, 18.0, 0, 1.0 ],
    [ pcbLength/2,  7.1, 5,  9.0, 0, 3.3 ],
    [ pcbLength/2, -7.1, 5,  9.0, 0, 3.3 ],
  ] ;

  $fa =  5 ;
  $fs =  0.4 ;

  lid = lid ? [ lid[0], 7.0, 4.5, 4 ] : undef ;

  PcbHolder(pcbLength, pcbWidth, pcbHeight, wallWidth, railHeight, railOffset,
            cuts=cuts, clip=clip, fingerHoleEnable=true, baseEnable=baseEnable, screw=screw, lid=lid)
  {
    union()
    {}
    union()
    {
      if (lid)
      {
        translate([4.8, 47.2/2-12.8, lid[1]-wallWidth/2])  cylinder(r=1, h=2*wallWidth, center=true);
        translate([-4.8, 47.2/2-12.8, lid[1]-wallWidth/2]) cylinder(r=1, h=2*wallWidth, center=true);
        translate([-2, 47.2/2-22, lid[1]-wallWidth/2])     cylinder(r=1, h=2*wallWidth, center=true);
      }
    }
  }
}

////////////////////////////////////////////////////////////////////////////////
module PcbEsp32C5qszntec(baseEnable = false, screw=undef, lid=undef)
{
  pcbLength  = 53.7 + 0.4 ;
  pcbWidth   = 25.4 + 0.4 ;
  pcbHeight  =  1.6 ;
  wallWidth  =  0.8 ;
  railHeight =  1.0 ;
  railOffset =  5.0 ;

  clip = [ 9, 6 ] ;

  cuts =
  [
    // cuts: array of (centerOffsetX, centerOffsetY, width, length, optionalOffsetH, optionaHeight) // offsetH == top of pcb, height == top of frame

    [ -pcbLength/2, -pcbWidth/2+7.4, 3.0, 3.0, 1, 3.0 ],
    [ pcbLength/2,  7.1, 5,  9.0, 0, 3.3 ],
    [ pcbLength/2, -7.1, 5,  9.0, 0, 3.3 ],
  ] ;

  $fa =  5 ;
  $fs =  0.4 ;

  lid = lid ? [ lid[0], 8.0, 4.5, 4 ] : undef ;

  PcbHolder(pcbLength, pcbWidth, pcbHeight, wallWidth, railHeight, railOffset,
            cuts=cuts, clip=clip, fingerHoleEnable=true, baseEnable=baseEnable, screw=screw, lid=lid)
  {
    union()
    {}
    union()
    {
      if (lid)
      {
        translate([pcbWidth/2-6.6, pcbLength/2-12.5, lid[1]-wallWidth/2])  cylinder(r=1, h=2*wallWidth, center=true);
        translate([-pcbWidth/2+6.6, pcbLength/2-12.5, lid[1]-wallWidth/2]) cylinder(r=1, h=2*wallWidth, center=true);
        translate([pcbWidth/2-6.1, pcbLength/2-23.5, lid[1]-wallWidth/2])     cylinder(r=1, h=2*wallWidth, center=true);
      }
    }
  }
}

////////////////////////////////////////////////////////////////////////////////
module PcbEsp32C5Xiao(baseEnable = false, screw=undef, lid=undef)
{
  pcbLength  = 21.3 + 0.4 ;
  pcbWidth   = 17.8 + 0.4 ;
  pcbHeight  =  1.3 ;
  wallWidth  =  0.8 ;
  railHeight =  1.0 ;
  railOffset =  5.0 ;

  clip = [ 4.5, 3.5 ] ;

  cuts =
  [
    [ pcbLength/2, 0, 5, 9.0, 0, 3.3 ],
    [ -pcbLength/2, 0, 2, 3.2, 0, 2 ]
  ] ;

  lid = lid ? [ lid[0], 6.8, 2.0, 2.0 ] : undef ;

  PcbHolder(pcbLength, pcbWidth, pcbHeight, wallWidth, railHeight, railOffset,
            cuts=cuts, clip=clip, fingerHoleEnable=false, baseEnable=baseEnable, screw=screw, lid=lid) ;
}

////////////////////////////////////////////////////////////////////////////////
module PcbGpsWithAntenna(baseEnable = false, screw=undef)
{
  pcbLength  = 38.8 + 0.8 ;
  pcbWidth   = 25.1 + 0.8 ;
  pcbHeight  =  1.6 ;
  wallWidth  =  0.8 ;
  railHeight =  5.0 ;
  railOffset =  -0.15 ;

  clip = [ 1, 3.5 ] ;

  cuts =
  [
    [ -pcbLength/2,   0, 5, 12.6, -pcbHeight-railHeight ],
    [ pcbLength/2,   -2, 5,  9.0, -pcbHeight-2.8 ],
  ] ;

  PcbHolder(pcbLength, pcbWidth, pcbHeight, wallWidth, railHeight, railOffset,
            cuts=cuts, clip=clip, fingerHoleEnable=true, baseEnable=baseEnable, screw=screw) ;
}

////////////////////////////////////////////////////////////////////////////////
module PcbSdCard(baseEnable = false, screw=undef, lid=undef)
{
  pcbLength  = 18.1 + 0.6 ;
  pcbWidth   = 17.9 + 0.8 ;
  pcbHeight  =  1.6 ;
  wallWidth  =  0.8 ;
  railHeight =  2.0 ;
  railOffset =  3.0 ;

  clip = [ 4.7, 3.0 ] ;

  cuts =
  [
    [ (-pcbLength-wallWidth)/2, 0, wallWidth+0.1, pcbWidth-2, 0, 1 ],
    [ (pcbLength-3)/2, 0, 3, pcbWidth-2*railOffset+0.1, -pcbHeight-railHeight ]
  ] ;

  lid = lid ? [ lid[0], 6.5, 2.3, 2.0 ] : undef ;

  pins =
  [
    [ pcbLength/2 - 4.1, +pcbWidth/2 - 1.7, 0.8 ],
    [ pcbLength/2 - 4.1, -pcbWidth/2 + 1.7, 0.8 ],
  ] ;

  PcbHolder(pcbLength, pcbWidth, pcbHeight, wallWidth, railHeight, railOffset,
            cuts=cuts, pins=pins, clip=clip, fingerHoleEnable=false, baseEnable=baseEnable, screw=screw, lid=lid) ;
}

////////////////////////////////////////////////////////////////////////////////
// EOF
////////////////////////////////////////////////////////////////////////////////
