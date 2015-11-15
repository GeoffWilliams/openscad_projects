spacer = 10;
cam_rad = 20;
cam_offset = 20;
cam_base_rad = 10;
cam_tip_rad = 4;
shaft_rad = 5;
shaft_cap_rad = 15;
cam_count = 8;
cam_width = 5;
frame_width = cam_base_rad * 2;
frame_depth = 4;
frame_height = 40;
frame_drop = 28;

module cam(cam_base_rad, cam_tip_rad, cam_width, cam_offset) {

	hull() {	
		// base
		cylinder(h=cam_width, r=cam_base_rad, center=true);
	
		// tip
		translate([cam_offset, 0, 0])	
		cylinder(h=cam_width, r=cam_tip_rad, center=true);
	}
}

function angle(i) = i % 2 == 0 ? 90 : -90;
function shaft_length() = (cam_count * (spacer + cam_width)) + (4 * spacer);

module shaft() {

	// main shaft
	cylinder(h=shaft_length(), r=shaft_rad);

	// caps
	translate([0,0,shaft_length()])
	cylinder(h=spacer, r=shaft_cap_rad);
	translate([0,0,-spacer])
	cylinder(h=spacer, r=shaft_cap_rad);

	// handle
	rotate([90,0,0])
	translate([0,-spacer/2,-2*spacer])
	cube([10,10,30],center=true);
}

module frame() {
	frame_length = shaft_length() - 2* spacer; 
	
	difference() {
		union() {

			// sides
			translate([frame_length/2 - frame_depth/2 , 0, frame_height/2])
			rotate([0,90,0]) {
				minkowski() {
					cube([frame_height, frame_width, frame_depth], center=true);
					cylinder(h=frame_depth, r=frame_width/4);
				}
			}
			translate([-frame_length/2 + frame_depth/2, 0, frame_height/2])

			rotate([0,90,0]) {
				minkowski() {
					cube([frame_height, frame_width, frame_depth], center=true);
					cylinder(h=frame_depth, r=frame_width/4);
				}
			}

			translate([0,0,-1])
			minkowski() {
				//	bottom
				cube([frame_length, frame_width, frame_depth], center=true);

				// make smooth
				sphere(h=frame_width,r=2, center=true);
			}
		}
		// shaft cutouts
		translate([0,0,frame_drop])
		rotate([0,90,0])
		cylinder(h=shaft_length() - spacer * 2, r=shaft_rad + 4,center=true);
	}
}

module main() {

	for (i = [0:cam_count - 1]) {
		translate([i*(spacer + cam_width),0,0])
		rotate([0, angle(i) ,0])
		cam(cam_base_rad, cam_tip_rad, cam_width, cam_offset);
	}

	translate([-3*spacer, 0, 0])
	rotate([0,90,0])
	shaft();

	translate([5*spacer,0,-frame_drop])
	frame();
}

union() {
	main();
}