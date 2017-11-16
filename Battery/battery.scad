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

// battery type
battery_type    = "AA" ; // [AA,AAA,C,generic]
// [generic]
body_radius     = 7 ;
body_height     = 48.4 ;
body_wall_width = 1.2 ;
pin_height      = 1.0 ;
wire_diameter   = 1.0 ;

module battery(Radius, Height, WallWidth, PinHeight, WireWidth, $fn=64)
{
  difference()
  {
    union()
    {
      cylinder(h=Height, r=Radius); // outer
      translate([0,0,Height-0.1])
      {
	cylinder(h=PinHeight+0.1, r=Radius/3) ; // pin on top
      }
    }
    translate(v=[0,0,WallWidth]) { cylinder(h=Height-2*WallWidth, r=Radius-WallWidth) ; }  // inner
    translate([0, Radius/2,-Radius]) { cylinder(h=Height+2*Radius, d=WireWidth) ; } // wire 1
    translate([0,-Radius/2,-Radius]) { cylinder(h=Height+2*Radius, d=WireWidth) ; } // wire 2
    translate([ Radius/2,0,-Radius]) { cylinder(h=Height/2+2*Radius, d=WireWidth) ; } // neg terminal wire 3
    translate([-Radius/2,0,-Radius]) { cylinder(h=Height/2+2*Radius, d=WireWidth) ; } // neg terminal wire 4

    hull() // cut-out
    {
      translate([Radius, Radius, Radius+2*WallWidth])
        rotate([90,0,0])
        cylinder(h=2*Radius, r=Radius) ;
      translate([Radius, Radius, Height-Radius-2*WallWidth])
        rotate([90,0,0])
        cylinder(h=2*Radius, r=Radius) ;
    }
  }
}

module batteryC()
{
  battery(13.1, 50, 1.5, 1, 1.2) ;
}

module batteryAA()
{
  battery(7, 48.4, 1.2, 1, 1.2) ;
}

module batteryAAA()
{
  battery(5.2, 43.5, 1, 1, 1.2) ;
}

module batteryType(battery_type, body_radius, body_height, body_wall_width, pin_height, wire_diameter)
{
  if      (battery_type == "AA" ) batteryAA () ;
  else if (battery_type == "AAA") batteryAAA() ;
  else if (battery_type == "C"  ) batteryC  () ;
  else
    battery(body_radius, body_height, body_wall_width, pin_height, wire_diameter) ;
}           

rotate(a = [0, -90, 0])
batteryType(battery_type, body_radius, body_height, body_wall_width, pin_height, wire_diameter) ;
