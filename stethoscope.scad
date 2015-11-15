$fn=100;
dia_rad=40;
dia_height=15;
dia_lip=4;
bell_rad=8;
bell_offset=10;
bell_height=50;
bell_hole_dia=1.5;

offset=4;
outlet_rad=6;
outlet_length=15;
bell_sphere_rad=bell_rad + bell_offset/1.5;
bell_sphere_ratio=0.5;
membrane_rad = dia_rad - offset * 2;
membrane_height = 3;

module diaphram() {
	union() {
		difference() {
		
			cylinder(	r1=dia_rad, 
							r2=bell_rad, 
							h=dia_height, 
							center=true);
			translate([0,0,-offset])		
			cylinder(	r1=dia_rad + offset + dia_lip/2, 
							r2=bell_rad, 
							h=dia_height , 
							center=true);
			cylinder(r=bell_rad, h=dia_height + 1, center=true); 

			// sink the membrane into the diaphram
			translate([0,0,-dia_height/2 -0.3 ])
			scale([1.05,1.05,1.05])
			membrane();
		}
		// lip
		translate([0,0,-dia_height/2 - dia_lip/2])
		difference() {
			cylinder(r=dia_rad, h=dia_lip, center=true);
			cylinder(r=dia_rad - offset, h=dia_lip + 1, center=true);
		}	
	}
}

module outlet() {
	rotate([90,0,0])
	cylinder(
		r=outlet_rad, 
		h=outlet_length, 
		center=true);
}

module outlet_hole() {
	rotate([90,0,0])
	cylinder(
		r=outlet_rad - offset/2 , 
		h=outlet_length * 2, 
		center=true);
}

module bell() {
	difference() {
		union() {
			// body
			cylinder(
				r1=bell_rad, 
				r2=bell_rad + bell_offset, 
				h=bell_height, 
				center=true);

			// outlets
			translate([
				0,
				bell_rad  + outlet_length/2, 
				-outlet_rad - offset])
			outlet();

			translate([
				0,
				bell_rad  + outlet_length/2, 
				outlet_rad + offset])
			outlet();
		}
		
		// holes for outlets
		translate([0,bell_rad, -outlet_rad - offset])
		outlet_hole();

		translate([0,bell_rad, outlet_rad + offset])
		outlet_hole();

		// cut for inside of bell
		translate([0,0,-offset])
		cylinder(
			r1=bell_rad - offset, 
			r2=bell_rad + bell_offset - offset, 
			h=bell_height + offset * 2 + 1, 
			center=true);
		 
	}

	translate([
		0,0,bell_height/2])	
	bell_top();

}

module bell_top() {

	difference() {
		sphere(bell_sphere_rad);
		translate([0,0,offset])
		sphere(bell_sphere_rad - offset/2); 
	
		translate([0,0, bell_sphere_rad])
		cube(bell_sphere_rad * 2, center=true);
		cylinder(
			r=bell_hole_dia, 
			h=bell_sphere_rad * 3 , 
			center=true);
	}
}

module membrane() {
	union() {
		difference() {
			cylinder(	r=membrane_rad, 
							h=membrane_height, 
							center=true);
			cylinder(	r=membrane_rad - offset , 
							h=membrane_height + 1, 
							center=true);	
		}
		translate([0,0,0.5]) {
			cube([
				membrane_rad * 2, 
				membrane_height, 
				membrane_height - 1],
				center=true);
			rotate([0,0,90])
			cube([
				membrane_rad * 2, 
				membrane_height, 
				membrane_height - 1],
				center=true);
		}
	}
}


module main() {
	union() {
		diaphram();
		translate([0,0,bell_height/2 + dia_height/2 - offset])
		bell();
	}
	translate([0,0,-membrane_height - 1])
	membrane();

	
}

module print() {
	diaphram();
}

print();