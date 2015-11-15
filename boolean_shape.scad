intersection() {

	// cube with sphere cut out
	difference() {
		translate([-12.5,-12.5,-12.5])
		cube(25);
		sphere(15);
	}
	

	// large sphere to round the cube
	sphere(17.5);
}


// ball in centre of view
sphere(10);

// stand - the cut is larger then it
// neesd to be to avoid booleans on
// coincident surfaces
difference() {
	translate([0,0,-25])
	cylinder(r=10, h=12.5);
	translate([0,0,-25.5])
	cylinder(r=8, h=14);
}