//
// Volcanoe
//

//
//  parameters
//
tube_dia = 5;
thickness = 2;
base_length = 40;
base_height = 5;
model_height = 30;
fuzz_factor = 0.20;

// base
module base() {
	cube([base_length, base_length, base_height], center = true);
}

module sides() {
	linear_extrude(h=model_height, convexity=10, twist=150, slices=30, scale=3) {
		square(base_length, center=true);
	}
}


// eruption tube
module eruption_tube() {
	translate([0,0,model_height/2 - base_height/2])
	difference() {	
		cylinder(r=tube_dia, h=model_height, center=true);
		cylinder(r=tube_dia - thickness, h=model_height + 1, center=true);
	}
}


// assembly
module main() {
	union() {
		base();
		eruption_tube();
		sides();
	}
}

main();