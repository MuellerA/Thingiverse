
// Breite
b = 7 ; // [4:0.2:10]

// Länge
l = 16 ; // [10:0.2:40]

// Dicke
d = 3.8 ; // [2:0.2:5]

////////////////////////////////////////////////////////////////////////////////

difference()
{
  union()
  {
    translate([0, 2.5, b/2])  cube([10, 5, b], center=true) ;
    translate([0, -l/2, b/2])  cube([d, l, b], center=true) ;

    translate([d, -l, 0]) cylinder(r = d*1.5, h=b, $fn=30) ;
  }

  translate([d, -l/2, (b+1)/2]) cube([d, l-d, b+2], center=true) ;
  translate([d, -l+d/2, (b+1)/2])  cylinder(d=d, h=b+2, center=true, $fn=30) ;
}

////////////////////////////////////////////////////////////////////////////////
// EOT
////////////////////////////////////////////////////////////////////////////////
