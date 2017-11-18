////////////////////////////////////////////////////////////////////////////////
// Parthenon.scad
////////////////////////////////////////////////////////////////////////////////
//
// tample(pillarsFront, pillarsSide, width)
//
////////////////////////////////////////////////////////////////////////////////

pillarsFront =  8 ;
pillarsSide  = 17 ;
// width of the temple, the base is a bit wider.
width        = 60 ;
// what parts to create
type         = "complete"  ; // ["complete", "bottom", "top"]

/* [Hidden] */

phi =  (1 + sqrt(5)) / 2 ;
phiA = (-1 + sqrt(5)) / 2 ;
phiB = (3 - sqrt(5)) / 2 ;
$fn = 45 ;

///////////////////////////////////////////////////////////////////
// Basics
///////////////////////////////////////////////////////////////////

module box(x,y,z, dx,dy,dz)
{
  color("green")
    translate([dx, dy, dz])
      cube([x, y, z]) ;
}

module triangle(x,y,z, dx,dy,dz)
{
  translate([dx,dy,dz])
    scale([x,y,z])
      translate([0,1,0])
        rotate([90, 0, 0])
          scale([1/(2*cos(30)), 1/(1+sin(30)), 1])
            translate([cos(30), sin(30), 0])
              rotate([0, 0, -30])
                cylinder(1, 1, 1, $fn=3);
}

///////////////////////////////////////////////////////////////////
// Temple
///////////////////////////////////////////////////////////////////

module temple(nX, nY, width, type="complete")
{
  width = (width != undef) ? width : nX * 4 ;

  height = width / phiA * phiB ;
  pillarHeight = height * phiA ;
  roofHeight = height * phiB ;
  roofTopHeight = roofHeight * phiA ;
  roofMiddleHeight = roofHeight * phiB * phiA ;
  roofBottomHeight = roofHeight * phiB * phiB ;
  
  pillarDiameter = width / (nX + phi * (nX-1)) ;
  pillarDistance = width / (nX / phi + (nX-1)) ;
  pillarPedestalHeight = width / 64 ; // ???
  length = pillarDiameter * nY + pillarDistance * (nY-1) ;

  iOffset = 1.5*pillarDiameter + pillarDistance ;
  iWidth = width - 2*iOffset ;
  iLength = length - 2*iOffset ;
  
  iPillarHeight   = pillarHeight - pillarPedestalHeight ;
  iPillarDiameter = iWidth / ((nX-2) + phi * (nX-3)) ;
  iPillarDistance = iWidth / ((nX-2) / phi + (nX-3)) ;
  iPillarPedestalHeight = iWidth / 64 ; // ???
  
  ///////////////////////////////////////////////////////////////////
  // Pillars
  ///////////////////////////////////////////////////////////////////

  module pillar(pH, pD, pPH, x=0,y=0,z=0)
  // pH: pillar Height
  // pD: pillar pedestal
  // pPH: step
  {
    translate([x, y, z])
      union()
      {
        // box bottom
        translate([-pD/2, -pD/2, 0])
          scale([pD, pD, pPH])
            cube(1);
        // box top
        translate([-pD/2, -pD/2, pH - pPH])
          cube([pD, pD, pPH]);
        // pillar
        cylinder(pH, pD/2, pD/2*0.7);
        // torus top
        translate([0, 0, pH - pPH])
          rotate_extrude()
            translate([(pD-pPH)/2, 0, 0])
              circle(pPH/2);
      }
  }

  module outerPillar(x, y, z)
  {
    color("lightblue")
    pillar(pillarHeight, pillarDiameter, pillarPedestalHeight, x, y, z) ;
  }


  module innerPillar(x, y, z)
  {
    color("darkblue")
    pillar(iPillarHeight, iPillarDiameter, iPillarPedestalHeight, x, y, z) ;
  }

  module pillars()
  {
    pillarOffset = pillarDistance + pillarDiameter ;
    
    translate([pillarDiameter/2, pillarDiameter/2, 0])
    {
      for (x=[0:nX-1])
      {
        outerPillar(x*pillarOffset, 0                      ) ;
        outerPillar(x*pillarOffset, length - pillarDiameter) ;
      }
      for (y=[1:nY-2])
      {
        outerPillar(0                     , y*pillarOffset) ;
        outerPillar(width - pillarDiameter, y*pillarOffset) ;
      }
    }
    
    iPillarOffset = iPillarDistance + iPillarDiameter ;
    
    translate([iPillarDiameter/2 + iOffset, iPillarDiameter/2 + iOffset, pillarPedestalHeight])
    {
      for (x=[0:nX-2-1])
      {
        innerPillar(x*iPillarOffset, 0                      +iPillarPedestalHeight);
        innerPillar(x*iPillarOffset, iLength-iPillarDiameter-iPillarPedestalHeight) ;
      }
    }
  }
  
  ///////////////////////////////////////////////////////////////////
  // Floor
  ///////////////////////////////////////////////////////////////////

  module floor()
  {
      color("green")
      {
          for (i=[0:2])
              box(width+2*i*pillarPedestalHeight, length+2*i*pillarPedestalHeight, pillarPedestalHeight,
                  -i*pillarPedestalHeight, -i*pillarPedestalHeight, -i*pillarPedestalHeight) ;
      }
      color("orange")
      box(iWidth, iLength, pillarPedestalHeight,
          iOffset, iOffset, pillarPedestalHeight) ;
  }
  
  ///////////////////////////////////////////////////////////////////
  // Roof
  ///////////////////////////////////////////////////////////////////

  module roof()
  {
    
    color("lightblue")
    box(width, length, roofBottomHeight, 0, 0, 0) ;
    
    difference()
    {
      color("lightblue")
      box(width, length, roofMiddleHeight, 0, 0, roofBottomHeight) ;
      
      segX  = 2*nX-1;
      segXA = width / (segX / phi + (segX-1)) ;
      segXB = width / (segX + phi * (segX-1)) ;
      color("blue")
      for(x = [0:segX-2])
        for(dy = [-pillarPedestalHeight, length-pillarPedestalHeight])
          box(segXA,
              2*pillarPedestalHeight,
              roofMiddleHeight,
              x*(segXA+segXB) + segXB,
              dy,
              roofBottomHeight);
      
      segY  = 2*nY-1;
      segYA = length / (segY / phi + (segY-1)) ;
      segYB = length / (segY + phi * (segY-1)) ;
      color("blue")
      for(y = [0:segY-2])
        for (dx = [-pillarPedestalHeight, width - pillarPedestalHeight])
        box(2*pillarPedestalHeight,
            segYA,
            roofMiddleHeight,
            dx,
            y*(segYA+segYB) + segYB,
            roofBottomHeight);
    }
    
    color("lightblue")
    box(width + 2*pillarPedestalHeight,
        length + 2*pillarPedestalHeight,
        pillarPedestalHeight,
        -pillarPedestalHeight,
        -pillarPedestalHeight,
        roofBottomHeight+roofMiddleHeight) ;
    difference()
    {
      d = (roofTopHeight - pillarPedestalHeight) / roofTopHeight ;
      
      color("lightblue")
      triangle(width + 2*pillarPedestalHeight,
               length + 2*pillarPedestalHeight,
               roofTopHeight - pillarPedestalHeight,
               -pillarPedestalHeight,
               -pillarPedestalHeight,
               roofBottomHeight+roofMiddleHeight+pillarPedestalHeight) ;
      
      color("blue")
      triangle(d * (width + 2*pillarPedestalHeight),
               2*pillarPedestalHeight,
               d * (roofTopHeight - pillarPedestalHeight),
               -pillarPedestalHeight + (1-d)*(width + 2*pillarPedestalHeight)/2,
               -2*pillarPedestalHeight,
               roofBottomHeight+roofMiddleHeight+pillarPedestalHeight) ;
      color("red")
      triangle(d * (width + 2*pillarPedestalHeight),
               2*pillarPedestalHeight,
               d * (roofTopHeight - pillarPedestalHeight),
               -pillarPedestalHeight + (1-d)*(width + 2*pillarPedestalHeight)/2,
               length,
               roofBottomHeight+roofMiddleHeight+pillarPedestalHeight) ;
    }
  }
  
  ///////////////////////////////////////////////////////////////////
  // Wall
  ///////////////////////////////////////////////////////////////////

  module wall()
  {
    // Y (long walls)
    color("blue")
    {
      wOffsetX = iOffset ;
      wOffsetY = 2.5*pillarDiameter + 2*pillarDistance ;
    
      for (dX = [wOffsetX, width - wOffsetX-iPillarDiameter])
        box(iPillarDiameter,
            length - 2*wOffsetY,
            pillarHeight,
            dX,
            wOffsetY,
            0) ;
    }
    
    // X (short walls)
    color("magenta")
    {
      wOffsetX = iOffset ;
      wOffsetY = 3*(pillarDiameter+pillarDistance) ;
      
      for (dY = [wOffsetY, length - wOffsetY-pillarDiameter])
        difference()
        {
          box(iWidth,
              pillarDiameter,
              pillarHeight,
              wOffsetX,
              dY,
              0) ;
          box(2*pillarDiameter+pillarDistance,
              2*pillarDiameter,
              pillarHeight-3*pillarPedestalHeight,
              width/2 - (2*pillarDiameter+pillarDistance)/2,
              dY-pillarDiameter/2,
              2*pillarPedestalHeight) ;
        }
    }
    
    // X inner wall
    {
      wOffsetX = iOffset ;
      wOffsetY = (length-6*(pillarDiameter+pillarDistance))*phiA +
                  3*(pillarDiameter+pillarDistance) ;
      
      box(iWidth,
          pillarDiameter,
          pillarHeight,
          wOffsetX,
          wOffsetY,
          0);
    }
  }

  ///////////////////////////////////////////////////////////////////
  // temple()
  ///////////////////////////////////////////////////////////////////

  if ((type == "complete") || (type == "bottom"))
  {
    translate([0, 0, pillarPedestalHeight])
      pillars() ;
    translate([0, 0, 0])
      floor() ;
    translate([0,0,pillarPedestalHeight])
      wall() ;
  }
  if ((type == "complete") || (type == "top"))
  {
      translate([0, 0, pillarHeight + pillarPedestalHeight])
      roof() ;
  }
}

///////////////////////////////////////////////////////////////////
// Parthenon
///////////////////////////////////////////////////////////////////

module parthenon()
{
  temple(8, 17, 80) ;
}

///////////////////////////////////////////////////////////////////
// main
///////////////////////////////////////////////////////////////////

{
  temple(pillarsFront, pillarsSide, width, type) ;
}

///////////////////////////////////////////////////////////////////
// EOF
///////////////////////////////////////////////////////////////////
