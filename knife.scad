//
// knife
//

// variables
blade_height = 3;
handle_height = 5;
base_dia = 15;
tip_dia = 10;
base_tip_offset = 10;
handle_length = 70;
blade_length=55;
blade_offset=20;

module handle() {
	hull() {
		cylinder(h=handle_height, r=base_dia, center=true);
		translate([base_tip_offset,  handle_length,0])
		cylinder(h=handle_height, r=tip_dia, center=true);
	}
}

module blade() {
	translate([blade_length + blade_offset + base_dia ,handle_length/2,0])
	scale([1,3,1])
	difference() {
		cylinder(r=blade_length*2, h=blade_height, center=true);
		translate([blade_offset,0,0])
		cylinder(r=blade_length*2, h=blade_height + 1, center=true);

		translate([-blade_length,blade_length,0])
		cube(blade_length * 2.5, center=true);
	}
}

module main() {
	handle();
	blade();
}

main();