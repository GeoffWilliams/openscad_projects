cup_size = 35;
cup_thickness = 2;
cups = 3;
arm_length = 30;
arm_rad = 10;
cap_rad = 20;
cap_length = 60;
cap_thickness = 2;
shaft_length = 80;
shaft_rad = 15;
shaft_cable_rad = 5;
magnet_size = 4;
base_rad=50;
base_height=5;
bearing_height=5;
bearing_rad=5;
section_height=40;
section_rad=30;

// cap (inc magnet)
module cap() {

	difference() {
		union() {
			cylinder(h=cap_length, r=cap_rad);
			translate([0,0,cap_length])
			sphere(cap_rad);
		}
		translate([0,0,-1])
		cylinder(h=cap_length, r= cap_rad - cap_thickness); 
	}
	// cube magnet
	difference() {
		cube(magnet_size + cap_thickness, center=true);
		cube(magnet_size, center=true);
	}
	
}

// shaft + hall sensor
module shaft() {
	translate([0,0,0])
	difference() {
		cylinder(h=shaft_length, r=shaft_rad, center=true);
		cylinder(h=shaft_length, r=shaft_cable_rad, center=true);
	}
}

//bearing



// cup
module cup() {
	difference() {
		sphere(cup_size);
		translate([cup_size,-0.5,0])
		cube((cup_size * 2) + 1, center=true);	
		translate([cup_thickness,0,0])
		sphere(cup_size - cup_thickness);
	}
	translate([0,0,-cup_size - arm_length + cup_thickness])
	cylinder(h=arm_length, r=arm_rad);

	// smooth the join of cup to arm
	translate([0,0,-cup_size])
	sphere(arm_rad);
}


// cups + top
module cups() {
	//translate([0,0,-cap_length + arm_rad])	
	//cap();

	cylinder(h=section_height, r=section_rad, center=true);
	angle = 360/cups;
	for (i = [0:cups - 1]) {
		rotate([90,0,-90 +(angle*i)])		
		translate([0,0,arm_length + (cap_rad * 2)])
		cup();
	 
	}
}

module bearing() {
	cylinder(h=section_height, r=section_rad);
	cylinder(h=section_height, r=section_rad - 3;
}

// base
module base() {
	translate([0,0,-shaft_length/2])
	cylinder(h=base_height, r=base_rad, center=true);
}


// assembly
module main() {
		
	translate([0,0,section_height])
	bearing();
	rotate([0,0,$t*360])
	%cups();
	shaft();

	base();
}

main();