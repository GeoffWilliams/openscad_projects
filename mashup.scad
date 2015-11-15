plank_space = 5;
plank_length = 10;

union() {
	rotate([-15,0,0])
	import("../Downloads/Whale_t_simple.stl");
	scale([0.3,0.3,0.3])
	import("../Downloads/better_smokin_gnome_simple.stl");


	// planks
	for ( i = [0:6] )  {
		translate([plank_space + (i * 1.5) ,30 -i*10, -5 + i*1.5])
		rotate([0,45,0])
		cube([plank_length + (i*4) ,4,2], center = true);    
	}
	for ( i = [0:6] )  {
		translate([1 - (plank_space + (i * 1.5)) ,30 -i*10, -5 + i*1.5])
		rotate([0,-45,0])
		cube([plank_length + (i*4) ,4,2], center = true);    
	}

	for ( i = [0:6] )  {
		translate([(1 + i) * 1.2  ,30 -i*10, -5 - i * -0.8])
		rotate([0,22.5,0])
		cube([plank_length -1 + (i*5) ,4,2], center = true);    
	}
	for ( i = [0:6] )  {
		translate([0 - i * 1.2 ,30 -i*10, -5 - i * -0.8])
		rotate([0,-22.5,0])
		cube([plank_length -1 + (i*5) ,4,2], center = true);    
	}
}
