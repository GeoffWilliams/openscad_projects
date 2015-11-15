f_len = 80;
f_rad = 8;
nose_rad = 3;
aft_rad = 5;
s1_y = f_len/6;
s2_y = f_len/1.5;
w_le_rad = 5;
w_te_rad = 2;
wingspan=80;
w_width=40;

module wings() {
	rotate([0,90,0]) {
		hull() {
			cylinder(r=w_le_rad, h=wingspan, center=true);
			translate([0,w_width,0])
			cylinder(r=w_te_rad, h=wingspan, center=true);
		}
	}
}

module fin() {

}

module tail() {

}

module fuselage() {
	
	hull() {
		sphere(nose_rad);
		translate([0,s1_y,0])
		sphere(f_rad);
		translate([0,s2_y,0])
		sphere(f_rad);
		translate([0,f_len,0])
		sphere(aft_rad);
	}
}

module main() {
	fuselage();
	translate([0,f_len/2.5,0])
	wings();
}

main();