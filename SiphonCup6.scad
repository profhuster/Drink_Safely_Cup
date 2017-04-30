/*
 * Siphon Drinking Mug
 * ProfHuster@gmail.com
 * 2017-04-07
 *
 * If you drink out of this left-handed, you are OK.
 * you drink right-handed ... it dribbles
 * v2 - make using different shapes
 * v3 - added handle using path-like tube and minkowski
 * v4 - 04.10 - better handle. No printing support needed
 **** First version printed and working was v4
 * v6 - improved drain on bottom to be less obvious
 */
include <angleTorus.scad>
$fn = 24;

/* Constants Defined
 */
textOn = true;
makeCup = true;
makeHandle = true;
showSiphon = false;
eps=0.1;
cupScale = 1;
cupDia = 80; // diameter of cup
cupHt = 90; // height of cup
//cupHt = 45; // height of cup
cupRnd = 3; // cup wall thickness = 2x3 = 6 mm
cupText1 = "Drink";
cupText2 = "Safely";
attrText1 = "CREATED BY";
attrText2 = "PROF HUSTER";

// The siphon is hidden except for the drain in the front outside of the cup
// and the siphon hole in the inside front bottom of the cup
siphonDia = 3; // diameter of siphon tube
siphonR = siphonDia/2;
tubeSep = 1; // separation between up & down siphon holes
siphonShowY = -10; 
siphonDelta = 1.5;

handleRad = 4;
handleR = 30;
handleW = 20;
handleH = 40;
handleZScale = 3;
handleFn = $fn/2; // resolution for handle

module bottom(od,rnd) {
  rotate([0,0,-90])
  difference(){
    if(true){
    hull()
      rotate_extrude(convexity = 10)
      translate([od/2-rnd, 0, 0])
      circle(r = rnd);
    }
    // make intaglio text that leaks!
    // Here is the text (intaglio is opposite of embossed)
    color([1,.5,1,.9])
    translate([cupDia/2-cupRnd,0,0])
        rotate([180,0,0])
        union(){
        translate([0,+2.5,-.9])
        linear_extrude(height = 4)
          text(attrText1, font="Liberation Sans:style=Bold",
            size = 3, halign="right", valign="center", spacing = 1 );
        translate([0,-2.5,-.9])
        linear_extrude(height = 4)
          text(attrText2, font="Liberation Sans:style=Bold",
            size = 3, halign="right", valign="center", spacing = 1 );
        }
    // hole to connect drain to text
    color([.5,1,1,.9])
    translate([0, 2*cupRnd,-cupRnd-eps+1])
        rotate([0,0,-90])
        cube([12,cupDia/2-cupRnd,4]);
  }
}

if(!makeCup)
    bottom(cupDia, cupRnd);

module wall(od, ht, rnd){
    rotate_extrude(convexity = 10)
    projection()
    hull(){
        translate([od/2-rnd,0,0])
          cylinder(r = rnd);
        translate([od/2-rnd,ht,0])
          cylinder(r = rnd);
    }
}

// Handle modules
module quarterTorus(radX, radZ, od){
    intersection(){
        rotate_extrude(convexity=10)
            translate([od/2-radX, 0])
            scale([radX/radX, radZ/radX])
              circle(radX);
polyhedron(points = [[0,0,-radZ],[0,0,radZ],[od/2,0,radZ],[od/2,0,-radZ],
                     [0,-od/2,-radZ],[0,-od/2,radZ],
                     [od/2,-od/2,radZ],[od/2,-od/2,-radZ]],
           faces=[[0,1,2,3],[7,6,5,4],[0,4,5,1],[2,6,7,3],[1,5,6,2],[0,3,7,4]]);
        }
}

module handle(){
    rotate([90,0,0])
      union(){
        translate([0,-handleR/2+handleRad,0])
          rotate([0,90,0])
          hull(){
            scale([handleZScale,1,1,])
              cylinder(r=handleRad,h=handleW);
            translate([0,-3*handleRad,0])
              cylinder(r=handleRad,1);
          }
        translate([handleW,0,0])
          quarterTorus(handleRad, handleZScale*handleRad, handleR);
          
        translate([handleW+handleR/2-handleRad,handleH,0])
          rotate([90,0,0])
          scale([1,handleZScale,1,])
          cylinder(r=handleRad,h=handleH);
          
        translate([handleW,handleH,0])
          mirror([0,1,0])
          quarterTorus(handleRad, handleZScale*handleRad, handleR);
          
        translate([0,handleH+handleR/2-handleRad,0])
          rotate([0,90,0])
          hull() {
            scale([handleZScale,1,1,])
              cylinder(r=handleRad,h=handleW);
            translate([0,-3*handleRad,0])
              cylinder(r=handleRad,1);
          }
      }
}

module siphonTube(){
  // Siphon tube
  color([1,0,0])
  translate([0,-cupDia/2+(siphonR+siphonDelta),0])
  union(){
    // drain tube
    translate([-siphonR-tubeSep/2,0,-cupRnd-eps+1.5])
      cylinder(h=cupHt-.5*cupRnd-1.5,r=siphonR);
    // upward tube
    translate([+siphonR+tubeSep/2,0,cupRnd])
      cylinder(h=cupHt-2.5*cupRnd,r=siphonR);
    // horizontal connection at top
    translate([-0,0,cupHt-1.5*cupRnd-.1])
      rotate([90,0,0])
      angleTorus(siphonR,siphonR,4*siphonR+tubeSep,180);
    // drain tube into interior of cup
    translate([+siphonR+tubeSep/2,2*cupRnd,cupRnd+siphonR])
      rotate([90,0,0])
      cylinder(h=1.8*cupRnd,r=siphonR);
  }
}

if(showSiphon){
    translate([0,siphonShowY,0])
      siphonTube();
}

if(makeCup){
scale(cupScale)
difference(){
  union(){
    color("LightGreen")
    bottom(cupDia, cupRnd);
    color("LightGreen")
    wall(cupDia, cupHt, cupRnd);
    if(makeHandle){
      color("LightBlue")
      translate([cupDia/2-2,0,handleR])
        handle();
    }
    if(textOn){
        translate([0,-cupDia/2+3,cupHt-30])
          color("Brown")
          rotate([90,0,0])
          linear_extrude(height = 4)
          text(cupText1, font="Liberation Sans:style=Bold",
            size = 7, halign="center", spacing = 1 );
        translate([0,-cupDia/2+3,cupHt-30-10])
          color("Brown")
          rotate([90,0,0])
          linear_extrude(height = 4)
          text(cupText2, font="Liberation Sans:style=Bold",
            size = 7, halign="center", spacing = 1 );
    }
  }
  siphonTube();
}
} // false
// EOF