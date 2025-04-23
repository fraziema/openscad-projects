length = 75;
width = 65;
height = 25;

// minimum dimensions 70x60x50 mm, must leave space for battery box (50x60 mm) and cord; can make smaller height if you simplify circuit (less than one resistor per led, not pointing in height direction)
 
$fn = 5;
 
led = 5;
spacing = 4;
border = 8;
//thickness = 3;

nx = 7;
ny = 6;

wall = 1;		// thickness of box walls
cut = height-wall; // where to separate lid from box (where is seam)

lip = 3; // height of lip in units of wall

pin = 5.25; // diameter of pin (wire) to hold lid to box
np = 0; // number of pins per side

ep = 0.01; // fudge factor - if there is 'sprue, adjust
printspace = 15; // distance between lid and box

// make corners
points = [for (i=[0,1], j=[0:1],k=[0:1]) [length*i, width*j, height*k]];
	
module shell(w,p) { // make walls by making whole volume p=points, w=thickness
	hull(){
        for (q=p) { //outside wall
            translate(q) sphere(w);
        }
    }
}

module ext(h,w,t){ // remove volume that isnt walls h=height to extrude, w=thickness, t = wall-lip separation
	
		translate([0,0,t]) 
		linear_extrude(h) offset(r=-w) 
		projection() shell(wall,points);
}

module slice(w,c){ // w=wall (fudge factors), c = cut line
	translate([-w-1-ep,-w-1-ep,c]) cube([2*(length+ep),2*(width+ep),2*height]); } 
	
module pins(n,x,y,loc,dia,w) { //add locking pins; n = number, x = space to put in, loc = location (height of holes), dia = diameter of holes, w=wall thickness
	echo(n,x,y,loc,dia,w);
	if (n != 0) for (i = [1:n]){
		translate([i*x/n - x/(2*n),-w,loc]) 
			rotate([-90,0,0]) 
			cylinder(d=dia, h=3*w);	
		translate([i*x/n - x/(2*n),y-2*w,loc]) 
			rotate([-90,0,0]) 
			cylinder(d=dia, h=3*w);

	}
}	

module ledgrid(){
	translate(0.5*[length, width,0]) 
	translate([-(border+(nx/2 -1/2)*(led+spacing)),-(border+(ny/2 -1/2)*(led+spacing)),0])
	for (i=[0:nx-1],j=[0:ny-1]){
	translate([border+i*(led+spacing),border+j*(led+spacing),-height/2])
		cylinder(d=led,h=2+height);}
}

difference(){ //box
   	shell(wall,points);
	ext(height,wall,wall);
	slice(wall,cut);
	pins(np,length,width,cut-wall,pin,wall);
	
	// power cord - usb
	translate([6,6,-height/2]) cylinder(h=height,r=2);

}
translate([0,width + printspace,0]){  //lid
	difference(){
    	shell(wall,points);
		ext(height,wall,wall);
		slice(wall,height-cut); 
		// make box, but only keep lid
		
		ledgrid();
}
	
	difference(){ 
	// make lip of box by making and removing smaller boxes
		ext(height,wall,wall);
		slice(2*wall,lip*(height-cut));
		ext(height,2*wall,wall);
	
		//	pins(np,length,width,height-(cut-wall),pin,wall);

		ledgrid();

	}
}




