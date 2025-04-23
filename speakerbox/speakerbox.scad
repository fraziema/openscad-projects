$fn = 5;

length = 80;
width = 56;
height = 42;
ep = 0.05;

open = 45; // grill size

wall=1; // wall thickness

speaker = 1 ; // compilation flag for speaker

wirerad  = 3; // hole for cabling

grill = 6; // number of holes per side
grad = 1; // radius of grill hole

mh = (74) / 2;  // center of speaker to mounting holes
mr = 2;     // radius of mount hole

points = [for (i=[0,1], j=[0:1],k=[0:1]) [length*i, width*j, height*k]];
 
difference(){ //box
    
    hull()
    {
        for (q=points) { //outside wall
            translate(q) sphere(2+2*wall);
        }
    }
    
    hull()
    {
        for (q=points) { //inside wall
            translate(q) sphere(2+wall);
        }
    }

    translate([-4*wall-ep,-4*wall-ep,7*height/8]) cube([length+8*wall+2*ep,width+8*wall+2*ep,2*height]); // cut off lid
    
    // speaker wire
    if (speaker == 1){  translate(wirerad*[1.5,1.5,-height/2/wirerad]) cylinder(r=wirerad,h=height); }

}

translate([0,width+15,0]){ // lid of box
   
    difference(){
        
        union(){
            
            difference(){
      
                hull() // outside wall
                {
                    for (q=points) { translate(q) sphere(2+2*wall); }
                }

                translate([-4*wall-ep,-4*wall-ep,height/8 ]) cube([length+8*wall+2*ep,width+8*wall+2*ep,2*height]);

            }  
   
            difference(){
   
                hull() //inside lip
                {
                    for (q=points) {  translate(q) sphere(2+wall);     }
                }

                hull() // hollow out lid
                {
                    for (q=points) { translate(q) sphere(2);  }
                }

                translate([-4*wall,-4*wall,2*height/8]) cube([length+8*wall,width+8*wall,2*height]);
                
            }  

            if (speaker == 1){ 
               	translate([length/2 + mh,width/2, 0]){
		 	difference(){
 				cylinder(r=mr,h=height/4);
				translate([0,0,0.17*height]) rotate([0,90,0]) cylinder(h = 3*mr,r=1, center=true);
			}
		}
                translate([length/2 - mh,width/2, -0])
		difference(){
 			cylinder(r=mr,h=height/4);
			translate([0,0,0.17*height]) rotate([0,90,0]) cylinder(h = 3*mr,r=1, center=true);
		}
	    }
          
            
        }
        
        if (speaker == 1){
            translate([length/2,width/2, -height/2]) 
            for (i = [-grill:grill],j = [-grill:grill]) { translate([i*open/(grill+1)/1.42,j*open/(grill+1)/1.42,0]) cylinder(r=grad, h=height); }
        }
        
   }
   
 }  
    

 
