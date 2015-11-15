// nose
cylinder(h=10, r1=5, r2=0);

// body
translate([0,0,-40])
cylinder(h=40, r1=5, r2=5);

// nozzle
translate([0,0,-45])
cylinder(h=5, r1=5, r2=2.5);

// fins
translate([-1.5,-10,-40])
cube([2,20,10]);
translate([-10,-0.5,-40])
cube([20,2,10]);


// windows
translate([-3,-3, -10])
sphere(2);
translate([3,-3, -10])
sphere(2);
translate([-3,3, -10])
sphere(2);
translate([3,3, -10])
sphere(2);