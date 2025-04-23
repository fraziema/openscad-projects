$fn = ($preview ?  7:60 );


size=32;
th=3.0;

md = 5.0;
mt = 1.5;




mag_th = mt + 0.5;
mag_dia = md + 1;

difference(){
cube([size*1.02,size*1.02,th+0.02],center=true); 
translate([0,0,(th/2)-mag_th]) cylinder(h=10, d=mag_dia);   
}