$fn = $preview ? 25 : 100;
difference(){
    union(){
    linear_extrude(50)
    difference(){
        square([210,35]);
        polygon([[60,35],[220,35],[220,13],[82,13]]);
        polygon([[0,0],[0,19],[51,19],[69,0]]);
    

    }
    
    translate([0,35,6]) cube([17,7,5]);
    translate([33,35,6]) cube([27,7,5]);
    }

    translate([25,15,8.7]) rotate([-90,0,0])cylinder(d=6.75,h=50);
    
    translate([95,-5,34.375]) rotate([-90,0,0])cylinder(d=6.75,h=50);
    
    translate([195,-5,34.375]) rotate([-90,0,0])cylinder(d=6.75,h=50);
}
