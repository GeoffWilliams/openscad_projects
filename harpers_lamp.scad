BASE_RAD = 16;
BASE_HEIGHT = 4;
CABLE_WIDTH = 5;
HOLE_RAD = 5;
CLIP_WIDTH = 7;
CLIP_HEIGHT = 20;
CLIP_DEPTH = 2.5;
SNAP_CLEARANCE = 6;
SNAP_OFFSET = CLIP_HEIGHT - SNAP_CLEARANCE;
SNAP_SIZE = 2;
SNAP_HEIGHT = 12;

//Draw a prism based on a
//right angled triangle
//l - length of prism
//w - width of triangle
//h - height of triangle
module prism(l, w, h) {
	translate([0, l, 0]) rotate( a= [90, 0, 0])
	linear_extrude(height = l) polygon(points = [
		[0, 0],
		[w, 0],
		[0, h]
	], paths=[[0,1,2,0]]);
}

module base() {
	lip = 6;
	difference() {
		cylinder(h=BASE_HEIGHT,r=BASE_RAD+lip, center=true);
		cylinder(h=BASE_HEIGHT+1, r=HOLE_RAD, center=true);
		translate([0, -CABLE_WIDTH/2, -(BASE_HEIGHT+1)/2])
		cube([BASE_RAD + lip + 1, CABLE_WIDTH, BASE_HEIGHT+1, ]);
	}
}

module clip() {

		rotate([0,0,180]) {
		cube([CLIP_WIDTH, CLIP_DEPTH, CLIP_HEIGHT]);
		translate([CLIP_WIDTH,0, 18])
		rotate([0,0,90])
		prism(CLIP_WIDTH, 4, SNAP_HEIGHT);
}
}

module main() {
	base();

	rotate([0,0,180]) 
	translate([CLIP_WIDTH/2, -(BASE_RAD - CLIP_DEPTH), -BASE_HEIGHT/2]) 
		clip(-1);
	
	

	rotate([0,0,0]) {
		translate([(CLIP_WIDTH/2), -(BASE_RAD - CLIP_DEPTH), -BASE_HEIGHT/2]) {
			clip();
		}
	}
}


main();
