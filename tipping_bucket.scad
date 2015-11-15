// nice smooth curves
$fn=100;
cover_lip_height = 3;
cover_height = 95;
cover_rad = 45;
cover_thickness = 2;
cover_key_size = 7;
cover_key_blend = 1;
base_lip_rad=2;
funnel_rad = 2;
funnel_height = 40;
funnel_offset = 1;
funnel_thickness=1;
spout_height=15;
spout_cut_angle=[0,45,0];
base_height = 5;
base_thickness = 2;
bucket_length = 72;
bucket_width = 30;
bucket_ratio = 4;
bucket_height = bucket_length/bucket_ratio;
bucket_thickness=1;
bottom_fin_ratio=0.3;
pivot_rad_inner = 2;
pivot_rad_outer = 3;
pivot_socket_width = 3;
pivot_pin_rad = 1.5;
pivot_pin_length=3;
frame_height=20;
frame_base_length=6;
frame_tip_length=frame_base_length * 0.25;
frame_width = 10;
drain_offset_ratio = 0.9;
guard_thickness = 2;
guard_height = 20;
drain_ratio = 0.5;
drain_rad = bucket_width/2 + 2 ;
guard_length = drain_rad * 2 * drain_ratio;
cable_duct_rad=2;
cable_duct_pos= 10;
cable_tidy_width=10;
cable_tidy_height=4;
reed_length = 14;
reed_width = 2;
reed_holder_thickness=2;
reed_holder_buildout=22;
reed_holder_recess=2;
magnet_height=22;
sensor_height=base_height + frame_height + bucket_height/2 + magnet_height;
animation_degrees=5;

// magnet size (cube)
magnet_size=4;
magnet_holder_size=magnet_size + 1;

//
// reed holder
//
module reed_holder() {	
	
	reed_holder_base_width = reed_width * 2;
	difference() {	
		hull() {			
			cube([reed_holder_thickness * 2, 
					reed_holder_buildout, 
					reed_holder_thickness],
					center=true);
			translate([	0, reed_holder_buildout/2 - reed_holder_base_width/2,0])
			cube([reed_holder_thickness * 3, 
					reed_holder_base_width, 
					reed_holder_thickness * 2 ],
					center=true);
		}
		translate([
			0, 
			-reed_holder_buildout/2  + reed_holder_recess,
			(-2)])	
	
		reed_switch();
	}	
}

//
// funnel
//
module funnel() {
	translate([0,0,cover_height-funnel_height - 1])
	union() {
		// main funnel
		difference() {
			// outer cone
			hull() {
				translate([0,0, funnel_height])
				cylinder(r=cover_rad,height=1,center=true);
				translate([funnel_offset, 0, 0])
				cylinder(r=funnel_rad,height=1,center=true);			
			}

			// inner cone (cut)
			translate([0,0,cover_thickness])
			hull() {
				translate([0,0, funnel_height])
				cylinder(r=cover_rad - funnel_thickness,height=1,center=true);
				translate([funnel_offset, 0, 0])
				cylinder(r=funnel_rad - funnel_thickness,height=1,center=true);
			
			}

			// hole
			translate([funnel_offset,0,0])
			cylinder(h=cover_height, r=funnel_rad,center=true);
		}
	
		// spout
		translate([funnel_offset, 0, -spout_height/2])
		difference() {
			cylinder(
				h=spout_height, 
				r=funnel_rad + funnel_thickness, 
				center=true);
			cylinder(
				h=spout_height + 1, 
				r=funnel_rad, 
				center=true);

			// cut the spout at an angle to use surface tension
			// of water to control the bucket where the initial
			// drips fall
			translate([funnel_rad*2, 0,-spout_height/2])
			rotate(spout_cut_angle)
			cube(funnel_rad * 4, center=true);
		}
	}
}

//
// cover
//
module cover() {
	// cover is not centered but base is so when they are 
	// differenced the cover will sink neatly into the base
	union() {

		// outer casing
		difference() {
			cylinder(h=cover_height, r= cover_rad);
			translate([0,0,-1])
			cylinder(h=cover_height + 2, r= cover_rad - cover_thickness);		

			// cable exit
			translate([0, cover_rad - 1,cable_duct_pos])
			rotate([0,90,0])
			cylinder(h=cover_thickness + 2, r=cable_duct_rad,center=true);
		}

		// key
		hull() {
			// keying block
			translate([
				0,
				-cover_rad + cover_key_size/2 + 1,
				cover_key_size/2])
			cube(cover_key_size,center=true);

			// blend
			translate([
				0,
				-cover_rad + cover_key_blend/2 + 1,
				cover_key_size * 2])
			cube([cover_key_size, cover_key_blend, cover_key_blend], 
				center=true);
		}

		// funnel
		funnel();

		// reed holder
		translate([
			0, 
			cover_rad - reed_holder_buildout/2 - cover_thickness,
			sensor_height - (reed_length/2 - 1)])	
		
		reed_holder();
		translate([
			0, 
			cover_rad - reed_holder_buildout/2 - cover_thickness,
			sensor_height + (reed_length/2 + 1)])			
		reed_holder();

		// cable tidy top
		translate([
			0, 
			cover_rad - cable_tidy_height/2 - 1, 
			sensor_height + reed_length])
		cable_tidy();


		// cable tidy bottom
		translate([
			0, 
			cover_rad - cable_tidy_height/2 - 1, 
			sensor_height/2])
		cable_tidy();
	}
}

//
// cable tidy
//
module cable_tidy() {
		difference() {
			cube([
				cable_tidy_width, 
				cable_tidy_height, 
				cable_tidy_height],center=true);
			cube([
				cable_tidy_width - cover_thickness, 
				cable_tidy_height - cover_thickness, 
				cable_tidy_height + cover_thickness],center=true);
		}
}
//
// frame
//
module bucket_clip() {
	hull() {
		translate([frame_width/2/2,0,0])
		cube([frame_width/2,frame_tip_length,frame_height]);	
		cube([frame_width,frame_base_length,1]);
	}

	// pin
	translate([frame_width/2,0,frame_height - pivot_rad_inner])
	rotate([90,90,0])
	cylinder(h=pivot_pin_length, r=pivot_pin_rad);
}

function animate_translate() = 
	sin(2*3.14*($t * 57.2957795)) * animation_degrees;

//
// bucket
//
module bucket() {
	// main bucket with animation support
	rotate([0,animate_translate(),0])
	union() {
		intersection() {
			difference() {
				union() {
					// pivot

					// position at bottom but make flush with base to 
					// avoid printing a ton of really hard to remove
					// support.  Have to take bucket thickness into 
					// account due to hull rounding on bucket
					translate([0,0,-bucket_height/2 + pivot_rad_outer - bucket_thickness/2])		
					bucket_pivot();

					// make the sides and bottom to cut from using smooth
					// hull
					hull() {
				 
						translate([0, 0, bucket_height/2])
						rotate([90,90,0])
						cylinder(r=bucket_thickness/2, h=bucket_width, center=true);
				
						translate([-bucket_length/2, 0, -bucket_height/2])
						rotate([90,90,0])
						cylinder(r=bucket_thickness/2, h=bucket_width, center=true);
				
						translate([bucket_length/2, 0, -bucket_height/2])
						rotate([90,90,0])
						cylinder(r=bucket_thickness/2, h=bucket_width, center=true);
			
					}		
				}	
				// cut out channel
				translate([0,0,bucket_thickness *2])
				cube([bucket_length + 2, bucket_width - bucket_thickness * 2, bucket_height + 1], center= true);
			}
		}

		// fin

		hull() {
			// needs to be slightly higher then bucket to account
			// for round corners and to fuse into the magnet holder
			translate([0,0,2])
			cube([bucket_thickness, bucket_width, bucket_height],center=true);
			translate([0,0,-bucket_height/2])
			cube([bucket_length * bottom_fin_ratio, bucket_width, 1],center=true);
		}

		// magnet holder
		translate([0,0,bucket_height/2 + magnet_height])
		magnet_holder();	
	}

}

//
// magnet 
//
module magnet() {
	// magnet itself (do not print - just for illustration
	cube(magnet_size, center=true);
}

//
// magnet holder
//
module magnet_holder() {
	difference() {
		hull() {
	
			// holder
			translate([
				0,
				bucket_width/2 + magnet_holder_size/2 - bucket_thickness - 0.1,
				0])
			cube(magnet_holder_size, center=true);

			translate([
				0,
				bucket_width/2,
				-magnet_height])

			cube([magnet_holder_size,magnet_holder_size/2,magnet_height],center=true);
		
		}
		// magnet
		translate([0,bucket_width/2 + magnet_size/2,0])
		magnet();
	}
}

//
// bucket pivot socket
//
module bucket_pivot() {
	rotate([90,90,0])
	difference() {
		// main cylinder cutting accross whole bucket
		cylinder(h=bucket_width + (pivot_socket_width * 2), r=pivot_rad_outer, center=true);

		// cut a hole through it
		cylinder(h=bucket_width + (pivot_socket_width * 2) + 2, r=pivot_rad_inner, center=true);	

		// cut the centre, leaving a socket at each end
		cylinder(h=bucket_width, r=pivot_rad_outer + 4, center=true);
	}

}

//
// base
//
module base() {
	union() {
		difference() {
			union() {
				// cut the cover into the base	
				difference() {
					cylinder(h=base_height, r=cover_rad + base_lip_rad, center=true);		
					scale([1.01, 1.01, 1])
					cover();
					scale([0.98, 0.98, 1])
					cover();

				}
	
				// splash guards
				translate([bucket_width/drain_offset_ratio,0,guard_height/2])
				guard();

				translate([-bucket_width/drain_offset_ratio,0,guard_height/2])
				rotate([0,0,180])
				guard();

			}
			// drain holes
			translate([bucket_width/drain_offset_ratio,0,0])
			drain();

			translate([-bucket_width/drain_offset_ratio,0,0])
			drain();
		}

		// clips for bucket
		translate([-frame_base_length + (frame_base_length/2/2/2),bucket_width/2 + 1 + pivot_socket_width,base_height/2])
		bucket_clip();

		translate([frame_base_length - (frame_base_length/2/2/2),-bucket_width/2 - 1 - pivot_socket_width,base_height/2])
		rotate([0,0,180])
		bucket_clip();
	}
}	

//
// splash guard
//
module guard() {
	difference() {
		scale([drain_ratio,1,1]) {
			difference() {	
				cylinder(h=guard_height, r=drain_rad + guard_thickness,  center=true);
				cylinder(h=guard_height + 2, r=drain_rad, center=true);
			}
		}
		translate([-guard_length/2 , 0, 0]) 
		cube([guard_length , (drain_rad)* 2 ,guard_height + 2],center=true);
	}		
}


//
// drain hole
//
module drain() {
	scale([drain_ratio,1,1])
	// make the hole slightly larger then the bucket
	cylinder(h=base_height * 2, r=drain_rad, center=true);
}

//
// fixtures
//
module fixtures(){
	// add the electronics to check clearance, etc
	reed_switch();


	translate([0, bucket_width/2 + magnet_size, sensor_height])
	magnet();
}

module reed_switch() {
	cylinder(r=reed_width/2, h=reed_length);
}



//
// assembly
//
module main() {
	*cover();
	base();

	// pin is not in center of socket but this is where 
	// gravity will leave it
	translate([0,0,  
		base_height + frame_height + pivot_rad_outer/2 ])
	*bucket();
	//fixtures();

}

main();