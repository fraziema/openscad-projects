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
