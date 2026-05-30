////////////////////////////////////////////////////////////////////////////////
// Tisch Kabel Klammer
////////////////////////////////////////////////////////////////////////////////

// wall thickness
wall = 4 ;

// table top height
height1 = 10.5 ;

// cable height
height2 = 15 ;

height = 3 * wall + height1 + height2 ;

// table top width
width1 = 25 ;

// cable width
width2 = 40 ;

width = 2 * width1 + width2 ;

depth1 = 20 ;
depth = depth1 + wall;

r = min(height2/2, width2/2) ;
rO = r+wall ;

////////////////////////////////////////////////////////////////////////////////

module outer()
{
  module cut()
  {
    cube([width1, depth + 2*wall, height2+2*wall - r]) ;
    cube([width1 - r, depth + 2*wall, height2+2*wall]) ;
    translate([width1 - r, depth/2+wall, height2+2*wall-r]) rotate([90, 0, 0]) cylinder(r = r, h = depth+2*wall, center=true, $fn=40) ;
  }

  difference()
    {
      translate([-width/2, 0, height2+wall - r]) cube([width, depth, height1+2*wall + r]) ;

      translate([-width/2-wall, wall, height2+2*wall]) cube([width+2*wall, depth+2*wall, height1]) ;

      translate([-width/2-wall, -wall, -wall]) cut() ;
      translate([width/2+wall, -wall, -wall]) mirror([1,0,0]) cut() ;

      translate([-width2/2, -wall, -wall]) cube([width2, depth+2*wall, height+2*wall]) ;
    }
}

module inner()
{
  module cut()
  {
    translate([0, depth/2, height/2+wall + r]) cube([width2, depth+2*wall, height], center=true) ;

    translate([width2/2-r, depth/2, r+wall]) rotate([90,0,0]) cylinder(r = r, h = depth+2*wall, center=true, $fn=40) ;
    translate([-width2/2+r, depth/2, r+wall]) rotate([90,0,0]) cylinder(r = r, h = depth+2*wall, center=true, $fn=40) ;

    translate([0, depth/2,(height2+wall)/2 + wall]) cube([width2-2*r, depth+2*wall, height2+wall], center=true) ;
  }

  difference()
    {
      union()
      {
        translate([0, depth/2, (height2+wall)/2 +rO/2]) cube([width2+2*wall, depth, height2+wall - rO], center=true) ;

        translate([width2/2-rO+wall, depth/2, rO]) rotate([90,0,0]) cylinder(r = rO, h = depth, center=true, $fn=60) ;
        translate([-width2/2+rO-wall, depth/2, rO]) rotate([90,0,0]) cylinder(r = rO, h = depth, center=true, $fn=60) ;

        translate([0, depth/2,(height2+wall)/2]) cube([width2+2*wall-2*rO, depth, height2+wall], center=true) ;
      }

      cut() ;
    }
}

rotate([90, 0, 0])
{
  outer() ;
  inner() ;
}
