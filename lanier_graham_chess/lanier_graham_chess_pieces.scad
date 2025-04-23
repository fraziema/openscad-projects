$fn = ($preview ?  5:60 );

scale=15;
r=1;

md = 5.0;
mt = 1.5;

mag_th = mt + 0.25;
mag_dia = md + 1;

module shell(w,p) { // make walls by making whole volume p=points, w=thickness
    difference(){
        hull(){
            for (q=p) { //outside wall
            translate(q) sphere(w);
            }
        }
    translate([scale/2,scale/2,-r])
           cylinder(h=2*mag_th,d=mag_dia,center=true);
    }
}


pawnpoints = scale*[
    [0,0,0],
    [0,1,0],
    [1,1,0],
    [1,0,0],
    [0,0,1],
    [0,1,1],
    [1,1,1],
    [1,0,1]
];

rookpoints  = scale*[
    [0,0,0],
    [0,1,0],
    [1,1,0],
    [1,0,0],
    [0,0,2],
    [0,1,2],
    [1,1,2],
    [1,0,2]
];
bishoppoints = scale*[
    [0,0,0],
    [0,1,0],
    [1,1,0],
    [1,0,0],
    [0,0,1],
    [0,1,1],
    [1,1,2],
    [1,0,2]
];

knight1points = pawnpoints;
knight2points = scale*[
    [0,0,2],
    [0,0.5,2],
    [1,0.5,2],
    [1,0,2],
    [0,0,1],
    [0,0.5,1],
    [1,0.5,1],
    [1,0,1]
];

queen1points = scale*[
    [0,0,0],
    [0,1,0],
    [1,1,0],
    [1,0,0],
    [0,0,3],
    [0,1,3],
    [1,1,3],
    [1,0,3]
];
queen2points = scale*[
    [0.5,0,2.5],
    [0.5,1,2.5],
    [0,0,3],
    [0,1,3],
    [1,1,3],
    [1,0,3]
];

kingpoints = scale*[
    [0,0,0],
    [0,1,0],
    [1,1,0],
    [1,0,0],
    [0,0,3],
    [0,1,3],
    [1,1,3],
    [1,0,3],
    [0.5,0,3.5],
    [0.5,1,3.5],
];

for (p = [1:8]) translate([1.5*scale*p,0,0]) shell(r,pawnpoints);
    
for (p = [1:2]) translate([1.5*scale*p,1.5*scale,0]) shell(r,rookpoints);
    
for (p = [1:2]) translate([3*scale + 1.5*scale*p,1.5*scale,0]) shell(r,bishoppoints);
    
for (p = [1:2]) translate([6*scale + 1.5*scale*p,1.5*scale,0]) {
        shell(r,knight1points);
        shell(r,knight2points);
}

translate([10.5*scale,1.5*scale,0]) difference(){
        shell(r,queen1points);
        shell(r,queen2points);
}

translate([12*scale,1.5*scale,0]) shell(r,kingpoints);