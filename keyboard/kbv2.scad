$fn = $preview?20:60;

/*	makes a plate and case from array of locations of
	switches. switches are located on integer grid,
	with unit spacing	
 */
use <plate.scad>;
use <case.scad>;

// spacing between keys based on keycaps and switches
// this is a default in the module

UNIT=19.05;
//switchsize=14;
// bigsize = 15.6;

// switches snap to plate with thickness 1.5,
// which id default value. Default 5 for plate strength
// catch_lip = 1.5;
// thickness = 3; 

wall = 2;

angle=0;

// length and width in number of keys in a grid
// program calculates length and width separately 
// from key locations

width = 5;
length= 4;

border = 8;



points = [ for (k=[0:width-1]) for (l = [0:length-1]) concat(l,k)];
//method: use python to build points vector from key spacings from KLE website

// which keys are stabilized keys (2u)
// stabs = [[5.5,width-1]];

//which key is spacebar
//spacebar = [];

//holes=[];

switch_loc = [ for (j = points) UNIT * j + 0.5 * UNIT * [1,1]];

// physical size of the plate print in millimeters
platesize = UNIT*[length,width] + border*[1,1];

// origin placed at low-left, in from the edge by 1/2 border
origin = -0.5*(platesize) + 0.5*border*[1,1];


translate([0,0,20])
plate(platesize,switch_loc,origin);
case(platesize, wall,1,17,5);
//1.00u = 0.7500in || 19.0500mm
//1.25u = 0.9375in || 23.8125mm
//1.50u = 1.1250in || 28.5750mm
//1.75u = 1.3125in || 33.3375mm
//2.00u = 1.5000in || 38.1000mm
