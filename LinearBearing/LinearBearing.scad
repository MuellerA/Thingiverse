////////////////////////////////////////////////////////////////////////////////
// Linear Bearing
////////////////////////////////////////////////////////////////////////////////

// box
type = "SCS6UU" ; // [SCS6UU,SCS8UU,SCS10UU,SCS12UU,SCS16UU]

// stl to import
LMxUU = "" ;

/* [Hidden] */

BearingParam =
[
  //           T   h   E  [W]  L   F     G     B     C  K    S1  S2   L1    [use]   LM
  [ "SCS6UU" , 6,  9, 15, 30, 25, 18  , 15  , 20  , 15, 5   , 4, 3.4,  8, "LM6UU" , 12 ],
  [ "SCS8UU" , 6, 11, 17, 34, 30, 22  , 18  , 24  , 18, 5   , 4, 3.4,  8, "LM8UU" , 15 ],
  [ "SCS10UU", 8, 13, 20, 40, 35, 26  , 21  , 28  , 21, 6   , 5, 4.3, 12, "LM10UU", 19 ],
  [ "SCS12UU", 8, 15, 21, 42, 36, 28  , 24  , 30.5, 26, 5.75, 5, 4.3, 12, "LM12UU", 21 ],
  [ "SCS16UU", 9, 19, 25, 50, 44, 38.5, 32.5, 36  , 34, 7   , 5, 4.3, 12, "LM16UU", 28 ]
] ;



module Bearing(type)
{
  idx = search([type], BearingParam) ;
  param = (idx != [[]]) ? BearingParam[idx[0]] : BearingParam[0] ;
  
  $fa = 10   ;
  $fs =  0.4 ;

  T  = param[ 1] ;
  h  = param[ 2] ;
  E  = param[ 3] ;
  //W  = param[ 4] ;
  L  = param[ 5] ;
  F  = param[ 6] ;
  G  = param[ 7] ;
  B  = param[ 8] ;
  C  = param[ 9] ;
  K  = param[10] ;
  S1 = param[11] ;
  //S2 = param[12] ;
  L1 = param[13] ;
  // use = param[14] ;
  LM =  param[15] ;
  
  dLT = L1 - T ;
  dKS2 = (K - S1/2) / 2 ;
  dFG = F - G ;
  dLC2 = (L - C) / 2 ;
  
  module screw()
  {
    rotate([90,0,0]) cylinder(d = S1, h = L, center=true) ;    
  }
  
  difference()
  {
    linear_extrude(height = L) {
      polygon(points=[
          [E-K-S1-1, -h+1],
          [E-K-S1, -h],
          [E    , -h],
          [E    , -h+T],
          [E-dKS2, -h+T+dLT],
          [E-dKS2, -h+G],
          [E-K-S1/2-dKS2, -h+G],
          [E-K-S1/2-dKS2-dFG, -h+F],
      
          [-E+K+S1/2+dKS2+dFG, -h+F],
          [-E+K+S1/2+dKS2, -h+G],
          [-E+dKS2, -h+G],
          [-E+dKS2, -h+T+dLT],
          [-E    , -h+T],
          [-E   , -h],
          [-E+K+S1, -h],
          [-E+K+S1+1, -h+1]          
        ]) ;
    }

    cylinder(d = LM, h = 4*L, center=true) ;
    translate([ B/2, 0, dLC2]) screw() ;
    translate([ B/2, 0, L-dLC2]) screw() ;
    translate([-B/2, 0, dLC2]) screw() ;
    translate([-B/2, 0, L-dLC2]) screw() ;
  }
}

if (LMxUU != "")
{
  import(LMxUU) ;
}

Bearing(type) ;

////////////////////////////////////////////////////////////////////////////////
// EOF
////////////////////////////////////////////////////////////////////////////////
