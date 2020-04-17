////////////////////////////////////////////////////////////////////////////////
// Ic Box
////////////////////////////////////////////////////////////////////////////////

// module
type = "Base" ; // [Base,Top]

// box widht
width = 98.0 ;
// box length
length = 120.0 ;

// wall width
wallWidth = 0.8 ;

// ic total width
icWidth = 10 ;
// ic total height
icHeight = 8.8 ;

// ic body width
icBodyWidth = 6 ;
// ic body Height
icBodyHeight = 4 ;

/* [Hidden] */

$fa = 4 ;
$fs = 0.1 ;

height = icHeight + wallWidth ;

echo(width=width) ;

rows = floor((width - wallWidth) / (icWidth + wallWidth)) ;
echo(rows=rows) ;

calWidth = rows * (icWidth + wallWidth) + wallWidth ;
echo(calWidth=calWidth) ;

////////////////////////////////////////////////////////////////////////////////

module PinPos()
{
  hMin = 4.4 + wallWidth ;
  hBody = icHeight - icBodyHeight + wallWidth ;
  h = hMin > hBody ? hMin : hBody ;
  //h = icHeight + wallWidth ;
  translate([0, 0, h/2]) cylinder(d = 4.8 + 4*wallWidth, h = h, center=true) ;
  //translate([0, 0, h/2]) cube([4.8 + 4*wallWidth, 4.8 + 4*wallWidth, h ], center=true) ;
  //translate([0, 0, h/2]) cube([2*icWidth, 4.8 + 4*wallWidth, h ], center=true) ;
  translate([0, 0, height/2 + 1]) cylinder(d = 3.8, h = height + 2, center=true) ;
}
module PinNeg()
{
  translate([0, 0, 2.2-0.01]) cylinder(d = 4.8, h = 4.4, center=true) ;
}
  
module Pins()
{
  ow = width/2  - (2.4 + 2*wallWidth)  ;
  ol = length/2 - (2.4 + 2*wallWidth) ;
    
  translate([-ow, -ol, 0]) children() ;
  translate([-ow, +ol, 0]) children() ;
  translate([+ow, -ol, 0]) children() ;
  translate([+ow, +ol, 0]) children() ;
}

////////////////////////////////////////////////////////////////////////////////

module Base()
{
  module Cut()
  {
    translate([0, 0, height/2 + wallWidth + icHeight - icBodyHeight]) cube([icWidth, length-2*wallWidth, height], center = true) ;

    w = (icWidth - icBodyWidth) / 2 ;
    o = (icBodyWidth+w) / 2 ;
    translate([-o, 0, height/2 + wallWidth]) cube([w, length-2*wallWidth, height], center=true) ;
    translate([+o, 0, height/2 + wallWidth]) cube([w, length-2*wallWidth, height], center=true) ;

    translate([0, 0, height/2 - icBodyHeight - wallWidth]) cube([icBodyWidth - 2*wallWidth, length-2*wallWidth, height], center=true) ;
  }

  module Cuts()
  {
    o0 = calWidth/2 - wallWidth - icWidth/2 ;
    for (o = [-o0 : icWidth + wallWidth : o0])
    {
      translate([o, 0, 0]) Cut() ;
    }
  }

  difference()
  {
    union()
    {
      difference()
      {
        translate([0, 0, height/2]) cube([width, length, height], center=true) ;

        Cuts() ;

        w = (width - calWidth)/2 - wallWidth ;
        o = width/2 - wallWidth - w/2 ;
        if (w > wallWidth)
        {
          translate([-o, 0, height/2 - wallWidth]) cube([w, length-2*wallWidth, height], center=true) ;
          translate([+o, 0, height/2 - wallWidth]) cube([w, length-2*wallWidth, height], center=true) ;
        }
      }
      Pins() PinPos() ;
    }
    Pins() PinNeg() ;
  }
}

////////////////////////////////////////////////////////////////////////////////

module Top()
{
  topHeight = 1.2 ;
  difference()
  {
    translate([0, 0, topHeight/2]) cube([width, length, topHeight], center=true) ;
    Pins() PinNeg() ;
  }
}

////////////////////////////////////////////////////////////////////////////////

if (type == "Base")
{
  rotate([0,0,90]) Base() ;
}
else if (type == "Top")
{
  rotate([0,0,90]) Top() ;
}
else
{
  assert(false, "unknown type") ;
}

////////////////////////////////////////////////////////////////////////////////
// EOF
////////////////////////////////////////////////////////////////////////////////
