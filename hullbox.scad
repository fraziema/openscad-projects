length = 65;
width = 55;
height = 45;


wall = 2;		// thickness of box walls
cut = height-wall; // where to separate lid from box (where is seam)

lip = 3; // height of lip in units of wall

pin = 5.25; // diameter of pin (wire) to hold lid to box
np = 0; // number of pins per side

ep = 0.01; // fudge factor - if there is 'sprue, adjust
printspace = 25; // distance between lid and box

//led grid info

nx = 5; ny = 4;  // grid size
diam = 5; 		// led diameter
lt = [ 2.5*diam , 2.5*diam ,0];
echo("sides equals",nx*2*diam+diam, ny*2*diam+diam);

$fn = 5;

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

module ledgrid(l,w,hgt,x,y,dia) {
	      
    for (i=[0:y-1], j=[0:x-1]) {
		translate([ j*2*dia , i*2*dia , -height/2])
		cylinder(h=hgt ,d=dia);
	}
}
	
difference(){ //box
   	shell(wall,points);
	ext(height,wall,wall);
	slice(wall,cut);
	
	pins(np,length,width,cut-wall,pin,wall);

}
translate([0,width + printspace,0])
{  //lid
	difference(){
    	shell(wall,points);
		ext(height,wall,wall);
		slice(wall,height-cut); 
		// make box, but only keep lid
		
		translate(lt) 
			ledgrid(length,width,height,nx,ny,diam);

}
	
	difference(){ 
	// make lip of box by making and removing smaller boxes
		ext(height,wall,wall);
		slice(2*wall,lip*(height-cut));
		ext(height,2*wall,wall);
		
		pins(np,length,width,height-(cut-wall),pin,wall);
		
	*	translate(lt) 
			ledgrid(length,width,height,nx,ny,diam);

	}
}




