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
