module smiley() {
	linear_extrude(
		file="../Downloads/smily.dxf",
		twist=50,
		height=100,
		center=true);

}

// dxf_linear_extrude deprecated(?)
union() {

	scale([1,1,0.35])
	sphere(55);

	linear_extrude(
		height=100, 
		center=true,
		twist=150,
		slices=20
		) {

			square(40, center=true);
	}

	translate([0,0,60])
	rotate([0,90,0])
	rotate_extrude() {
		translate([15,0,0])
		circle(10);
	}

	for (i = [0:5]) {
		rotate([0,0,i*60])
		smiley();
	}


}
