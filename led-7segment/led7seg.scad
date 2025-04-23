$fn=$preview?15:60;

off = [0,0,0,0,0,0,0,0,0];
side = [0,1,1,1,0,1,1,1,0];
mid = [1,0,0,0,1,0,0,0,1];
dp = [1,0,0,0,0,0,0,0,0];

digits = [side,mid,mid,mid,side,dp,side,mid,mid,mid,side,off,side,mid,mid,mid,side];

t=1;    //thickness of wall

dia=5;	// diameter of leds
sep=7.5; 	// separation between leds

lean=0.2;

base=20+sep*(len(digits));
w=base + (len(off)/2)*lean*sep;            
h=20+sep*(len(off)-1);           


difference(){
	translate([-10,-10,0]) cube([w,h,t]);
	for(j=[0:-1+(base-20)/sep])
		for(i=[0:8])
			translate([sep*j+lean*sep*i,sep*i,0])
				cylinder(d=dia*digits[j][i],h=t+3,center=true);
	}
