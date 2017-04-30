/*
 * angleTorus
 * Draw a segment of a torus
 * ProfHuster
 * 2017-04-10
 *
 */
module angleTorus(radX, radZ, od, angle){
    // make a full torus and intersect it with a pie slice
    intersection(){
        // Make a torus of an ellipse (Use scale to make an ellipse)
        rotate_extrude(convexity=10)
            translate([od/2-radX, 0])
            scale([radX/radX, radZ/radX])
              circle(radX);
        // use list conprehension to make an arc
        dArc = 3; // three degree steps
        arcList = [for(th = [0:dArc:angle]) [od*cos(th),od*sin(th)]];
        points = concat([[0,0]], arcList);
        translate([0,0,-radZ])
          linear_extrude(height=2*radZ)
          polygon(points=points);
    }
}

if(false){
    $fn = 48;
    radX = 3;
    radZ = 6;
    OD = 40;
    angleTorus(radX, radZ, OD, 45);
}
// EOF