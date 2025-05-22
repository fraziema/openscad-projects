use <plate.scad>;
use <usbcutout.scad>;
module case(size,wall=5,shelf=5,height=20,th=5){
	difference()
	{
		linear_extrude(height) 
			offset(wall) projection() plate(size);				
		translate([0,0,wall])  linear_extrude(1.5*height) 
			offset(-wall) 
			projection() plate(size);				
	translate([0,0,height-th]) linear_extrude(2*height)
			projection()  plate(size);				

	}

}

UNIT=19.05;
difference(){
case(UNIT*[4,3],2,1,12,2);
usbcutout([0,33,5]);
}
