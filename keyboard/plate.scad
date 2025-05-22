// these are set in the module definitions, but
// they can be included when calling the module
UNIT = 19.05;
SWITCH_SIZE = 14;

MX_TH = 1.5;	//	expected plate thickness (use large box below for 3d print
				//	and larger thickness defined below )
MX_LW = 15.6;   //	size of largest dimension of switch where it 
				//	contacts the plate

width = 4;		// dimensions in number of switches
length= 5;

thickness = 5;	// this is the total, including expected plate (see above)
border = 7;		// border in millimeters

// here we should use python to generate points from KLE info / cap sizes
points = [ for (k=[0:width-1]) for (l = [0:length-1]) concat(l,k)];

// distances for each hole in millimeters from origin
switch_loc = [ for (j = points) UNIT * j + 0.5 * UNIT * [1,1]];

// physical size of the plate print in millimeters
platesize = UNIT*[length,width] + border*[1,1];

// origin placed at low-left, in from the edge by 1/2 border
origin = -0.5*(platesize) + 0.5*border*[1,1];

module plate_proj(size,coords,start,sw_dim,flag=0){    
	difference()
	{
		square(size,true);
		translate(start){		 // cutouts for switches
			for (i=coords)
				translate(i) 
					square(sw_dim,true);
		}
		
		// when implementing holes for stabs and fixation, put it here

	}	// end of holes in slab
		// mark the [1,1] key corner with a cylinder
	if (flag) translate( - 0.5*size )
		color("red") cylinder (5,2,2); 

}	

module plate(size,coords,start,small=14,big = 15.6,th=5,lip=1.5){
	linear_extrude(th - lip) plate_proj(size,coords,start,big);
	translate([0,0,th-lip]) 
		linear_extrude(lip) plate_proj(size,coords,start,small);
}
plate(platesize,switch_loc,origin,SWITCH_SIZE,MX_LW,thickness, MX_TH);


