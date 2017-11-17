////////////////////////////////////////////////////////////////////////////////
// https://en.wikipedia.org/wiki/AA_battery
// An AA cell measures 49.2–50.5 mm (1.94–1.99 in) in length, including the
// button terminal—and 13.5–14.5 mm (0.53–0.57 in) in diameter. The positive
// terminal button should be a minimum 1 mm high and a maximum 5.5 mm in
// diameter, the flat negative terminal should be a minimum diameter of 7 mm
//
// https://en.wikipedia.org/wiki/AAA_battery
// A triple-A battery is a single cell and measures 10.5 mm in diameter and
// 44.5 mm in length, including the positive terminal button, which is a
// minimum 0.8 mm high. The positive terminal has a maximum diameter of 3.8 mm;
// the flat negative terminal has a minimum diameter of 4.3 mm.
//
// A 'C' battery measures 50 millimetres (1.97 in) length and 26.2 millimetres
// (1.03 in) diameter.
////////////////////////////////////////////////////////////////////////////////

battery_type    = "AA" ; // [AA,AAA,C,Generic,Demo]

/* [Settings for Generic Battery (mm)] */
body_radius     =  7.0 ; // [4:0.1:20]
body_height     = 48.4 ; // [35:0.1:60]
body_wall_width =  1.2 ; // [0.7:0.1:5]
pin_height      =  1.0 ; // [0.7:0.1:2.5]
wire_diameter   =  1.0 ; // [0.7:0.1:2]

////////////////////////////////////////////////////////////////////////////////

/* [Hidden] */

// column index into Batt
cName   = 0 ; // name
cRadius = 1 ; // body radius
cHeight = 2 ; // body height
cWidth  = 3 ; // wall width
cPin    = 4 ; // pin height
cWire   = 5 ; // wire diameter
// row index into Batt
rC   = 0 ; // C battery
rAA  = 1 ; // AA battery
rAAA = 2 ; // AAA battery

Batt =
[ // name, radi, heig, wid, p, wire
  [ "C"  , 13.1, 50  , 1.5, 1, 1.2 ],
  [ "AA" ,  7  , 48.4, 1.2, 1, 1.2 ],
  [ "AAA",  5.2, 43.5, 1  , 1, 1.2 ]
] ;

////////////////////////////////////////////////////////////////////////////////

module battery(batt, $fn=64)
{
  difference()
  {
    union()
    {
      cylinder(h=batt[cHeight], r=batt[cRadius]); // outer
      translate([0,0,batt[cHeight]-0.1])
      {
	cylinder(h=batt[cPin]+0.1, r=batt[cRadius]/3) ; // pin on top
      }
    }
    translate([0, 0, batt[cWidth]]) { cylinder(h=batt[cHeight]-2*batt[cWidth], r=batt[cRadius]-batt[cWidth]) ; }  // inner
    translate([0, batt[cRadius]/2,-batt[cRadius]])  { cylinder(h=batt[cHeight]  +2*batt[cRadius], d=batt[cWire]) ; } // wire 1
    translate([0,-batt[cRadius]/2,-batt[cRadius]])  { cylinder(h=batt[cHeight]  +2*batt[cRadius], d=batt[cWire]) ; } // wire 2
    translate([ batt[cRadius]/2, 0,-batt[cRadius]]) { cylinder(h=batt[cHeight]/2+2*batt[cRadius], d=batt[cWire]) ; } // neg terminal wire 3
    translate([-batt[cRadius]/2, 0,-batt[cRadius]]) { cylinder(h=batt[cHeight]/2+2*batt[cRadius], d=batt[cWire]) ; } // neg terminal wire 4

    hull() // cut-out
    {
      translate([-batt[cRadius], batt[cRadius], batt[cRadius]+2*batt[cWidth]])
        rotate([90,0,0])
        cylinder(h=2*batt[cRadius], r=batt[cRadius]) ;
      translate([-batt[cRadius], batt[cRadius], batt[cHeight]-batt[cRadius]-2*batt[cWidth]])
        rotate([90,0,0])
        cylinder(h=2*batt[cRadius], r=batt[cRadius]) ;
    }
  }
}

////////////////////////////////////////////////////////////////////////////////

module batteryType(battery_type, body_radius, body_height, body_wall_width, pin_height, wire_diameter)
{
  idx = search([battery_type], Batt) ;
  if (idx != [[]])
  {
    battery(Batt[idx[0]]) ;
  }
  else if (battery_type == "Demo")
  {
    translate([0, -Batt[rC  ][cRadius] - Batt[rAA][cRadius] - 10, 0]) batteryType("C"  ) ;
    translate([0,                                              0, 0]) batteryType("AA" ) ;
    translate([0, +Batt[rAAA][cRadius] + Batt[rAA][cRadius] + 10, 0]) batteryType("AAA") ;
  }
  else
  {
    battery(["Generic", body_radius, body_height, body_wall_width, pin_height, wire_diameter]) ;
  }
}           

////////////////////////////////////////////////////////////////////////////////

rotate([0,0,180])
rotate([0, 90, 0])
  batteryType(battery_type, body_radius, body_height, body_wall_width, pin_height, wire_diameter) ;

////////////////////////////////////////////////////////////////////////////////
// EOF
////////////////////////////////////////////////////////////////////////////////
