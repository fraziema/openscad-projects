$fn = $preview?20:60;

/*	makes a plate and case from array of locations of
	switches. switches are located on integer grid,
	with unit spacing	
 */


// spacing between keys based on keycaps and switches
// this is a global variable 

unit=19.05;
switchsize=14;

//switches snap to plate with thickness 1.5, double for strength
thickness = 3; 

wall = 4;
radius=4;

angle=0;

height=10+thickness*2; // min 12 to not have pins bottom out

// length and width in number of keys in a grid
// program calculates length and width separately 
// from key locations

width = 4;
length= 12;

border = 8;

ml=33 ; // microcontroller dimensions
mw=18 ;

// you shouldn't have to include stabilized keys in this list, but I did here
points = [
	for (k=[0:width-2]) for (l = [0:length-1]) concat(l,k),
	
	for (l=[0:4]) concat(l,width-1),


	for (l=[7:11]) concat(l,width-1)
	//[0.5,width],
	//[2.5,width] 
	];

//method: use python to build points vector from key spacings from KLE website

// these points are transposed and 1-indexed, converty to 0-index 
// points = [[1, 1.25], [1, 3.25], [1, 4.25], [1, 5.25], [1, 6.25], [1, 7.25], [1, 8.25], [1, 9.25], [1, 10.25], [1, 11.25], [1, 12.25], [1, 13.25], [1, 14.25], [1, 15.5], [2, 1.25], [2, 2.25], [2, 3.25], [2, 4.25], [2, 5.25], [2, 6.25], [2, 7.25], [2, 8.25], [2, 9.25], [2, 10.25], [2, 11.25], [2, 12.25], [2, 13.25], [2, 14.25], [2, 16.25]];

// which keys are stabilized keys (2u)
stabs = [[5.5,width-1]];

//which key is spacebar
spacebar = [];

holes=[];

//holes = [for (k=[1:width-1]) for (l = [1:length-1]) if((l+k)%2 == 1)  concat(l,k-((l%2)?0:0.5))   ]; //give space for microcontroller with ternary (?:)

//platesize from key array; if microcontroller is larger, make it contain it

//platesize= (max(points)+min(points)+[1,1]) * unit + border * [1,1];

platesize = unit*[length,width] + 0.5*unit*[1,1];

//plate with mounting holes
module plate(size,p,st,sp,h,b,t,ss,flag=0){    
	linear_extrude(t)
		difference()
		{
			square(size,true);
			//put holes in the slab
			translate(-0.5*(size) + 0.5*b*[1,1]) {

				for (i=st){ // cutouts for 2u stabilizers
					translate(unit*(i+0.5*[1,1])) {
						square(ss,true);
						for (ii = [-1,1]){
							translate([ii*11.9,0.22]) {
								square([6.65,12.3],true);
								translate([0,-0.6]) square([3,13.5],true);
								translate([0,0.9]) square([8.4,2.8],true);
							}
						}
						square([11.9*2,10.7],true);
					}
				}

				// cutouts for switches
				for (i=p){
					translate(unit*(i+0.5*[1,1])) 
						square(ss,true);
				}


			} // end of holes in slab
			  // mark the [1,1] key corner with a cylinder
			if (flag) translate( - 0.5*size )
				color("red") cylinder (5,2,2); 

		}	
}

module shell(p,rad, flag=0) {
	hull()
		for (q=p) translate(q) 
			color(flag?"red":"blue")   
				sphere(rad);

}

module usbcutout(loc){
	translate(loc) rotate([90,0,0])
	{
		linear_extrude(20) hull(){
			translate([3,0]) circle(d=3.5);
			translate([-3,0]) circle(d=3.5);
		} 

		linear_extrude(5) hull(){
			translate([4,0]) circle(d=7);
			translate([-4,0]) circle(d=7);
		}
	}
}

module case(size, p,h,ht,r,w,b,d){

	ep = 0.25;
	//	maxpoint = (max(p)-min(p)+[1,1]);

	//	size = unit*(concat(maxpoint,0))+b*[1,1,0];
	echo("case = ",size);

	//x = maxpoint[0]; 
	//y = maxpoint[1];
	x = size[0]+ep; 
	y = size[1]+ep;


	cx = 0.5*((0.5+x));
	cy = 0.5*((0.5+y));

	dx = cx - 0.8*b;
	dy = cy - 0.8*b;


	outcorners = [ [cx,cy,0],[-cx,cy,0],[cx,-cy,0],[-cx,-cy,0], [cx,cy,ht],[-cx,cy,ht],[cx,-cy,ht],[-cx,-cy,ht] ];

	incorners = [ [dx,dy,0],[-dx,dy,0],[dx,-dy,0],[-dx,-dy,0], [dx,dy,2*ht],[-dx,dy,2*ht],[dx,-dy,2*ht],[-dx,-dy,2*ht] ];


	echo("Out = ",outcorners);
	echo("In  = ",incorners);

	difference(){

		shell(outcorners,r);
		shell(incorners,1);

		// use plate module for hole size to accomodate plate
		translate([0,0,ht+w-2*d+ep])
			plate(size+ ep*[1,1],[],[],0,3*d,0);
		usbcutout([-unit*0,cy+4,2.5]);
	}
	difference(){
		for (i=h){
			translate(unit*i- 0.5*size + unit*0.5*[1,1]) 
				translate([0,0,-1]*r)    
				cylinder(h=100*ht,d=unit-14.3);
		}

		translate([0,0,ht+w+r+ep])
			plate(size+ ep*[1,1],[],[],[],[],0,d,0);

	}
}

module base(size,ht,ang){

	x = size[0]; 
	y = size[1];

	cc = cos(2*ang);
	cs = sin(2*ang);
	cx = 0.5*((x));
	cy = 0.5*((y));

	corners =  [ [cx,cy,0],[-cx,cy,0],[cx,-cy,0],[-cx,-cy,0], [cx,cy*cc,cy*cs],[-cx,cy*cc,cy*cs] ];

	shell(corners,1,1);
}

// MAKE THINGS
//adj=2; translate(max(length,width)*((unit+adj)*[0,1,0])+[0,0,radius]) 
//translate((0.25*width*unit)*[0,1,0]) 

	rotate([angle,0,0]) 
translate([0,radius+platesize[1]/2,radius]) 
	case(platesize,points,holes,height,radius, wall,border,thickness); 
	if (angle){
		translate([0,platesize[1]/2+2,1]) 
#	base(platesize, height,angle);
	}
translate([0,-platesize[1],0]) plate(platesize,points,stabs,spacebar,[],border,thickness,switchsize);



//1.00u = 0.7500in || 19.0500mm
//1.25u = 0.9375in || 23.8125mm
//1.50u = 1.1250in || 28.5750mm
//1.75u = 1.3125in || 33.3375mm
//2.00u = 1.5000in || 38.1000mm
