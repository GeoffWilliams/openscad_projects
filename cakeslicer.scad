// cake slicer
slice_size = 60;
depth = 25.4;
handle_length = 76.2;
handle_width = 25.4;
thickness = 3;

module outline() {
	// slice
	minkowski() {
		cube([slice_size, 
			slice_size, 
			depth],
			center = true);
		cylinder(r=thickness * 2, h=depth, center=true);
	}
	// handle
	translate([handle_length/2 + slice_size/2 - thickness,0,0]) {
		minkowski() {
			
			cube([handle_length, 
					handle_width, 
					depth],
					center = true);
			cylinder(r=thickness * 2, h=depth, center=true);
		}
	}
}


module main() {
	difference() {
		outline();
		scale([0.9, 0.86, 1.1]) {
			outline();
		}
	
		# hole in handle
		translate([handle_length + slice_size - (thickness * 2),0,0])
		cube([handle_length, 
				handle_width + (thickness * 2) + 1, 
				depth * 2 + 1],
				center = true);
	}
}

main();